//
//  QYAudioFile.m
//  MHRefresh
//
//  Created by panle on 2018/3/1.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYAudioFile.h"
#import "QYParsedAudioData.h"
#import <AudioToolbox/AudioFormat.h>

static const UInt32 packetPerRead = 15;

@interface QYAudioFile () {
    SInt64 _packetOffset;
    NSFileHandle *_fileHandler;
    
    SInt64 _dataOffset;
    NSTimeInterval _packetDuration;
    
    AudioFileID _audioFileID;
}

@end

@implementation QYAudioFile

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(AudioFileTypeID)fileType {
    if (self = [super init]) {
        _filePath = [filePath copy];
        _fileType = fileType;
        
        _fileHandler = [NSFileHandle fileHandleForReadingAtPath:_filePath];
        _fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:_filePath error:nil].fileSize;
        
        if (_fileHandler && _fileSize > 0) {
            if ([self p_openAudioFile]) {
                [self p_fetchFormatInfo];
            }
        } else {
            [_fileHandler closeFile];
        }
    }
    return self;
}

- (void)dealloc {
    [_fileHandler closeFile];
    [self p_closeAudioFile];
}

- (BOOL)p_openAudioFile {
    
    OSStatus status = AudioFileOpenWithCallbacks((__bridge void *)self,
                                                 QYAudioFile_ReadProc,
                                                 NULL,
                                                 MCAudioFileGetSizeCallBack,
                                                 NULL,
                                                 _fileType,
                                                 &_audioFileID);
    
    if (status != noErr) {
        _audioFileID = NULL;
        return NO;
    }
    
    return YES;
}

- (void)p_fetchFormatInfo {
    
    UInt32 formatListSize;
    OSStatus status = AudioFileGetPropertyInfo(_audioFileID, kAudioFilePropertyFormatList, &formatListSize, NULL);
    
    if (status == noErr) {
        BOOL found = NO;
        AudioFormatListItem *formatList = malloc(formatListSize);
        OSStatus status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyFormatList, &formatListSize, formatList);
        
        if (status == noErr) {
            UInt32 supportedFormatSize;
            status = AudioFormatGetPropertyInfo(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatSize);
            
            if (status == !noErr) {
                free(formatList);
                [self p_closeAudioFile];
                return;
            }
            
            UInt32 supportFormatCount = supportedFormatSize / sizeof(OSType);
            OSType *supportedFormats = (OSType *)malloc(supportedFormatSize);
            status = AudioFormatGetProperty(kAudioFormatProperty_DecodeFormatIDs, 0, NULL, &supportedFormatSize, supportedFormats);
            if (status != noErr) {
                free(formatList);
                free(supportedFormats);
                [self p_closeAudioFile];
                return;
            }
            
            for (int i = 0; i * sizeof(AudioFormatListItem) < formatListSize; i++ ) {
                AudioStreamBasicDescription format = formatList[i].mASBD;
                
                for (UInt32 j = 0; j < supportFormatCount; j++) {
                    if (format.mFormatID == supportedFormats[j]) {
                        _format = format;
                        found = YES;
                        break;
                    }
                }
            }
            free(supportedFormats);
        }
        free(formatList);
        
        if (!found) {
            [self p_openAudioFile];
            return;
        } else {
            [self p_calculatepPacketDuration];
        }
    }
    
    UInt32 size = sizeof(_bitRate);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyBitRate, &size, &_bitRate);
    if (status != noErr) {
        [self p_closeAudioFile];
        return;
    }
    
    
    UInt32 isBitRate = 0;
    status = AudioFileGetPropertyInfo(_audioFileID, kAudioFilePropertyBitRate, &size, &isBitRate);
    
    if (isBitRate) {
        DLog(@"允许写");
        UInt32 bitRate = _bitRate * 2;
        NSLog(@"%ud", bitRate);
        status = AudioFileSetProperty(_audioFileID, kAudioFilePropertyBitRate, bitRate, &bitRate);
        if (status == noErr) {
            NSLog(@"设置完成");
        }
    } else {
        DLog(@"不允许写");
    }
    
    
    size = sizeof(_dataOffset);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyDataOffset, &size, &_dataOffset);
    if (status != noErr) {
        [self p_closeAudioFile];
        return;
    }
    _audioDataByteCount = _fileSize - _dataOffset;
    
    size = sizeof(_duration);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyEstimatedDuration, &size, &_duration);
    if (status == noErr) {
        [self p_calculateDuration];
    }
    
    size = sizeof(_maxPacketSize);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyPacketSizeUpperBound, &size, &_maxPacketSize);
    if (status != noErr || _maxPacketSize == 0) {
        status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyMaximumPacketSize, &size, &_maxPacketSize);
        if (status != noErr) {
            [self p_closeAudioFile];
            return;
        }
    }
}

