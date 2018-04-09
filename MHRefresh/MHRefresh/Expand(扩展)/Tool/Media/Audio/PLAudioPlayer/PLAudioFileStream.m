//
//  PLAudioFileStream.m
//  MHRefresh
//
//  Created by panle on 2018/3/9.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLAudioFileStream.h"
#import "PLFileProvider.h"
#import "PLParsedAudioDataModel.h"
#import <AudioToolbox/AudioToolbox.h>

#define kAQDefaultBufSize 2048

#define BitRateEstimationMaxPackets 5000
#define BitRateEstimationMinPackets 10

@interface PLAudioFileStream () {
    
    BOOL _discontinuous;
    
    AudioFileStreamID _audioFileStream;
    
    SInt64 _dataOffset;
    NSTimeInterval _packetDuration;
    
    UInt64 _processedPacketsCount;
    UInt64 _processedPacketsSizeTotal;
    
    UInt64 _audioDataByteCount;
    
    NSUInteger _seekTime;
    
    SInt64 _offset;
    
    BOOL _isNeedCalculateBitRate;
    
    unsigned long long _fileSize;
}

@end

@implementation PLAudioFileStream

@synthesize audioFormat = _audioFormat;

@synthesize bitRate = _bitRate;
@synthesize duration = _duration;
@synthesize maxPacketSize = _maxPacketSize;
@synthesize audioDataByteCount = _audioDataByteCount;

@synthesize readyToProducePackets = _readyToProducePackets;


#pragma mark - ======== callBack ========

static void PLAudioFileStreamPropertyListenerProc(void * inClientData,
                                                  AudioFileStreamID inAudioFileStream,
                                                  AudioFileStreamPropertyID inPropertyID,
                                                  AudioFileStreamPropertyFlags *ioFlags) {
    
    PLAudioFileStream *audioFileStream = (__bridge PLAudioFileStream *)(inClientData);
    [audioFileStream p_handlePropertyChangeForFileStream:inAudioFileStream fileStreamPropertyID:inPropertyID ioFlags:ioFlags];
}

static void PLAudioFileStreamPacketsProc(void *inClientData,
                                         UInt32 inNumberBytes,
                                         UInt32 inNumberPackets,
                                         const void *inInputData,
                                         AudioStreamPacketDescription *inPacketDescriptions) {
    PLAudioFileStream *audioFileStream = (__bridge PLAudioFileStream *)inClientData;
    [audioFileStream p_handleAudioFileStreamPackets:inInputData inNumberBytes:inNumberBytes inNumberPackets:inNumberPackets inPacketDescriptions:inPacketDescriptions];
}


#pragma mark - ======== init && dealloc ========

