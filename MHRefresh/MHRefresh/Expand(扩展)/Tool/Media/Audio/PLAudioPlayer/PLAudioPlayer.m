//
//  PLAudioPlayer.m
//  MHRefresh
//
//  Created by panle on 2018/3/6.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLAudioPlayer.h"
#import "PLAudioThread.h"

@interface PLAudioPlayer ()

@property (nonatomic, strong) PLAudioThread *thread;

@end

@implementation PLAudioPlayer

#pragma mark - ======== init ========

+ (instancetype)initWithAudioFileSource:(id <PLAudioFileSource>)audioFileSource {
    return [[self alloc] initWithAudioFileSource:audioFileSource];
}

- (instancetype)initWithAudioFileSource:(id <PLAudioFileSource>)audioFileSource {
    if (self = [super init]) {
        _thread = [[PLAudioThread alloc] initWithAudioFileSource:audioFileSource];
        
        if (_thread) {
            [_thread addObserver:self forKeyPath:@"audioStatus" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"audioStatus"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(pl_audioPlay:statusChange:)]) {
                [_delegate pl_audioPlay:self statusChange:self.status];
            }
        });
    }
}

#pragma mark - ======== public ========

- (void)play {
    [_thread play];
}

- (void)pause {
    [_thread pause];
}

- (void)stop {
    [_thread stop];
}

- (void)seekTime:(NSTimeInterval)time {
    if (time < 0) {
        time = 0;
    }
    [_thread seekTime:time];
}


#pragma mark - ======== synthesize ========

- (id <PLAudioFileSource>)audioFileSource {
    return [_thread audioFileSource];
}

- (NSURL *)url {
    return [_thread url];
}

- (PLAudioPlayerStatus)status {
    
    PLAudioPlayerStatus status;
    
    switch ([_thread status]) {
        case PLATStatusFlushing:
            status = PLAPStatusFlushing;
            break;
            
        case PLATStatusPlaying:
            status = PLAPStatusPlaying;
            break;
            
        case PLATStatusBuffering:
        case PLATStatusIdle:
            status = PLAPStatusBuffering;
            break;
        
        case PLATStatusPaused:
            status = PLAPStatusPaused;
            break;
            
        case PLATStatusStopped:
            status = PLAPStatusStopped;
            break;
            
        case PLATStatusQueueError:
        case PLATStatusBufferError:
        case PLATStatusError:
        case PLATStatusFileError:
            status = PLAPStatusError;
            break;
    }
    
    return status;
}

- (BOOL)isPlaying {
    
    return self.status == PLAPStatusPlaying || self.status == PLAPStatusBuffering || self.status == PLAPStatusFlushing;
}

- (NSError *)error {
    return [_thread error];
}

- (NSTimeInterval)duration {
    return [_thread duration];
}

- (NSTimeInterval)currentTime {
    return [_thread currentTime];
}

- (CGFloat)playProgress {
    CGFloat result = self.currentTime / self.duration;
    return isnan(result) ? 0.01 : result;
}

- (NSString *)cachedPath {
    return [_thread cachedPath];
}

- (NSURL *)cacheURL {
    return [_thread cacheURL];
}

- (UInt64)audioLength {
    return [_thread audioLength];
}

- (CGFloat)bufferingRation {
    
    CGFloat buffingRation = [_thread bufferingRation];
    return isnan(buffingRation) ? 0.001 : buffingRation;
}

- (CGFloat)volume {
    
    if (_thread) {
        return [_thread volume];
    }
    
    return 1.0;
}

- (void)setVolume:(CGFloat)volume {
    [_thread setVolume:volume];
}

- (CGFloat)playRate {
    return [_thread playRate];
}

- (void)setPlayRate:(CGFloat)playRate {
    [_thread setPlayRate:playRate];
}

- (void)dealloc {
    DLOG_DEALLOC;
    
    if (_thread) {
        [_thread removeObserver:self forKeyPath:@"audioStatus"];
    }
}

@end

