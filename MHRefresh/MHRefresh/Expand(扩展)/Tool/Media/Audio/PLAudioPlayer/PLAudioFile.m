//
//  PLAudioFile.m
//  MHRefresh
//
//  Created by panle on 2018/3/12.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLAudioFile.h"
#import "PLFileProvider.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PLParsedAudioDataModel.h"

#define BitRateEstimationMinPackets 10

static const UInt32 kPacketPerRead = 15;

@interface PLAudioFile () {
    SInt64 _dataOffset;
    
    SInt64 _packetOffset;
    NSTimeInterval _packetDuration;
    
    AudioFileID _audioFileID;
}

@end

@implementation PLAudioFile

@synthesize audioFormat = _audioFormat;

@synthesize bitRate = _bitRate;
@synthesize duration = _duration;
@synthesize maxPacketSize = _maxPacketSize;
@synthesize audioDataByteCount = _audioDataByteCount;

@synthesize readyToProducePackets = _readyToProducePackets;


#pragma mark - ======== callBack ========

static OSStatus PLAudioFileReadProc(void *inClientData,
                                    SInt64 inPosition,
                                    UInt32 requestCount,
                                    void *buffer,
                                    UInt32 *actualCount) {
    
    PLAudioFile *audioFile = (__bridge PLAudioFile *)inClientData;
    
    *actualCount = [audioFile p_ActulCountWithInPosition:inPosition requestCount:requestCount];

    if (*actualCount > 0) {
        NSData *data = [audioFile p_dataAtOffset:inPosition length:*actualCount];
        memcpy(buffer, [data bytes], [data length]);
    }
    
    return noErr;
}

static SInt64 PLAudioFileGetSizeProc(void *inClientData) {
    
    PLAudioFile *audioFile = (__bridge PLAudioFile *)inClientData;
    return (SInt64)audioFile.fileProvider.expectedLength;
}


#pragma mark - ======== init && dealloc ========

- (instancetype)initWithFileProvider:(PLFileProvider *)fileProvider {
    if (self = [super initWithAudioFileProvider:fileProvider]) {
        
    }
    return self;
}

- (void)dealloc {
    DLOG_DEALLOC
    [self close];
}


#pragma mark - ======== overwrite ========

- (BOOL)open {
    
    if ([self isAvaiable]) {
        return YES;
    }
    
    if (![self p_openWithFileTypeHint:(AudioFileTypeID)self.fileType] &&
        ![self p_openWithFallBacks]) {
        _audioFileID = NULL;
        return NO;
    }
    
    if (![self p_fillFileFormat] ||
        ![self p_fillMiscProperties]) {
        AudioFileClose(_audioFileID);
        _audioFileID = NULL;
        return NO;
    }
    
    return YES;
}

- (BOOL)p_fillFileFormat {
    
    UInt32 formatListSize;
    OSStatus status;
    
    status = AudioFileGetPropertyInfo(_audioFileID, kAudioFilePropertyFormatList, &formatListSize, NULL);
    if (status != noErr) {
        DLog(@"info kAudioFilePropertyFormatList fail");
        return NO;
    }
    
    AudioFormatListItem *formatList = (AudioFormatListItem *)malloc(formatListSize);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyFormatList, &formatListSize, formatList);
    if (status != noErr) {
        free(formatList);
        DLog(@"kAudioFilePropertyFormatList fail");
        return NO;
    }
    
    UInt32 numFormats = formatListSize / sizeof(AudioFormatListItem);
    
    if (numFormats == 1) {
        _audioFormat = formatList[0].mASBD;
    } else {
        UInt32 supportedFormatSize;
        status = AudioFormatGetPropertyInfo(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatSize);
        if (status != noErr) {
            free(formatList);
            DLog(@"kAudioFormatProperty_DecodeFormatIDs fail");
            return NO;
        }
        
        UInt32 numDecoders = supportedFormatSize / sizeof(OSType);
        OSType *decoderIDS = (OSType *)malloc(supportedFormatSize);
        status = AudioFormatGetProperty(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatSize, decoderIDS);
        if (status != noErr) {
            free(formatList);
            free(decoderIDS);
            DLog(@"kAudioFormatProperty_DecodeFormatIDs fail");
            return NO;
        }
        
        UInt32 i = 0;
        for (i = 0; i * sizeof(AudioFormatListItem) < numFormats; i++) {
            OSType decoderID = formatList[i].mASBD.mFormatID;
            
            BOOL found = NO;
            for (UInt32 j = 0; j < numDecoders; j++) {
                if (decoderID == decoderIDS[j]) {
                    found = YES;
                    break;
                }
            }
            
            if (found) {
                break;
            }
        }
        
        free(decoderIDS);
        
        if (i >= numFormats) {
            free(formatList);
            DLog(@"kAudioFormatProperty_DecodeFormatIDs fail");
            return NO;
        }
        
        _audioFormat = formatList[i].mASBD;
    }
    
    [self p_calculatepPacketDuration];
    
    free(formatList);
    return YES;
}