- (instancetype)initWithFileProvider:(PLFileProvider *)fileProvider {
    if (self = [super initWithAudioFileProvider:fileProvider]) {
        
        _isNeedCalculateBitRate = YES;
        _discontinuous = NO;
        _maxPacketSize = 0;
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
    
    return [self p_openAudioFileStreamWithTypeHint:self.fileType];
}

- (PLAudioStreamReadFileStatus)readData {
    
    NSData *data = [self.fileProvider readDataAtOffset:_offset length:1000];
    
    if (data.length) {
        _offset += data.length;
        return [self parseData:data];
    }
    
    if (self.fileProvider.isFinished) {
        return PLASRFStatusFinished;
    }
    
    if (self.fileProvider.isFailed) {
        return PLASRFStatusFail;
    }
    
    return PLASRFStatusWaiting;
}

- (PLAudioStreamReadFileStatus)parseData:(NSData *)data {
    
    if (_readyToProducePackets && _packetDuration == 0) {
        return PLASRFStatusFail;
    }
    
    OSStatus status = AudioFileStreamParseBytes(_audioFileStream, (UInt32)[data length], [data bytes], _discontinuous ? kAudioFileStreamParseFlag_Discontinuity : 0);
    
    if (status == noErr) {
        return PLASRFStatusSuccess;
    }
    
    switch (status) {
        case kAudioFilePositionError:
        case kAudioFileFileNotFoundError:
        case kAudioFileNotOpenError:
            return PLASRFStatusFail;
            
        case kAudioFileEndOfFileError:
            return PLASRFStatusFinished;
        
        default:
            return PLASRFStatusWaiting;
            break;
    }
}

- (nullable NSData *)fetchMagicCookie {
    
    if (![self isAvaiable]) {
        return nil;
    }
    
    UInt32 cookieSize;
    Boolean writeable;
    OSStatus status = AudioFileStreamGetPropertyInfo(_audioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, &writeable);
    if (status != noErr) {
        DLog(@"info kAudioFileStreamProperty_MagicCookieData fail");
        return nil;
    }
    
    void *cookieData = calloc(1, cookieSize);
    status = AudioFileStreamGetProperty(_audioFileStream, kAudioFileStreamProperty_MagicCookieData, &cookieSize, cookieData);
    if (status != noErr) {
        DLog(@"kAudioFileStreamProperty_MagicCookieData fail");
        return nil;
    }
    
    NSData *cookie = [NSData dataWithBytes:cookieData length:cookieSize];
    free(cookieData);
    
    return cookie;
}

- (SInt64)seekTime:(NSTimeInterval)time {
    
    [self p_calculateBitRate];
    
    if (_bitRate <= 0 || [self fileProvider].expectedLength <= 0) {
        return time;
    }
    
    [self p_calculateDuration];
    
    SInt64 approximateSeekOffset = _dataOffset + (time / _duration) * _audioDataByteCount;
    
    if (approximateSeekOffset > [self fileProvider].expectedLength - 2 * _maxPacketSize) {
        approximateSeekOffset = [self fileProvider].expectedLength - 2 * _maxPacketSize;
    }

    _seekTime = time;
    
    UInt32 ioFlag = 0;
    SInt64 packetAlignedByteOffset;
    SInt64 seekPacket = floor(time / _packetDuration);
    OSStatus status = AudioFileStreamSeek(_audioFileStream, seekPacket, &packetAlignedByteOffset, &ioFlag);
    if (status == noErr && !(ioFlag & kAudioFileStreamSeekFlag_OffsetIsEstimated)) {
        _seekTime -= ((approximateSeekOffset - _dataOffset) - packetAlignedByteOffset) * 8.0 / _bitRate;
        _offset = packetAlignedByteOffset + _dataOffset;
    } else {
        _discontinuous = YES;
        _offset = approximateSeekOffset;
    }
    
    return _seekTime;
}

- (void)close {
    if ([self isAvaiable]) {
        AudioFileStreamClose(_audioFileStream);
        _audioFileStream = NULL;
    }
}

#pragma mark - ======== getter ========

- (AudioStreamBasicDescription)audioFormat {
    return _audioFormat;
}

- (BOOL)isAvaiable {
    return _audioFileStream != NULL;
}

- (BOOL)isReadyToProducePackets {
    return _readyToProducePackets;
}

#pragma mark - ======== private ========

- (BOOL)p_openAudioFileStreamWithTypeHint:(AudioFileTypeID)fileTypeHint {
    
    OSStatus status = AudioFileStreamOpen((__bridge void *)self, PLAudioFileStreamPropertyListenerProc, PLAudioFileStreamPacketsProc, fileTypeHint, &_audioFileStream);
    
    if (status != noErr) {
        _audioFileStream = NULL;
    }
    
    return status == noErr;
}

- (void)p_handlePropertyChangeForFileStream:(AudioFileStreamID)inAudioFileStream
                       fileStreamPropertyID:(AudioFileStreamPropertyID)inPropertyID
                                    ioFlags:(UInt32 *)ioFlags {
    
    if (inPropertyID == kAudioFileStreamProperty_ReadyToProducePackets) {
        
        _discontinuous = YES;
        
        //获取最大卡包size 用于创建queue
        UInt32 sizeOfUInt32 = sizeof(UInt32);
        //kAudioFileStreamProperty_PacketSizeUpperBound UInt32值，指示流式文件中的理论最大数据包大小。 例如，该值对于确定最小缓冲区大小非常有用。
        OSStatus status = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_PacketSizeUpperBound, &sizeOfUInt32, &_maxPacketSize);
        
        if (status != noErr || _maxPacketSize == 0) {
            //kAudioFileStreamProperty_MaximumPacketSize 流文件中最大数据包大小
            
            status = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_MaximumPacketSize, &sizeOfUInt32, &_maxPacketSize);
            
            if (status != noErr || _maxPacketSize == 0) {
                _maxPacketSize = kAQDefaultBufSize;
            }
        }
        
        _readyToProducePackets = YES;
        
        //回调数据  准备创建音频队列
        if ([self.delegate respondsToSelector:@selector(pl_audioFileStreamReadyToProducePackets:)]) {
            [self.delegate pl_audioFileStreamReadyToProducePackets:self];
        }
        
    } else if (inPropertyID == kAudioFileStreamProperty_DataOffset) {
        
        UInt32 offsetSize = sizeof(_dataOffset);
        OSStatus status = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_DataOffset, &offsetSize, &_dataOffset);
        if (status != noErr) {
            DLog(@"kAudioFileStreamProperty_DataOffset fail");
            return;
        }
        
        //修正字节长度
        _audioDataByteCount = [self fileProvider].expectedLength - _dataOffset;
        
        [self p_calculateDuration];
        
    } else if (inPropertyID == kAudioFileStreamProperty_AudioDataByteCount) {
        
        UInt32 byteCountSize = sizeof(UInt64);
        OSStatus status = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_AudioDataByteCount, &byteCountSize, &_audioDataByteCount);
        if (status != noErr) {
            DLog(@"kAudioFileStreamProperty_AudioDataByteCount fail");
            return;
        }
        
    } else if (inPropertyID == kAudioFileStreamProperty_DataFormat) {
        
        if (self.audioFormat.mSampleRate == 0) {
            UInt32 absdSize = sizeof(_audioFormat);
            
            OSStatus status = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_DataFormat, &absdSize, &_audioFormat);
            
            if (status != noErr) {
                DLog(@"kAudioFileStreamProperty_DataFormat fail");
            }
            
            [self p_calculatepPacketDuration];
        }
        
    } else if (inPropertyID == kAudioFileStreamProperty_FormatList) {
        
        Boolean outWriteable;
        UInt32 formatListSize;
        
        OSStatus status = AudioFileStreamGetPropertyInfo(inAudioFileStream, kAudioFileStreamProperty_FormatList, &formatListSize, &outWriteable);
        if (status != noErr) {
            DLog(@"info kAudioFileStreamProperty_FormatList fail");
            return;
        }
        
        
        AudioFormatListItem *formatList = malloc(formatListSize);
        status = AudioFileStreamGetProperty(inAudioFileStream, kAudioFileStreamProperty_FormatList, &formatListSize, &formatList);
        if (status != noErr) {
            DLog(@"kAudioFileStreamProperty_FormatList fail");
            free(formatList);
            return;
        }
        
        UInt32 supportedFormatSize;
        status = AudioFormatGetPropertyInfo(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatSize);
        if (status != noErr) {
            DLog(@"kAudioFormatProperty_DecodeFormatIDs fail");
            free(formatList);
            return;
        }
        
        UInt32 supportdFormatCount = supportedFormatSize / sizeof(OSType);
        OSType *supportedFormats = (OSType *)malloc(supportedFormatSize);
        status = AudioFormatGetProperty(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatSize, supportedFormats);
        if (status != noErr) {
            DLog(@"kAudioFormatProperty_DecodeFormatIDs fail");
            free(formatList);
            free(supportedFormats);
            return;
        }
        
        for (int i = 0; i * sizeof(AudioFormatListItem) < formatListSize; i += sizeof(AudioFormatListItem)) {
            
            AudioStreamBasicDescription asbd = formatList[i].mASBD;
            
            for (UInt32 j = 0; j < supportdFormatCount; j++) {
                if (asbd.mFormatID == supportedFormats[j]) {
                    _audioFormat = asbd;
                    [self p_calculatepPacketDuration];
                    break;
                }
            }
        }
        
        free(supportedFormats);
        free(formatList);
        
    } else if (inPropertyID == kAudioFileStreamProperty_BitRate) {
        
        UInt32 size = sizeof(UInt32);
        OSStatus status = AudioFileStreamGetProperty(_audioFileStream, kAudioFileStreamProperty_BitRate, &size, &_bitRate);
        if (status != noErr) {
            _isNeedCalculateBitRate = NO;
            DLog(@"kAudioFilePropertyBitRate fail");
        }
        
    } else {
        DLog(@"other kAudioFileStreamProperty");
    }
}

