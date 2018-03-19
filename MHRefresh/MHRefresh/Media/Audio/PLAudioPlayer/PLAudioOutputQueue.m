//
//  PLAudioOutputQueue.m
//  MHRefresh
//
//  Created by panle on 2018/3/6.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLAudioOutputQueue.h"
#import <pthread.h>

const unsigned int kNumAQBufs = 3;
const unsigned int kAQMaxPacketDescs = 512;

@interface PLAudioQueueBuffer : NSObject
@property (nonatomic, assign) AudioQueueBufferRef queueBuffer;
@end
@implementation PLAudioQueueBuffer
@end

@interface PLAudioStreamPacketDescription : NSObject
@property (nonatomic, assign) AudioStreamPacketDescription *packetDescs;
@end
@implementation PLAudioStreamPacketDescription
@end

@interface PLAudioOutputQueue () {
    AudioQueueRef _audioQueue;
    BOOL _started; //队列是否已经开始
    
    pthread_mutex_t _mutex;
    pthread_cond_t _cond;
    
    UInt32 _buffersUsed;
    UInt32 _fillBufferIndex;
    UInt32 _packetsFilled;
    UInt32 _bytesFilled;
    
    NSMutableArray <PLAudioQueueBuffer *>*_buffers;
    NSMutableArray <PLAudioQueueBuffer *>*_inUseBuffers;
    
//    NSMutableArray <PLAudioStreamPacketDescription *>*_packetDescs;
    
    BOOL _isEnableTimePitch;
}

@property (nonatomic, assign, readwrite, getter=isAvailable) BOOL available;

@property (nonatomic, assign, readwrite, getter=isRunning) BOOL running;

@property (nonatomic, assign, readwrite) AudioStreamBasicDescription format;

@property (nonatomic, assign) PLAudioQueueStatus status;

@end

@implementation PLAudioOutputQueue

@synthesize volume = _volume;
@synthesize playRate = _playRate;

- (instancetype)initWithFormat:(AudioStreamBasicDescription)format bufferSize:(UInt32)bufferSize macgicCookie:(NSData *)macgicCookie {
    
    if (self = [super init]) {
        
        _started = NO;
        _format = format;
        _volume = 1.0f;
        _playRate = 1.0;
        _bufferSize = bufferSize;
        
        _status = PLAudioQueueStatusIdle;
        _audioQueue = NULL;
        _fillBufferIndex = 0;
        _bytesFilled = 0;
        _packetsFilled = 0;
        _buffersUsed = 0;
        
        _buffers = [[NSMutableArray alloc] initWithCapacity:kNumAQBufs];
//        _packetDescs = [[NSMutableArray alloc] initWithCapacity:kNumAQBufs];
        _inUseBuffers = [[NSMutableArray alloc] initWithCapacity:kNumAQBufs];
        
        [self p_createQueueWithMagicCookie:macgicCookie];
        [self p_mutexInit];
    }
    return self;
}


#pragma mark - ======== public ========

- (BOOL)handleAudioWithNumberPackets:(UInt32)numberPackets inPacketDescriptions:(AudioStreamPacketDescription *)inPacketDescriptions inputData:(NSData *)data {
    
    if (![self p_initialized]) {
        return NO;
    }
    
    if ([data length] > _bufferSize) {
        return NO;
    }
    
    if (_inUseBuffers.count == 0) {
        if (!_started && ![self start]) {
            return NO;
        }
        [self p_mutexWait];
    }
    
    PLAudioQueueBuffer *model = [_inUseBuffers firstObject];
    [_inUseBuffers removeObject:model];
    
    if (!model) {
        AudioQueueBufferRef queueBuffer;
        OSStatus status = AudioQueueAllocateBuffer(_audioQueue, _bufferSize, &queueBuffer);
        
        if (status != noErr) {
            return NO;
        }
        
        model = [[PLAudioQueueBuffer alloc] init];
        model.queueBuffer = queueBuffer;
    }
    
    memcpy(model.queueBuffer->mAudioData, [data bytes], [data length]);
    model.queueBuffer->mAudioDataByteSize = (UInt32)[data length];
    
    _buffersUsed++;
    OSStatus status = AudioQueueEnqueueBuffer(_audioQueue, model.queueBuffer, numberPackets, inPacketDescriptions);
    if (status != noErr) {
        return NO;
    }
    
    BOOL start = [self start];
    
    _status = PLAudioQueueStatusPlaying;
    self.playRate = _playRate;
    
    return start;
}