- (BOOL)p_fillMiscProperties {
    
    UInt32 size;
    OSStatus status;
    
    UInt32 bitRate = 0;
    size = sizeof(&bitRate);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyBitRate, &size, &bitRate);
    if (status != noErr) {
        DLog(@"kAudioFilePropertyBitRate fail");
//        return NO;
    }
    _bitRate = bitRate;
    
    SInt64 dataOffset = 0;
    size = sizeof(dataOffset);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyDataOffset, &size, &dataOffset);
    if (status != noErr) {
        DLog(@"kAudioFilePropertyDataOffset fail");
        return NO;
    }
    _dataOffset = dataOffset;
    
    _audioDataByteCount = [self fileProvider].expectedLength - _dataOffset;
    
    NSTimeInterval duration = 0;
    size = sizeof(duration);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyEstimatedDuration, &size, &duration);
    if (status != noErr) {
        DLog(@"kAudioFilePropertyEstimatedDuration fail");
        return NO;
    }
    _duration = duration;
    [self p_calculateDuration];
    
    UInt32 maxPackageSize = 0;
    size = sizeof(maxPackageSize);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyPacketSizeUpperBound, &size, &maxPackageSize);
    if (status != noErr || maxPackageSize == 0) {
        status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyMaximumPacketSize, &size, &maxPackageSize);
        if (status != noErr) {
            DLog(@"kAudioFilePropertyMaximumPacketSize | kAudioFilePropertyPacketSizeUpperBound fail");
            return NO;
        }
    }
    _maxPacketSize = maxPackageSize;
    
    return YES;
}


- (PLAudioStreamReadFileStatus)readData {
    
    if (!self.isAvaiable) {
        return PLASRFStatusFail;
    }
    
    if (self.fileProvider.isFailed) {
        return PLASRFStatusFail;
    }
    
    UInt32 ioNumPackets = kPacketPerRead;
    UInt32 ioNumBytes = ioNumPackets * _maxPacketSize;
    void *outBuffer = (void *)malloc(ioNumBytes);
    
    AudioStreamPacketDescription *outPacketDescriptions = NULL;
    OSStatus status = noErr;
    
    if (_audioFormat.mFormatID == kAudioFormatLinearPCM) {
        status = AudioFileReadPacketData(_audioFileID, false, &ioNumBytes, outPacketDescriptions, _packetOffset, &ioNumPackets, outBuffer);
    } else {
        UInt32 descSize = sizeof(AudioStreamPacketDescription) * ioNumPackets;
        outPacketDescriptions = (AudioStreamPacketDescription *)malloc(descSize);
        status = AudioFileReadPacketData(_audioFileID, false, &ioNumBytes, outPacketDescriptions, _packetOffset, &ioNumPackets, outBuffer);
    }
    
    if (status != noErr) {
        DLog(@"AudioFileReadPacketData fail");
        free(outBuffer);
        return status == kAudioFileEndOfFileError ? PLASRFStatusFinished : PLASRFStatusWaiting;
    }
    
    _packetOffset += ioNumPackets;
    
    if (ioNumPackets > 0) {
        
        NSMutableArray <PLParsedAudioDataModel *>*parsedDataArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < ioNumPackets; i++) {
            AudioStreamPacketDescription packetDescription;
            
            if (outPacketDescriptions) {
                packetDescription = outPacketDescriptions[i];
            } else {
                packetDescription.mStartOffset = i * _audioFormat.mBytesPerPacket;
                packetDescription.mDataByteSize = _audioFormat.mBytesPerPacket;
                packetDescription.mVariableFramesInPacket = _audioFormat.mFramesPerPacket;
            }
            
            PLParsedAudioDataModel *dataModel = [PLParsedAudioDataModel initWithParsedAudioDataWithBytes:outBuffer + packetDescription.mStartOffset packetDescription:packetDescription];
            
            if (dataModel) {
                [parsedDataArray addObject:dataModel];
            }
        }
        
        if (!parsedDataArray.count) {
            return PLASRFStatusWaiting;
        }
        
        if ([self.delegate respondsToSelector:@selector(pl_audioFileStream:audioDataArray:)]) {
            [self.delegate pl_audioFileStream:self audioDataArray:parsedDataArray];
        }
    }
    
    if (ioNumBytes == 0) {
        DLog(@"文件已读完");
        return PLASRFStatusFinished;
    }
    
    return PLASRFStatusSuccess;
}

