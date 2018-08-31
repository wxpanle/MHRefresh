//
//  PLFileProvider.m
//  MHRefresh
//
//  Created by panle on 2018/3/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLFileProvider.h"
#import "PLAudioHTTPRequest.h"
#import <AudioToolbox/AudioToolbox.h>
#import <CommonCrypto/CommonDigest.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSString+QYMD5.h"
#import "PLAudioFileSource.h"

@interface PLFileProvider () {
@protected
    id <PLAudioFileSource> _audioFileSource;
    NSString *_cachedPath;
    NSURL *_cachedURL;
    NSString *_mimeType;
    NSString *_fileExtension;
    NSString *_sha256;
    NSData *_mappedData;
    unsigned long long _expectedLength;
    unsigned long long _receivedLength;
    BOOL _failed;
    CGFloat _downloadProgress;
}

- (instancetype)initWithAudioFileSource:(id <PLAudioFileSource>)audioFile;
- (UInt32)p_fileTypeIdWithFileExtension:(NSString *)fileExtension;
@end

#pragma mark - ======== PLLocalFileProvider ========

@interface PLLocalFileProvider : PLFileProvider {
    NSFileHandle *_fileHandler;
    BOOL _isReady;
}

@property (nonatomic, copy) NSData *audioData;

@end

@implementation PLLocalFileProvider

- (instancetype)initWithAudioFileSource:(id<PLAudioFileSource>)audioFile {
    
    if (self = [super initWithAudioFileSource:audioFile]) {
        
        NSURL *url = [audioFile audioFileSourceUrl];
        
        if (url != nil) {

            _cachedURL = url;
            _cachedPath = [_cachedURL path];
            
            BOOL isDirectory = NO;
            if (![[NSFileManager defaultManager] fileExistsAtPath:_cachedPath isDirectory:&isDirectory] || isDirectory) {
                return nil;
            }
            
            _expectedLength = [[NSFileManager defaultManager] attributesOfItemAtPath:_cachedPath error:nil].fileSize;
            _receivedLength = _expectedLength;
            
            _isReady = YES;
            
        } else {
            _expectedLength = 0;
            _receivedLength = 0;
            _isReady = NO;
            WeakSelf
            [audioFile audioFileSourceUrl:^(NSURL *audioUrl) {
                StrongSelf
                if (!strongSelf) {
                    return;
                }
                [strongSelf startLoadDataWithAudioUrl:audioUrl];
            }];
        }
    }
    return self;
}

- (void)startLoadDataWithAudioUrl:(NSURL *)audioUrl {
    
    _cachedURL = audioUrl;
    _cachedPath = [_cachedURL path];
    
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:_cachedPath isDirectory:&isDirectory] || isDirectory) {
        return;
    }
    
    __autoreleasing NSError *error = nil;
    NSData *data = nil;
    
    if (error) {
        _failed = YES;
        return;
    }
    
    if (!data.length) {
        _failed = YES;
        return;
    }
    
    self.audioData = data;
    _expectedLength = _audioData.length;
    _receivedLength = _expectedLength;
    
    _isReady = YES;
    _failed = NO;
}

- (nullable NSData *)readDataAtOffset:(SInt64)inPosition length:(UInt32)length {
    return [self p_readDataAtOffset:inPosition length:length];
}

- (nullable NSData *)p_readDataAtOffset:(SInt64)inPosition length:(UInt32)length {
    
    if (_audioData.length) {
        return [self p_readDataFromDataAtOffset:inPosition length:length];
    }
    return [self p_readDataFromFileAtOffset:inPosition length:length];
}

- (nullable NSData *)p_readDataFromDataAtOffset:(SInt64)inPosition length:(UInt32)length {
    if (inPosition >= _audioData.length) {
        return nil;
    }
    
    NSUInteger tempLength = length;
    
    if (inPosition + length <= [_audioData length]) {
        return [_audioData subdataWithRange:NSMakeRange((NSUInteger)inPosition, length)];
    }
    
    tempLength = [_audioData length] - (NSUInteger)inPosition;
    
    if (tempLength <= 0) {
        return nil;
    }
    
    return [_audioData subdataWithRange:NSMakeRange((NSUInteger)inPosition, tempLength)];
}

- (nullable NSData *)p_readDataFromFileAtOffset:(SInt64)inPosition length:(UInt32)length {

    if (!_fileHandler) {
        _fileHandler = [NSFileHandle fileHandleForReadingAtPath:_cachedPath];
    }

    [_fileHandler seekToFileOffset:inPosition];
    return [_fileHandler readDataOfLength:length];
}