- (BOOL)start {
    
    if (_started) {
        return _started;
    }
    
    OSStatus status = AudioQueueStart(_audioQueue, NULL);
    _started = status == noErr;
    NSAssert(status == noErr, @"开启队列失败");
    return _started;
}

- (BOOL)pause {
    
    OSStatus status = AudioQueuePause(_audioQueue);
    NSAssert(status == noErr, @"暂停队列失败");
    _started = NO;
    self.status = PLAudioQueueStatusPaused;
    return status == noErr;
}

- (BOOL)resume {

    OSStatus status = AudioQueueStart(_audioQueue, NULL);
    self.status = PLAudioQueueStatusRunning;
    return status == noErr;
}

- (void)stop {
   [self stop:YES];
}

- (void)stop:(BOOL)immediately {
    
    if ([self p_initialized]) {
        return;
    }
    
    _started = NO;
    
    [self p_mutexSignal];
    
    if (AudioQueueFlush(_audioQueue) != noErr) {
        DLog(@"%@ AudioQueueFlush fail", NSStringFromClass([self class]));
    }
    
    if (immediately) {
        AudioQueueRemovePropertyListener(_audioQueue, kAudioQueueProperty_IsRunning, AudioQueueIsRunningCallBack, (__bridge void * _Nullable)(self));
    }
    
    OSStatus status = AudioQueueStop(_audioQueue, immediately ? true : false);
    if (status != noErr) {
        DLog(@"%@ AudioQueueStop fail", NSStringFromClass([self class]));
        return;
    }
    
    if (immediately) {
        self.status = PLAudioQueueStatusIdle;
    }
}

- (BOOL)reset {
    OSStatus status = AudioQueueReset(_audioQueue);
    NSAssert(status == noErr, @"AudioQueueReset fail");
    return status == noErr;
}

- (BOOL)flush {

    OSStatus status = AudioQueueFlush(_audioQueue);
    NSAssert(status == noErr, @"AudioQueueFlush fail");
    return status == noErr;
}


#pragma mark - ======== private ========

- (void)p_createQueueWithMagicCookie:(NSData *)magicCookie {
    
    OSStatus status = AudioQueueNewOutput(&_format, AudioQueueOutputCallBack, (__bridge void * _Nullable)(self), NULL, NULL, 0, &_audioQueue);
    
    if (status != noErr) {
        _audioQueue = NULL;
        if (_delegate && [_delegate respondsToSelector:@selector(pl_audioQueueINitializationFailed:)]) {
            [_delegate pl_audioQueueINitializationFailed:self];
        }
        return;
    }
    
    // listen to the "isRunning" property
    status = AudioQueueAddPropertyListener(_audioQueue, kAudioQueueProperty_IsRunning, AudioQueueIsRunningCallBack, (__bridge void * _Nullable)(self));
    if (status != noErr) {
        _audioQueue = NULL;
        return;
    }
    
    [_buffers removeAllObjects];
    for (unsigned int i = 0; i < kNumAQBufs; i++) {
        
        AudioQueueBufferRef buffer;
        status = AudioQueueAllocateBuffer(_audioQueue, _bufferSize, &buffer);
        if (status != noErr) {
            AudioQueueDispose(_audioQueue, YES);
            _audioQueue = NULL;
            if (_delegate && [_delegate respondsToSelector:@selector(pl_audioQueueINitializationFailed:)]) {
                [_delegate pl_audioQueueINitializationFailed:self];
            }
            return;
        }
        PLAudioQueueBuffer *queueBuffer = [[PLAudioQueueBuffer alloc] init];
        queueBuffer.queueBuffer = buffer;
        [_buffers addObject:queueBuffer];
        [_inUseBuffers addObject:queueBuffer];
    }
    
#if TARGET_OS_IPHONE
    UInt32 property = kAudioQueueHardwareCodecPolicy_PreferSoftware;
    status = AudioQueueSetProperty(_audioQueue, kAudioQueueProperty_HardwareCodecPolicy, &property, sizeof(property));
    if (status != noErr) {
        DLog(@"kAudioQueueHardwareCodecPolicy_PreferSoftware fail");
    }
#endif
    
    UInt32 enableTimePitchConversion = 1;
    
    status = AudioQueueSetProperty (_audioQueue, kAudioQueueProperty_EnableTimePitch, &enableTimePitchConversion, sizeof(enableTimePitchConversion));
    
    if (magicCookie) {
        AudioQueueSetProperty(_audioQueue, kAudioQueueProperty_MagicCookie, [magicCookie bytes], (UInt32)[magicCookie length]);
    }
    
    [self p_setVolumeParameter];
}