- (NSData *)fetchMagicCookie {
    
    UInt32 cookieSize;
    OSStatus status = AudioFileGetPropertyInfo(_audioFileID, kAudioFilePropertyMagicCookieData, &cookieSize, NULL);
    if (status != noErr) {
        return nil;
    }
    
    void *cookieData = malloc(cookieSize);
    status = AudioFileGetProperty(_audioFileID, kAudioFilePropertyMagicCookieData, &cookieSize, cookieData);
    if (status != noErr) {
        
        return nil;
    }
    
    NSData *cookie = [NSData dataWithBytes:cookieData length:cookieSize];
    free(cookieData);
    
    return cookie;
}

- (NSArray *)parseData:(BOOL *)isEof {
    
    UInt32 ioNumPackets = packetPerRead;
    UInt32 ioNumBytes = ioNumPackets * _maxPacketSize;
    void * outBuffer = (void *)malloc(ioNumBytes);
    
    AudioStreamPacketDescription *outPacketDescriptions = NULL;
    OSStatus status = noErr;
    UInt32 descSize = sizeof(AudioStreamPacketDescription) * ioNumPackets;
    outPacketDescriptions = (AudioStreamPacketDescription *)malloc(descSize);
    status = AudioFileReadPacketData(_audioFileID, false, &ioNumBytes, outPacketDescriptions, _packetOffset, &ioNumPackets, outBuffer);
    
    if (status != noErr) {
        *isEof = status == kAudioFileEndOfFileError;
        free(outBuffer);
        return nil;
    }
    
    if (ioNumBytes == 0) {
        *isEof = YES;
    }
    
    _packetOffset += ioNumPackets;
    
    if (ioNumPackets > 0) {
        
        NSMutableArray *parsedDataArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < ioNumPackets; ++i)
        {
            AudioStreamPacketDescription packetDescription;
            if (outPacketDescriptions)
            {
                packetDescription = outPacketDescriptions[i];
            }
            else
            {
                packetDescription.mStartOffset = i * _format.mBytesPerPacket;
                packetDescription.mDataByteSize = _format.mBytesPerPacket;
                packetDescription.mVariableFramesInPacket = _format.mFramesPerPacket;
            }
            QYParsedAudioData *parsedData = [QYParsedAudioData parsedAudioDataWithBytes:outBuffer + packetDescription.mStartOffset
                                                                      packetDescription:packetDescription];
            if (parsedData)
            {
                [parsedDataArray addObject:parsedData];
            }
        }
        return parsedDataArray;
    }
    
    return nil;
}

- (void)seekToTime:(NSTimeInterval)time {
    _packetOffset = floor(time / _packetDuration);
}

- (void)p_calculateDuration {
    if (_fileSize > 0 && _bitRate > 0) {
        _duration = (_fileSize - _dataOffset) * 8 / _bitRate;
    }
}

- (void)p_calculatepPacketDuration {
    
    if (_format.mSampleRate > 0) {
        
        _packetDuration = _format.mFramesPerPacket / _format.mSampleRate;
    }
}

- (void)p_closeAudioFile {
    if (self.available) {
        AudioFileClose(_audioFileID);
        _audioFileID = NULL;
    }
}

- (void)close {
    [self p_closeAudioFile];
}


- (UInt32)availableDataLengthAtOffset:(SInt64)inPosition maxLength:(UInt32)requestCount {
    
    if ((inPosition + requestCount) > _fileSize) {
        if (inPosition > _fileSize) {
            return 0;
        } else {
            return (UInt32)(_fileSize - inPosition);
        }
    } else {
        return requestCount;
    }
}

- (NSData *)dataAtOffset:(SInt64)inPosition length:(UInt32)length {
    
    [_fileHandler seekToFileOffset:inPosition];
    return [_fileHandler readDataOfLength:length];
}

//a function that will be called when AudioFile needs to read data.
static OSStatus QYAudioFile_ReadProc(void *inClientData,
                                     SInt64 inPosition,
                                     UInt32 requestCount,
                                     void * buffer,
                                     UInt32 * actualCount) {
    
    QYAudioFile *audioFile = (__bridge QYAudioFile *)inClientData;
    
    *actualCount = [audioFile availableDataLengthAtOffset:inPosition maxLength:requestCount];
    
    if (*actualCount > 0) {
        NSData *data = [audioFile dataAtOffset:inPosition length:*actualCount];
        memcpy(buffer, [data bytes], [data length]);
    }
    
    return noErr;
}

static SInt64 MCAudioFileGetSizeCallBack(void *inClientData) {
    
    QYAudioFile *audioFile = (__bridge QYAudioFile *)inClientData;
    return audioFile.fileSize;
}

@end
