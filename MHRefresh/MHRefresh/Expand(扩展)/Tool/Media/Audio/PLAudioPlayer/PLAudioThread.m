//
//  PLAudioThread.m
//  MHRefresh
//
//  Created by panle on 2018/3/9.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLAudioThread.h"
#import "PLAudioStream.h"
#import "PLAudioOutputQueue.h"
#import "PLFileProvider.h"
#import "PLAudioSession.h"
#import "PLAudioBuffer.h"
#import <pthread.h>

@interface PLAudioThread () <PLAudioSessionDelegate, PLAudioStreamDataDelegate> {
    
    BOOL _started;
    
    NSThread *_thread;   //主线程
    
    PLAudioStream *_audioStream;
    PLAudioOutputQueue *_audioQueue;
    PLAudioBuffer *_audioBuffer;
    
    BOOL _pauseRequired;
    BOOL _stopRequired;
    BOOL _seekRequired;
    BOOL _playRateRequired;
    BOOL _volumeRequired;
    
    BOOL _pausedByInterrupt;
    
    CGFloat _volume;  /** value [0, 1.0] */
    CGFloat _playRate; /** value [0.5, 2.0] */
    
    pthread_mutex_t _mutex;
    pthread_cond_t _cond;
    BOOL _mutexInitialized;
    
    CGFloat _seekTime;
    NSTimeInterval _timingOffset;
}

@property (nonatomic, assign) PLAudioThreadStatus audioStatus;

@end

@implementation PLAudioThread

#pragma mark - ======== init ========

- (instancetype)initWithAudioFileSource:(id <PLAudioFileSource>)audioFileSource {
    
    if (self = [super init]) {
        [self p_createAudioStreamWithAudioFileSource:(id <PLAudioFileSource>)audioFileSource];
    }
    return self;
}

- (void)dealloc {

    [self p_cleanUp];
    DLOG_DEALLOC
}

#pragma mark - ======== private ========

- (void)p_createAudioStreamWithAudioFileSource:(id <PLAudioFileSource>)audioFileSource {
    _audioStream = [PLAudioStream initWithAudioFileSource:audioFileSource];
    _audioStream.delegate = self;
    DLog(@"%@", _audioStream);
}

- (void)p_createAudioQueueWithAudioStream:(PLAudioStream *)audioStream {
    _audioQueue = [[PLAudioOutputQueue alloc] initWithFormat:_audioStream.audioFormat bufferSize:_audioStream.maxPacketSize macgicCookie:_audioStream.fetchMagicCookie];
}

- (void)p_threadMain {
    
    if (![PLAudioSession setAudioSessionCategoryPlaybackIfNeeded]) {
        [self p_cleanUp];
        return;
    }
    
    //添加通知
    [[PLAudioSession shardeInstance] addAudioSessionDelegate:self];
    
    if (![PLAudioSession setAudioSessionActive:YES]) {
        [self p_cleanUp];
        return;
    }
    
    while (![self p_threadIsExit]) {
        @autoreleasepool {
            
            [self p_handlerEventRequired];
            
            [self p_handlerAudioStream];
            
            [self p_handlerBuffer];
            
            if (!_audioQueue) {
                [NSThread sleepForTimeInterval:0.1];
                continue;
            }
        }
    }
    
    [self p_cleanUp];
}

- (BOOL)p_threadIsExit {
    
    BOOL exit = _audioStatus == PLATStatusStopped ||
                _audioStatus == PLATStatusFileError ||
                _audioStatus == PLATStatusQueueError ||
                _audioStatus == PLATStatusBufferError ||
                _audioStatus == PLATStatusFileError;
    
    return exit;
}

