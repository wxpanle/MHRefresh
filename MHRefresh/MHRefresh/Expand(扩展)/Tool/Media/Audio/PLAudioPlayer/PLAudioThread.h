//
//  PLAudioThread.h
//  MHRefresh
//
//  Created by panle on 2018/3/9.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLAudioFileSource.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PLAudioThreadStatus) {
    PLATStatusPlaying,
    PLATStatusPaused,
    PLATStatusIdle,
    PLATStatusStopped,
    PLATStatusBuffering,
    PLATStatusError,
    PLATStatusQueueError,
    PLATStatusBufferError,
    PLATStatusFlushing,
    PLATStatusFileError, //文件不存在  或下载失败
};

@interface PLAudioThread : NSObject

- (instancetype)initWithAudioFileSource:(nonnull id <PLAudioFileSource>)audioFileSource;

- (PLAudioThreadStatus)status;
- (nullable NSError *)error;

- (nullable id <PLAudioFileSource>)audioFileSource;
- (nullable NSURL *)url;

- (NSTimeInterval)duration;
- (NSTimeInterval)currentTime;

- (nullable NSString *)cachedPath;
- (nullable NSURL *)cacheURL;

- (UInt64)audioLength;
- (CGFloat)bufferingRation;

- (CGFloat)volume;
- (void)setVolume:(CGFloat)volume;

- (CGFloat)playRate;
- (void)setPlayRate:(CGFloat)playRate;

- (void)play;
- (void)pause;
- (void)stop;

- (void)seekTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
