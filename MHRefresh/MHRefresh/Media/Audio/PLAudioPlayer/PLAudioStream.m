//
//  PLAudioStream.m
//  MHRefresh
//
//  Created by panle on 2018/3/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLAudioStream.h"
#import "PLAudioFile.h"
#import "PLAudioFileStream.h"
#import "PLFileProvider.h"

@class PLLocalFileProvider, PLRemoteFileProvider;

@interface PLAudioStream () {
    PLFileProvider *_fileProvider;
}

@end

@implementation PLAudioStream

@synthesize delegate = _delegate;

@synthesize fileProvider = _fileProvider;

@synthesize fileType = _fileType;
@synthesize audioFormat = _audioFormat;

@synthesize available = _available;

@synthesize bitRate = _bitRate;
@synthesize duration = _duration;
@synthesize maxPacketSize = _maxPacketSize;
@synthesize audioDataByteCount = _audioDataByteCount;

@synthesize readyToProducePackets = _readyToProducePackets;

+ (nullable instancetype)initWithAudioFileSource:(nonnull id <PLAudioFileSource>)audioFileSource {
    
    PLFileProvider *fileProvider = [PLFileProvider fileProviderWithAudioFileSource:audioFileSource];
    
    Class localFileProvider = NSClassFromString(@"PLLocalFileProvider");
    
    if ([fileProvider isKindOfClass:[localFileProvider class]]) {
        return [[PLAudioFile alloc] initWithAudioFileProvider:fileProvider];
    }
    
    Class remoteFileProvider = NSClassFromString(@"PLRemoteFileProvider");
    if ([fileProvider isKindOfClass:[remoteFileProvider class]]) {
        return [[PLAudioFileStream alloc] initWithAudioFileProvider:fileProvider];
    }
    
    return nil;
}

- (nullable instancetype)initWithAudioFileProvider:(nonnull PLFileProvider *)fileProvider {
    if (self = [super init]) {
        _fileProvider = fileProvider;
    }
    return self;
}

- (PLAudioStreamReadFileStatus)readData { return PLASRFStatusFail; }
- (NSData *)fetchMagicCookie { return nil; }
- (SInt64)seekTime:(NSTimeInterval)time { return 0; }
- (BOOL)open { return NO; }
- (void)close {}

- (AudioFileTypeID)fileType {
    return _fileProvider.fileType;
}

- (PLFileProvider *)fileProvider {
    return _fileProvider;
}

@end