- (void)p_handlerEventRequired {
    
    if (!_audioStream) {
        return;
    }
    
    if (!_audioStream.isReadyToProducePackets) {
        return;
    }
    
    if (!_audioQueue) {
        return;
    }
    
    if (!_audioQueue.isAvailable) {
        return;
    }
    
    //stop
    if (_stopRequired) {
        _stopRequired = NO;
        [_audioQueue stop];
        self.audioStatus = PLATStatusStopped;
        return;
    }
    
    //pause
    if (_pauseRequired) {
        [_audioQueue pause];
        self.audioStatus = PLATStatusPaused;
        [self p_mutexWait];
        _pauseRequired = NO;
        return;
    }
    
    //seek
    if (_seekRequired && _audioStream.duration > 0) {
        _timingOffset = _seekTime - _audioQueue.currentTime;
        [_audioBuffer reset];
        _seekTime = [_audioStream seekTime:_seekTime];
        
        if (_seekTime < 0) {
            DLog(@"seek fail");
        }
        
        _seekRequired = NO;
        [_audioQueue reset];
    }
    
    //play
    if ([_audioBuffer bufferedSize] >= _audioStream.maxPacketSize || _audioBuffer.isEnd) {
        UInt32 packetCount = 0;
        AudioStreamPacketDescription *desces = NULL;
        NSData *data = [_audioBuffer dequeueDataWithSize:_audioStream.maxPacketSize packetCount:&packetCount descriptions:&desces];
        
        if (packetCount != 0) {
            if (![_audioQueue start]) {
                self.audioStatus = PLATStatusQueueError;
                return;
            }
            
            BOOL success = [_audioQueue handleAudioWithNumberPackets:packetCount inPacketDescriptions:desces inputData:data];
            free(desces);
            
            if (!success) {
                self.audioStatus = PLATStatusQueueError;
                return;
            }
            
            self.audioStatus = PLATStatusPlaying;
            
            if (![_audioBuffer hasData] && _audioBuffer.isEnd && _audioQueue.isRunning) {
                [_audioQueue stop:NO];
                //等待结束
                self.audioStatus = PLATStatusFlushing;
            }
        } else if (_audioBuffer.isEnd) {
            
//            if (![_audioBuffer hasData] && _audioQueue.isRunning) {
//                [_audioQueue stop:NO];
//                //等待结束
//                self.audioStatus = PLATStatusFlushing;
//            } else
            
            if (![_audioBuffer hasData] && !_audioQueue.isRunning) {
                self.audioStatus = PLATStatusStopped;
            }
        } else {
            
            self.audioStatus = PLATStatusBufferError;
            return;
        }
    }
}

- (void)p_handlerAudioStream {
    
    if (!_audioStream) {
        return;
    }
    
    if ([[_audioStream fileProvider] isFailed]) {
        self.audioStatus = PLATStatusFileError;
        return;
    }
    
    if (![_audioStream fileProvider].isReady) {
        self.audioStatus = PLATStatusBuffering;
        return;
    }
    
    if (![_audioStream open]) {
        self.audioStatus = PLATStatusFileError;
        return;
    }
    
    if (_audioQueue) {
        return;
    }
    
    if (_audioStream.isReadyToProducePackets) {
        [self p_createAudioQueueWithAudioStream:_audioStream];
    }
    
}

- (void)p_handlerBuffer {
    
    if (!_audioStream) {
        return;
    }
    
    if (![_audioStream fileProvider].isReady) {
        return;
    }
    
    if (_audioBuffer.isEnd) {
        return;
    }
    
    if ([_audioBuffer bufferedSize] > _audioStream.maxPacketSize) {
        return;
    }
    
    switch ([_audioStream readData]) {
        case PLASRFStatusSuccess:
            break;
            
        case PLASRFStatusFail:
            self.audioStatus = PLATStatusFileError;
            break;
            
        case PLASRFStatusWaiting:
            break;
            
        case PLASRFStatusFinished:
            _audioBuffer.end = YES;
            break;
            
        default:
            break;
    }
    
}


- (void)p_cleanUp {
    
    [[PLAudioSession shardeInstance] removeAudioSessionDelegate:self];
    
    [self p_mutexDestory];
    
    [_audioQueue stop];
    _audioQueue = nil;
    
    [_audioStream close];
    _audioStream = nil;
    
    _started = NO;
    
    _thread = nil;
    
    _timingOffset = 0;
    _seekTime = 0;
    
    _pauseRequired = NO;
    _stopRequired = NO;
    _seekRequired = NO;
    _playRateRequired = NO;
    _volumeRequired = NO;
    
    _pausedByInterrupt = NO;
    
    _volume = 1.0;
    _playRate = 1.0;
    
    self.audioStatus = PLATStatusStopped;
}

#pragma mark - ======== mutex ========

- (void)p_mutexInit {
    pthread_mutex_init(&_mutex, NULL);
    pthread_cond_init(&_cond, NULL);
    _mutexInitialized = YES;
}

- (void)p_mutexDestory {
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

- (void)p_mutexWait {
    pthread_mutex_lock(&_mutex);
    pthread_cond_wait(&_cond, &_mutex);
    pthread_mutex_unlock(&_mutex);
}

- (void)p_mutexSignal {
    pthread_mutex_lock(&_mutex);
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
}

#pragma mark - ======== PLAudioSessionDelegate ========

- (void)audioRouteChangeDetectorDidDetectAudioSessionPropertyChangeWithReason:(AVAudioSessionRouteChangeReason)reason notification:(NSNotification *)notification {
    
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        NSDictionary *dic = notification.userInfo;
        AVAudioSessionRouteDescription *routeDescription = dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription = [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [self pause];
        }
    }
}