- (void)p_enqueueBuffer {
    
}

- (void)p_setVolumeParameter {
    if (!_audioQueue) {
        return;
    }
    AudioQueueSetParameter(_audioQueue, kAudioQueueParam_Volume, _volume);
}

- (void)p_disposeAudioOutputQueue {
    
    if ([self p_initialized]) {
        AudioQueueDispose(_audioQueue,true);
        _audioQueue = NULL;
    }
}

- (BOOL)p_initialized {
    return _audioQueue != NULL;
}

- (void)p_cleanUp {
    if ([self p_initialized]) {
        return;
    }
    
    if (self.status != PLAudioQueueStatusIdle) {
        [self stop];
    }
}


#pragma mark - ======== mutex ========

- (void)p_mutexInit {
    pthread_mutex_init(&_mutex, NULL);
    pthread_cond_init(&_cond, NULL);
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

#pragma mark - ======== setter ========

- (void)setStatus:(PLAudioQueueStatus)status {
    if (status == _status) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(pl_audioQueueStatusChange:oldStatus:newStatus:)]) {
        [_delegate pl_audioQueueStatusChange:self oldStatus:_status newStatus:status];
    }
    _status = status;
}


#pragma mark - ======== setter ========

- (void)setVolume:(CGFloat)volume {
    _volume = volume;
    [self p_setVolumeParameter];
}

- (void)setPlayRate:(CGFloat)playRate {
    
    _playRate = playRate;
    
    if (_playRate < 0.5) {
        _playRate = 0.5;
    }
    
    if (_playRate > 2.0) {
        _playRate = 2.0;
    }
    
    if (!_audioQueue) {
        return;
    }
    
    if (_status != PLAudioQueueStatusPlaying) {
        return;
    }
    
    OSStatus status;
    
    AudioQueueParameterValue value = _playRate;
    status = AudioQueueSetParameter(_audioQueue, kAudioQueueParam_PlayRate, value);
    if (status != noErr) {
        DLog(@"set kAudioQueueParam_PlayRate fail");
    }
}

#pragma mark - ======== getter ========

- (NSTimeInterval)currentTime {
    
    if (_format.mSampleRate == 0) {
        return 0;
    }
    
    AudioTimeStamp time;
    OSStatus status = AudioQueueGetCurrentTime(_audioQueue, NULL, &time, NULL);
    if (status == noErr) {
        return time.mSampleTime / _format.mSampleRate;
    }
    
    return 0;
}

- (BOOL)isAvailable {
    return _audioQueue != NULL;
}

- (CGFloat)volume {
    if (!_audioQueue) {
        return 1.0;
    }
    
    AudioQueueParameterValue value = 1.0;
    
    OSStatus status = AudioQueueGetParameter(_audioQueue, kAudioQueueParam_Volume, &value);
    
    if (status == noErr) {
        return value;
    }
    
    return 1.0;
}