- (NSString *)mimeType {
    
    if (_mimeType == nil && [self fileExtension] != nil) {
        CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[self fileExtension], NULL);
        if (uti != NULL) {
            _mimeType = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType));
            CFRelease(uti);
        }
    }
    
    DLog(@"%@", _mimeType);
    
    return _mimeType;
}

- (NSString *)fileExtension {
    
    if (_fileExtension == nil) {
        _fileExtension = [[[self audioFileSource] audioFileSourceUrl] pathExtension];
    }
    return _fileExtension;
}

- (UInt32)fileType {
    return [super p_fileTypeIdWithFileExtension:[self fileExtension]];
}

- (CGFloat)downloadProgress {
    
    if (_receivedLength == 0) {
        return 0;
    }
    return _receivedLength / _expectedLength;
}

- (BOOL)isReady {
    return _isReady;
}

- (BOOL)isFinished {
    return _isReady;
}

- (BOOL)isFailed {
    return _failed;
}

- (void)dealloc {
    if (_fileHandler) {
        [_fileHandler closeFile];
        _fileHandler = nil;
    }
}

@end


#pragma mark - ======== PLRemoteFileProvider ========

@interface PLRemoteFileProvider : PLFileProvider {
    PLAudioHTTPRequest *_request;
    NSURL *_audioFileURL;
    NSString *_audioFileHost;
    
    AudioFileStreamID _audioFileStreamID;
    BOOL _requiresCompleteFile;
    BOOL _readyToProducePackets;
    BOOL _requestCompleted;
    
    NSFileHandle *_fileHandler;
}

@end

@implementation PLRemoteFileProvider

@synthesize finished = _requestCompleted;

- (instancetype)initWithAudioFileSource:(id<PLAudioFileSource>)audioFile {
    
    if (self = [super initWithAudioFileSource:audioFile]) {
        [self p_gainAudioUrl];
    }
    return self;
}

- (void)dealloc {
    
    @synchronized(_request) {
        [_request setCompleteBlock:nil];
        [_request setProgressBlock:nil];
        [_request setReceiveResponseBlock:nil];
        [_request cancel];
    }
    
    [self p_closeAudioFileStream];
    
    //移除缓存文件
    if ([self.audioFileSource respondsToSelector:@selector(isNeedSaveFile)]) {
        
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:_cachedPath error:NULL];
}

- (void)p_gainAudioUrl {
    
    NSURL *url = [self.audioFileSource audioFileSourceUrl];
    
    if (nil != url) {
        [self p_gainAudioUrlSuccess:url];
    } else {
        WeakSelf
        [self.audioFileSource audioFileSourceUrl:^(NSURL *audioUrl) {
            StrongSelf
            if (!strongSelf) {
                return;
            }
            [strongSelf p_gainAudioUrlSuccess:audioUrl];
        }];
    }
}

- (void)p_gainAudioUrlSuccess:(NSURL *)url {
    _audioFileURL = url;
    
    [self p_openAudioFileStream];
    [self p_createRequest];
    [_request start];
}

- (nullable NSData *)readDataAtOffset:(SInt64)inPosition length:(UInt32)length {
    return [self p_readDataAtOffset:inPosition length:length];
}

- (nullable NSData *)p_readDataAtOffset:(SInt64)inPosition length:(UInt32)length {
    if (!_fileHandler) {
        _fileHandler = [NSFileHandle fileHandleForReadingAtPath:_cachedPath];
    }
    
    [_fileHandler seekToFileOffset:inPosition];
    return [_fileHandler readDataOfLength:length];
}