- (void)audioInterruptNotification:(NSNotification *)notification {
    
    AVAudioSessionInterruptionType type = (AVAudioSessionInterruptionType)notification.userInfo[AVAudioSessionInterruptionTypeKey];
    
    switch (type) {
        case AVAudioSessionInterruptionTypeBegan: {
            _pausedByInterrupt = YES;
            [_audioQueue pause];
            self.audioStatus = PLATStatusPaused;
        }
            break;
            
        case AVAudioSessionInterruptionTypeEnded: {
            NSUInteger options = [notification.userInfo[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
            
            if (options != AVAudioSessionInterruptionOptionShouldResume) {
                break;
            }
            
            if (!_pausedByInterrupt) {
                break;
            }
            
            if (self.audioStatus != PLATStatusPaused) {
                break;
            }
            
            if ([PLAudioSession setAudioSessionActive:YES]) {
                [self play];
            }
        }
            break;
    }
}

#pragma mark - ======== PLAudioStreamDataDelegate ========

- (void)pl_audioFileStream:(PLAudioStream *)audioStream audioDataArray:(NSArray <PLParsedAudioDataModel *>*)audioDataArray {
    if (!_audioBuffer) {
        _audioBuffer = [PLAudioBuffer audioBuffer];
    }
    
    [_audioBuffer enqueueDataModelArray:audioDataArray];
}

- (void)pl_audioFileStreamReadyToProducePackets:(PLAudioStream *)audioStream {
    
    DLog(@"PLAudioFileStreamReadyToProducePackets");
}

#pragma mark - ======== setter ========

- (void)setAudioStatus:(PLAudioThreadStatus)audioStatus {
    
    if (audioStatus == _audioStatus) {
        return;
    }
    
    [self willChangeValueForKey:@"status"];
    _audioStatus = audioStatus;
    [self didChangeValueForKey:@"status"];
}

#pragma mark - ======== public ========

- (PLAudioThreadStatus)status {
    return _audioStatus;
}

- (nullable NSError *)error {
    return nil;
}

- (nullable id <PLAudioFileSource>)audioFileSource {
    return [[_audioStream fileProvider] audioFileSource];
}

- (nullable NSURL *)url {
    return [[self audioFileSource] audioFileSourceUrl];
}

- (NSTimeInterval)duration {
   return [_audioStream duration];
}

- (NSTimeInterval)currentTime {
    
    if (_seekRequired) {
        return _seekTime;
    }
    
    return _timingOffset + _audioQueue.currentTime;
}

- (NSString *)cachedPath {
    return [_audioStream fileProvider].cachePath;
}

- (NSURL *)cacheURL {
    return [_audioStream fileProvider].cachedURL;
}

- (UInt64)audioLength {
    return [_audioStream fileProvider].expectedLength;
}

- (CGFloat)bufferingRation {
    return _audioStream.fileProvider.downloadProgress;
}

- (CGFloat)volume {
    return [_audioQueue volume];
}

- (void)setVolume:(CGFloat)volume {
    
    if (volume < 0) {
        volume = 0;
    }
    
    if (volume > 1.0) {
        volume = 1.0;
    }
    
    _volume = volume;
    
    if (!_audioQueue) {
        _volumeRequired = YES;
    } else {
        [_audioQueue setVolume:_volume];
    }
}

- (CGFloat)playRate {
    return _playRate;
}

- (void)setPlayRate:(CGFloat)playRate {
    
    if (playRate < 0.5) {
        playRate = 0.5;
    }
    
    if (playRate > 2.0) {
        playRate = 2.0;
    }
    
    _playRate = playRate;
    
    if (!_audioQueue) {
        _playRateRequired = YES;
    } else {
        [_audioQueue setPlayRate:_playRate];
    }
}

- (void)play {
    
    if (!_started) {
        _started = YES;
        [self p_mutexInit];
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(p_threadMain) object:nil];
        [_thread start];
    } else {
        
        if (_audioStatus == PLATStatusPaused || _pauseRequired) {
            _pauseRequired = NO;
            _pausedByInterrupt = NO;
            
            if (![PLAudioSession setAudioSessionActive:YES]) {
                return;
            }
        
            if ([PLAudioSession setAudioSessionCategoryPlaybackIfNeeded]) {
                [self p_resume];
            }
        }
    }
}

- (void)p_resume {
    [_audioQueue resume];
    [self p_mutexSignal];
}

- (void)pause {
    
    if (_audioStatus == PLATStatusPlaying ||
        _audioStatus == PLATStatusIdle) {
        _pauseRequired = YES;
    }
}

- (void)stop {
    _stopRequired = YES;
    [self p_mutexSignal];
}

- (void)seekTime:(NSTimeInterval)time {
    _seekTime = time;
    _seekRequired = YES;
}

@end