- (CGFloat)playRate {
    
    if (!_audioQueue) {
        return 1.0;
    }
    
    if (!_isEnableTimePitch) {
        UInt32 isEnableTimePitch = 0;
        UInt32 ioDataSize = sizeof(isEnableTimePitch);
        OSStatus status = AudioQueueGetProperty(_audioQueue, kAudioQueueProperty_EnableTimePitch, &isEnableTimePitch, &ioDataSize);
        
        if (status != noErr) {
            return 1.0;
        }
        
        _isEnableTimePitch = _isEnableTimePitch == 0 ? NO : YES;
    }
    
    if (!_isEnableTimePitch) {
        return 1.0;
    }
    
    AudioQueueParameterValue value;
    OSStatus status = AudioQueueGetParameter(_audioQueue, kAudioQueueParam_PlayRate, &value);
    if (status == noErr) {
        return value;
    }
    
    return 1.0;
}


#pragma mark - ======== callback ========

static void AudioQueueOutputCallBack(void *inclientData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    PLAudioOutputQueue *audioQueue = (__bridge PLAudioOutputQueue *)inclientData;
    [audioQueue p_handleAudioQueueOutputCallBack:inAQ buffer:inBuffer];
}

- (void)p_handleAudioQueueOutputCallBack:(AudioQueueRef)inAQ buffer:(AudioQueueBufferRef)inBuffer {
    
    int bufferIndex = -1;
    
    for (unsigned int i = 0; i < kNumAQBufs; i++) {
        if (inBuffer == _buffers[i].queueBuffer) {
            bufferIndex = i;
            [_inUseBuffers addObject:_buffers[i]];
            break;
        }
    }
    
    if (bufferIndex == -1) {
        DLog(@"%@ buffer mismatch", NSStringFromClass([self class]));
        [self p_mutexSignal];
        return;
    }
    
    pthread_mutex_lock(&_mutex);
    _buffersUsed--;
    
    pthread_cond_signal(&_cond);
    
    if (_buffersUsed == 0 && _delegate) {
        pthread_mutex_unlock(&_mutex);
        if ([_delegate respondsToSelector:@selector(pl_audioQueueBuffersIsEmpty:)]) {
            [_delegate pl_audioQueueBuffersIsEmpty:self];
        }
    } else {
        pthread_mutex_unlock(&_mutex);
        if ([_delegate respondsToSelector:@selector(pl_audioQueueFinishedPlayingPacket:)]) {
            [_delegate pl_audioQueueFinishedPlayingPacket:self];
        }
    }
    
    [self p_mutexSignal];
}

static void AudioQueueIsRunningCallBack(void *inclientData, AudioQueueRef inAQ, AudioQueuePropertyID inAD) {
    PLAudioOutputQueue *audioQueue = (__bridge PLAudioOutputQueue *)inclientData;
    [audioQueue p_handleAudioQueuePropertyCallBack:inAQ property:inAD];
}

- (void)p_handleAudioQueuePropertyCallBack:(AudioQueueRef)inAQ property:(AudioQueuePropertyID)property {
    
    if (property == kAudioQueueProperty_IsRunning) {
        UInt32 isRunning = 0;
        UInt32 size = sizeof(isRunning);
        OSStatus status = AudioQueueGetProperty(inAQ, property, &isRunning, &size);
        if (status != noErr) {
            DLog(@"%@ isRunning fail", NSStringFromClass([self class]));
            return;
        }
        if (isRunning) {
            self.status = PLAudioQueueStatusRunning;
        } else {
            self.status = PLAudioQueueStatusIdle;
        }
    }
}

#pragma mark - ======== dealloc ========

- (void)dealloc {
    [self stop];
    [self p_disposeAudioOutputQueue];
    [self p_mutexDestory];
    DLOG_DEALLOC
}

@end