+ (NSString *)p_cachedPathForAudioFileURL:(NSURL *)audioFileURL {
    
    NSString *string = [audioFileURL.absoluteString getMD5String];
    NSString *filename = [NSString stringWithFormat:@"plaudio-%@.tmp", string];
    return [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
}

- (void)p_requestCompleteWithSuccess:(BOOL)isSuccess {
    
    if (isSuccess) {
        _requestCompleted = YES;
    } else {
        _requestCompleted = NO;
        _failed = NO;
    }

    //回调数据
}

- (void)p_requestReceiveResponse {
    
    _cachedPath = [[self class] p_cachedPathForAudioFileURL:_audioFileURL];
    _cachedURL = [NSURL fileURLWithPath:_cachedPath];
    
    [[NSFileManager defaultManager] removeItemAtPath:_cachedPath error:nil];
    [[NSFileManager defaultManager] createFileAtPath:_cachedPath contents:nil attributes:nil];
    [[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey: NSFileProtectionNone}
                                     ofItemAtPath:_cachedPath
                                            error:NULL];
    
    _request.cachePath = _cachedPath;
    _mimeType = [[_request responseHeaders] objectForKey:@"Content-Type"];
}

- (void)p_requestProgress:(NSProgress *)progress withData:(NSData *)data {
    
    if (!_readyToProducePackets && !_failed && !_requiresCompleteFile) {
        
        OSStatus status = kAudioFileStreamError_UnsupportedFileType;
        
        if (_audioFileStreamID != NULL) {
            status = AudioFileStreamParseBytes(_audioFileStreamID,
                                               (UInt32)[data length],
                                               [data bytes],
                                               0);
        }
        
        if (status != noErr && status != kAudioFileStreamError_NotOptimized) {
            NSArray *fallbackTypeIDs = [self p_fallbackTypeIDs];
            for (NSNumber *typeIDNumber in fallbackTypeIDs) {
                AudioFileTypeID typeID = (AudioFileTypeID)[typeIDNumber unsignedLongValue];
                [self p_closeAudioFileStream];
                [self p_openAudioFileStreamWithFileTypeHint:typeID];
                
                if (_audioFileStreamID != NULL) {
                    status = AudioFileStreamParseBytes(_audioFileStreamID,
                                                       (UInt32)_receivedLength,
                                                       [_mappedData bytes],
                                                       0);
                    
                    if (status == noErr || status == kAudioFileStreamError_NotOptimized) {
                        break;
                    }
                }
            }
            
            if (status != noErr && status != kAudioFileStreamError_NotOptimized) {
                _failed = YES;
            }
        }
        
        if (status == kAudioFileStreamError_NotOptimized) {
            [self p_closeAudioFileStream];
            _requiresCompleteFile = YES;
        }
    }
    
}

- (void)p_createRequest {
    
    _request = [PLAudioHTTPRequest requestWithURL:_audioFileURL];

    __weak typeof(self) weakSelf = self;
    [_request setCompleteBlock:^(BOOL isSuccess) {
        [weakSelf p_requestCompleteWithSuccess:isSuccess];
    }];
    
    [_request setReceiveResponseBlock:^{
        [weakSelf p_requestReceiveResponse];
    }];
    
    [_request setProgressBlock:^(NSProgress * _Nonnull progress, NSData * _Nullable data) {
        [weakSelf p_requestProgress:progress withData:data];
    }];
}

- (void)_handleAudioFileStreamProperty:(AudioFileStreamPropertyID)propertyID {
    
    if (propertyID == kAudioFileStreamProperty_ReadyToProducePackets) {
        _readyToProducePackets = YES;
    }
}

- (void)_handleAudioFileStreamPackets:(const void *)packets
                        numberOfBytes:(UInt32)numberOfBytes
                      numberOfPackets:(UInt32)numberOfPackets
                   packetDescriptions:(AudioStreamPacketDescription *)packetDescriptioins {
    
}

static void audio_file_stream_property_listener_proc(void *inClientData,
                                                     AudioFileStreamID inAudioFileStream,
                                                     AudioFileStreamPropertyID inPropertyID,
                                                     UInt32 *ioFlags) {
    
    __unsafe_unretained PLRemoteFileProvider *fileProvider = (__bridge PLRemoteFileProvider *)inClientData;
    [fileProvider _handleAudioFileStreamProperty:inPropertyID];
}

static void audio_file_stream_packets_proc(void *inClientData,
                                           UInt32 inNumberBytes,
                                           UInt32 inNumberPackets,
                                           const void *inInputData,
                                           AudioStreamPacketDescription    *inPacketDescriptions){
    __unsafe_unretained PLRemoteFileProvider *fileProvider = (__bridge PLRemoteFileProvider *)inClientData;
    [fileProvider _handleAudioFileStreamPackets:inInputData
                                  numberOfBytes:inNumberBytes
                                numberOfPackets:inNumberPackets
                             packetDescriptions:inPacketDescriptions];
}

- (void)p_openAudioFileStream {
    
    [self p_openAudioFileStreamWithFileTypeHint:0];
}

- (void)p_openAudioFileStreamWithFileTypeHint:(AudioFileTypeID)fileTypeHint {
    
    OSStatus status = AudioFileStreamOpen((__bridge void *)self,
                                          audio_file_stream_property_listener_proc,
                                          audio_file_stream_packets_proc,
                                          fileTypeHint,
                                          &_audioFileStreamID);
    
    if (status != noErr) {
        _audioFileStreamID = NULL;
    }
}

- (void)p_closeAudioFileStream {
    
    if (_audioFileStreamID != NULL) {
        AudioFileStreamClose(_audioFileStreamID);
        _audioFileStreamID = NULL;
    }
}

- (NSArray *)p_fallbackTypeIDs {
    
    NSMutableArray *fallbackTypeIDs = [NSMutableArray array];
    NSMutableSet *fallbackTypeIDSet = [NSMutableSet set];
    
    struct {
        CFStringRef specifier;
        AudioFilePropertyID propertyID;
    } properties[] = {
        { (__bridge CFStringRef)[self mimeType], kAudioFileGlobalInfo_TypesForMIMEType },
        { (__bridge CFStringRef)[self fileExtension], kAudioFileGlobalInfo_TypesForExtension }
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


#pragma mark - ======== getter ========

- (NSString *)fileExtension {
    
    if (_fileExtension == nil) {
        _fileExtension = [[[[self audioFileSource] audioFileSourceUrl] path] pathExtension];
    }
    
    return _fileExtension;
}

- (UInt32)fileType {
    return [super p_fileTypeIdWithFileExtension:[self fileExtension]];
}

- (unsigned long long)receivedLength {
    return [_request progress].completedUnitCount;
}

- (unsigned long long)expectedLength {
    return [_request progress].totalUnitCount;
}

- (CGFloat)downloadProgress {
    
    NSProgress *progress = [_request progress];
    return progress.completedUnitCount * 1.0 / progress.totalUnitCount;
}

- (BOOL)isReady {
    
    if (!_requiresCompleteFile) {
        return _readyToProducePackets;
    }
    
    return _requestCompleted;
}

- (BOOL)isFinished {
    return _requestCompleted;
}

- (BOOL)isFailed {
    return _failed;
}

@end


#pragma mark - ======== PLFileProvider ========

@implementation PLFileProvider

@synthesize audioFileSource = _audioFileSource;
@synthesize cachePath = _cachePath;
@synthesize cachedURL = _cachedURL;
@synthesize expectedLength = _expectedLength;
@synthesize receivedLength = _receivedLength;
@synthesize mimeType = _mimeType;
@synthesize fileExtension = _fileExtension;
@synthesize fileType = _fileType;
@synthesize failed = _failed;
@synthesize downloadProgress = _downloadProgress;

+ (instancetype)fileProviderWithAudioFileSource:(id <PLAudioFileSource>)aduioFileSource {
    return [self p_fileProviderWithAudioFileSource:aduioFileSource];
}

+ (instancetype)p_fileProviderWithAudioFileSource:(id <PLAudioFileSource>)aduioFileSource {
    
    if (nil == aduioFileSource) {
        return nil;
    }
    
    
    UPAudioSourceFrom from = [aduioFileSource audioFileSourceFrom];
    
    switch (from) {
        case UPAudioSourceFromNet: {
            return [[PLRemoteFileProvider alloc] initWithAudioFileSource:aduioFileSource];
        }
            break;
            
        case UPAudioSourceFromLocal: {
            return [[PLLocalFileProvider alloc] initWithAudioFileSource:aduioFileSource];
        }
            break;
    }
    
    NSURL *audioFileURL = [aduioFileSource audioFileSourceUrl];
    
    if (nil != audioFileURL) {
        
        BOOL isFile = [[audioFileURL absoluteString] hasPrefix:@"http://"] || [[audioFileURL absoluteString] hasPrefix:@"https://"];
        
        if (!isFile) {
            return [[PLLocalFileProvider alloc] initWithAudioFileSource:aduioFileSource];
        }
        
        return [[PLRemoteFileProvider alloc] initWithAudioFileSource:aduioFileSource];
    }
    
    return nil;
}

- (instancetype)initWithAudioFileSource:(id<PLAudioFileSource>)audioFileSource {

    if (self = [super init]) {
        _audioFileSource = audioFileSource;
    }
    return self;
}

- (UInt32)p_fileTypeIdWithFileExtension:(NSString *)fileExtension {
    
    if ([fileExtension isEqual:@"mp3"]) {
        return kAudioFileMP3Type;
    } else if ([fileExtension isEqual:@"aac"]) {
        return kAudioFileAAC_ADTSType;
    } else if ([fileExtension isEqual:@"wav"]) {
        return kAudioFileWAVEType;
    } else if ([fileExtension isEqual:@"aifc"]) {
        return kAudioFileAIFCType;
    } else if ([fileExtension isEqual:@"aiff"]) {
        return kAudioFileAIFFType;
    } else if ([fileExtension isEqual:@"m4a"]) {
        return kAudioFileM4AType;
    } else if ([fileExtension isEqual:@"mp4"]) {
        return kAudioFileMPEG4Type;
    } else if ([fileExtension isEqual:@"caf"]) {
        return kAudioFileCAFType;
    }
    
    return 0;
}

- (nullable NSData *)readDataAtOffset:(SInt64)inPosition length:(UInt32)length {
    return nil;
}

@end