- (void)p_handleAudioFileStreamPackets:(const void *)inInputData
                         inNumberBytes:(UInt32)inNumberBytes
                       inNumberPackets:(UInt32)inNumberPackets
                  inPacketDescriptions:(AudioStreamPacketDescription *)inPacketDescriptions {
    
    if (_discontinuous) {
        _discontinuous = NO;
    }
    
    if (_bitRate == 0) {
        _bitRate = ~0;
    }
    
    if (inNumberBytes == 0 || inNumberPackets == 0) {
        return;
    }
    
    BOOL isFreePacketDescriptions = NO;
    
    if (inPacketDescriptions == NULL) {
        
        UInt32 packetSize = inNumberBytes / inNumberPackets;
        
        AudioStreamPacketDescription *pDescriptions = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription) * inNumberPackets);
        
        for (int i = 0; i < inNumberPackets; i++) {
            UInt32 packetOffent = packetSize * i;
            pDescriptions[i].mStartOffset = packetOffent;
            pDescriptions[i].mVariableFramesInPacket = 0;
            
            if (i == inNumberPackets - 1) {
                pDescriptions[i].mDataByteSize = inNumberBytes - packetOffent;
            } else {
                pDescriptions[i].mDataByteSize = packetSize;
            }
        }
        
        inPacketDescriptions = pDescriptions;
        
        isFreePacketDescriptions = YES;
    }
    
    
    NSMutableArray <PLParsedAudioDataModel *> *dataArray = [[NSMutableArray alloc] initWithCapacity:inNumberPackets];
    for (NSInteger i = 0; i < inNumberPackets; i++) {
        
        SInt64 packetOffset = inPacketDescriptions[i].mStartOffset;
        SInt64 packetSize = inPacketDescriptions[i].mDataByteSize;
        
        PLParsedAudioDataModel *dataModel = [PLParsedAudioDataModel initWithParsedAudioDataWithBytes:inInputData + packetOffset packetDescription:inPacketDescriptions[i]];
        [dataArray addObject:dataModel];
        
        if (_processedPacketsCount < BitRateEstimationMaxPackets) {
            _processedPacketsCount += 1;
            _processedPacketsSizeTotal += packetSize;
            [self p_calculateBitRate];
            [self p_calculateDuration];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(pl_audioFileStream:audioDataArray:)]) {
        [self.delegate pl_audioFileStream:self audioDataArray:dataArray];
    }
    
    if (isFreePacketDescriptions) {
        free(inPacketDescriptions);
    }
}

- (void)p_calculateBitRate {
    
    if (!_isNeedCalculateBitRate) {
        return;
    }
    
    if (_packetDuration && _processedPacketsCount > BitRateEstimationMinPackets && _processedPacketsCount <= BitRateEstimationMaxPackets) {
        double averagePacketByteSize = _processedPacketsSizeTotal / _processedPacketsCount;
        _bitRate = 8.0 * averagePacketByteSize / _packetDuration;
    }
}

- (void)p_calculateDuration {
    
    if ([self fileProvider].expectedLength > 0 && _bitRate > 0) {
//        DLog(@"%llu %lld %u", [self fileProvider].expectedLength, _dataOffset, (unsigned int)_bitRate);
        _duration = ([self fileProvider].expectedLength - _dataOffset) * 8.0 / _bitRate;
    }
}

- (void)p_calculatepPacketDuration {
    
    if (_audioFormat.mSampleRate > 0) {
        _packetDuration = _audioFormat.mFramesPerPacket / _audioFormat.mSampleRate;
    }
}

@end