- (nullable NSData *)fetchMagicCookie {
    
    if (![self isAvaiable]) {
        return nil;
    }
    
    UInt32 cookieSize;
    UInt32 readOnly = 0;
    OSStatus status = AudioFileGetPropertyInfo(_audioFileID, kAudioFilePropertyMagicCookieData, &cookieSize, &readOnly);
    if (status != noErr) {
        DLog(@"info kAudioFilePropertyMagicCookieData fail");
        return nil;
    }

    void *cookieData = malloc(cookieSize);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyMagicCookieData, &cookieSize, cookieData);
    if (status != noErr) {
        DLog(@"kAudioFilePropertyMagicCookieData fail");
        free(cookieData);
        return nil;
    }
    
    NSData *cookie = [NSData dataWithBytes:cookieData length:cookieSize];
    free(cookieData);
    
    return cookie;
}

- (SInt64)seekTime:(NSTimeInterval)time {
    _packetOffset = floor(time / _packetDuration);
    return time;
}

- (void)close {
    if ([self isAvaiable]) {
        AudioFileClose(_audioFileID);
        _audioFileID = NULL;
    }
}

#pragma mark - ======== getter ========

- (AudioStreamBasicDescription)audioFormat {
    return _audioFormat;
}

- (BOOL)isAvaiable {
    return _audioFileID != NULL;
}

- (BOOL)isReadyToProducePackets {
    return [self isAvaiable];
}

#pragma mark - ======== private ========

- (BOOL)p_openWithFileTypeHint:(AudioFileTypeID)fileTypeHint {
    
    OSStatus status = AudioFileOpenWithCallbacks((__bridge void *)self, PLAudioFileReadProc, NULL, PLAudioFileGetSizeProc, NULL, fileTypeHint, &_audioFileID);
    return status == noErr;
}

- (BOOL)p_openWithFallBacks {
    
    NSArray *fallbackTypeIDs = [self p_fallbackTypeIDs];
    for (NSNumber *typeIDNumber in fallbackTypeIDs) {
        AudioFileTypeID typeID = (AudioFileTypeID)[typeIDNumber unsignedLongValue];
        if ([self p_openWithFileTypeHint:typeID]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSArray *)p_fallbackTypeIDs {
    
    NSMutableArray *fallbackTypeIDs = [NSMutableArray array];
    NSMutableSet *fallbackTypeIDSet = [NSMutableSet set];
    
    struct {
        CFStringRef specifier;
        AudioFilePropertyID propertyID;
    } properties[] = {
        { (__bridge CFStringRef)[self.fileProvider mimeType], kAudioFileGlobalInfo_TypesForMIMEType },
        { (__bridge CFStringRef)[self.fileProvider fileExtension], kAudioFileGlobalInfo_TypesForExtension }
    };
    
    const size_t numberOfProperties = sizeof(properties) / sizeof(properties[0]);
    
    for (size_t i = 0; i < numberOfProperties; ++i) {
        if (properties[i].specifier == NULL) {
            continue;
        }
        
        UInt32 outSize = 0;
        OSStatus status;
        
        status = AudioFileGetGlobalInfoSize(properties[i].propertyID,
                                            sizeof(properties[i].specifier),
                                            &properties[i].specifier,
                                            &outSize);
        if (status != noErr) {
            continue;
        }
        
        size_t count = outSize / sizeof(AudioFileTypeID);
        AudioFileTypeID *buffer = (AudioFileTypeID *)malloc(outSize);
        if (buffer == NULL) {
            continue;
        }
        
        status = AudioFileGetGlobalInfo(properties[i].propertyID,
                                        sizeof(properties[i].specifier),
                                        &properties[i].specifier,
                                        &outSize,
                                        buffer);
        if (status != noErr) {
            free(buffer);
            continue;
        }
        
        for (size_t j = 0; j < count; ++j) {
            NSNumber *tid = [NSNumber numberWithUnsignedLong:buffer[j]];
            if ([fallbackTypeIDSet containsObject:tid]) {
                continue;
            }
            
            [fallbackTypeIDs addObject:tid];
            [fallbackTypeIDSet addObject:tid];
        }
        
        free(buffer);
    }
    
    return fallbackTypeIDs;
}

- (UInt32)p_ActulCountWithInPosition:(SInt64)inPosition requestCount:(UInt32)requestCount {
    if ((inPosition + requestCount) > [self fileProvider].expectedLength) {
        if (inPosition >= [self fileProvider].expectedLength) {
            return 0;
        } else {
            return (UInt32)([self fileProvider].expectedLength - inPosition);
        }
    }
    return requestCount;
}

- (NSData *)p_dataAtOffset:(SInt64)inPosition length:(UInt32)length {
    
    //文件提供者提供字节//
    return [[self fileProvider] readDataAtOffset:inPosition length:length];
}

- (void)p_calculatepPacketDuration {
    
    if (_audioFormat.mSampleRate > 0) {
        _packetDuration = _audioFormat.mFramesPerPacket / _audioFormat.mSampleRate;
    }
}

- (void)p_calculateDuration {
    if ([self fileProvider].expectedLength > 0 && _bitRate > 0) {
        _duration = ([self fileProvider].expectedLength - _dataOffset) * 8 / _bitRate;
    }
}

@end
