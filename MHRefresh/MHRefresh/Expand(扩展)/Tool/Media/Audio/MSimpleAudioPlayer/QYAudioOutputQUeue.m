//
//  QYAudioOutputQueue.m
//  MHRefresh
//
//  Created by panle on 2018/3/1.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYAudioOutputQueue.h"
#import <pthread.h>

const int MCAudioQueueBufferCount = 2;

@interface MCAudioQueueBuffer : NSObject
@property (nonatomic,assign) AudioQueueBufferRef buffer;
@end
@implementation MCAudioQueueBuffer
@end


@interface QYAudioOutputQueue () {
    AudioQueueRef _audioQueue;
    NSMutableArray *_buffers;
    NSMutableArray *_reusableBuffers;
    
    BOOL _isRunning;
    BOOL _started;
    
    pthread_mutex_t _mutex;
    pthread_cond_t _cond;
}

@end

@implementation QYAudioOutputQueue

#pragma mark - init & dealloc
- (instancetype)initWithFormat:(AudioStreamBasicDescription)format  bufferSize:(UInt32)bufferSize macgicCookie:(NSData *)macgicCookie
{
    self = [super init];
    if (self)
    {
        _format = format;
        _volume = 1.0f;
        _bufferSize = bufferSize;
        _buffers = [[NSMutableArray alloc] init];
        _reusableBuffers = [[NSMutableArray alloc] init];
        [self _createAudioOutputQueue:macgicCookie];
        [self _mutexInit];
    }
    return self;
}


- (void)dealloc
{
    [self _disposeAudioOutputQueue];
    [self _mutexDestory];
}

#pragma mark - error
- (void)_errorForOSStatus:(OSStatus)status error:(NSError *__autoreleasing *)outError
{
    if (status != noErr && outError != NULL)
    {
        *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
    }
}

#pragma mark - mutex
- (void)_mutexInit
{
    pthread_mutex_init(&_mutex, NULL);
    pthread_cond_init(&_cond, NULL);
}

- (void)_mutexDestory
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

- (void)_mutexWait
{
    pthread_mutex_lock(&_mutex);
    pthread_cond_wait(&_cond, &_mutex);
    pthread_mutex_unlock(&_mutex);
}

- (void)_mutexSignal
{
    pthread_mutex_lock(&_mutex);
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
}

#pragma mark - audio queue
- (void)_createAudioOutputQueue:(NSData *)magicCookie
{
    OSStatus status = AudioQueueNewOutput(&_format,MCAudioQueueOutputCallback, (__bridge void *)(self), NULL, NULL, 0, &_audioQueue);
    if (status != noErr)
    {
        _audioQueue = NULL;
        return;
    }
    
    status = AudioQueueAddPropertyListener(_audioQueue, kAudioQueueProperty_IsRunning, MCAudioQueuePropertyCallback, (__bridge void *)(self));
    if (status != noErr)
    {
        AudioQueueDispose(_audioQueue, YES);
        _audioQueue = NULL;
        return;
    }
    
    if (_buffers.count == 0)
    {
        for (int i = 0; i < MCAudioQueueBufferCount; ++i)
        {
            AudioQueueBufferRef buffer;
            status = AudioQueueAllocateBuffer(_audioQueue, _bufferSize * 2, &buffer);
            if (status != noErr)
            {
                AudioQueueDispose(_audioQueue, YES);
                _audioQueue = NULL;
                
                return;
            }
            MCAudioQueueBuffer *bufferObj = [[MCAudioQueueBuffer alloc] init];
            bufferObj.buffer = buffer;
            [_buffers addObject:bufferObj];
            [_reusableBuffers addObject:bufferObj];
        }
    }
    
#if TARGET_OS_IPHONE
    UInt32 property = kAudioQueueHardwareCodecPolicy_PreferSoftware;
    [self setProperty:kAudioQueueProperty_HardwareCodecPolicy dataSize:sizeof(property) data:&property error:NULL];
#endif
    
    if (magicCookie)
    {
        AudioQueueSetProperty(_audioQueue, kAudioQueueProperty_MagicCookie, [magicCookie bytes], (UInt32)[magicCookie length]);
    }
    
    if (status == noErr) {
        DLog(@"1124124");
    } else {
        DLog(@"213123124");
    }
    
    [self setVolumeParameter];

    UInt32 enableTimePitchConversion = 1;
    
    status = AudioQueueSetProperty (_audioQueue, kAudioQueueProperty_EnableTimePitch, &enableTimePitchConversion, sizeof(enableTimePitchConversion));
    if (status != noErr) {
        DLog(@"Failed to enable time and pitch conversion. Play rate setting will fail");
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        AudioQueueParameterValue value = 4.0;
        OSStatus status = AudioQueueSetParameter(_audioQueue, kAudioQueueParam_PlayRate, value);
        AudioQueueGetParameter(_audioQueue, kAudioQueueParam_PlayRate, &value);
        DLog(@"%f", value);
        
    });
    
}

- (void)_disposeAudioOutputQueue
{
    if (_audioQueue != NULL)
    {
        AudioQueueDispose(_audioQueue,true);
        _audioQueue = NULL;
    }
}

- (BOOL)_start
{
    OSStatus status = AudioQueueStart(_audioQueue, NULL);
    _started = status == noErr;
    return _started;
}

- (BOOL)resume
{
    return [self _start];
}

- (BOOL)pause
{
    OSStatus status = AudioQueuePause(_audioQueue);
    _started = NO;
    return status == noErr;
}

- (BOOL)reset
{
    OSStatus status = AudioQueueReset(_audioQueue);
    return status == noErr;
}

- (BOOL)flush
{
    OSStatus status = AudioQueueFlush(_audioQueue);
    return status == noErr;
}

- (BOOL)stop:(BOOL)immediately
{
    OSStatus status = noErr;
    if (immediately)
    {
        status = AudioQueueStop(_audioQueue, true);
    }
    else
    {
        status = AudioQueueStop(_audioQueue, false);
    }
    _started = NO;
//    _playedTime = 0;
    return status == noErr;
}

- (BOOL)playData:(NSData *)data packetCount:(UInt32)packetCount packetDescriptions:(AudioStreamPacketDescription *)packetDescriptions isEof:(BOOL)isEof
{
    if ([data length] > _bufferSize)
    {
        return NO;
    }
    
    if (_reusableBuffers.count == 0)
    {
        if (!_started && ![self _start])
        {
            return NO;
        }
        [self _mutexWait];
    }
    
    MCAudioQueueBuffer *bufferObj = [_reusableBuffers firstObject];
    [_reusableBuffers removeObject:bufferObj];
    if (!bufferObj)
    {
        AudioQueueBufferRef buffer;
        OSStatus status = AudioQueueAllocateBuffer(_audioQueue, _bufferSize, &buffer);
        if (status == noErr)
        {
            bufferObj = [[MCAudioQueueBuffer alloc] init];
            bufferObj.buffer = buffer;
        }
        else
        {
            return NO;
        }
    }
    memcpy(bufferObj.buffer->mAudioData, [data bytes], [data length]);
    bufferObj.buffer->mAudioDataByteSize = (UInt32)[data length];
    
    OSStatus status = AudioQueueEnqueueBuffer(_audioQueue, bufferObj.buffer, packetCount, packetDescriptions);
    
    if (status == noErr)
    {
        if (_reusableBuffers.count == 0 || isEof)
        {
            if (!_started && ![self _start])
            {
                return NO;
            }
        }
    }
    
    return status == noErr;
}

- (BOOL)setProperty:(AudioQueuePropertyID)propertyID dataSize:(UInt32)dataSize data:(const void *)data error:(NSError *__autoreleasing *)outError
{
    OSStatus status = AudioQueueSetProperty(_audioQueue, propertyID, data, dataSize);
    [self _errorForOSStatus:status error:outError];
    return status == noErr;
}

- (BOOL)getProperty:(AudioQueuePropertyID)propertyID dataSize:(UInt32 *)dataSize data:(void *)data error:(NSError *__autoreleasing *)outError
{
    OSStatus status = AudioQueueGetProperty(_audioQueue, propertyID, data, dataSize);
    [self _errorForOSStatus:status error:outError];
    return status == noErr;
}

- (BOOL)setParameter:(AudioQueueParameterID)parameterId value:(AudioQueueParameterValue)value error:(NSError *__autoreleasing *)outError
{
    OSStatus status = AudioQueueSetParameter(_audioQueue, parameterId, value);
    [self _errorForOSStatus:status error:outError];
    return status == noErr;
}

- (BOOL)getParameter:(AudioQueueParameterID)parameterId value:(AudioQueueParameterValue *)value error:(NSError *__autoreleasing *)outError
{
    OSStatus status = AudioQueueGetParameter(_audioQueue, parameterId, value);
    [self _errorForOSStatus:status error:outError];
    return status == noErr;
}


#pragma mark - property
- (NSTimeInterval)playedTime
{
    if (_format.mSampleRate == 0)
    {
        return 0;
    }
    
    AudioTimeStamp time;
    OSStatus status = AudioQueueGetCurrentTime(_audioQueue, NULL, &time, NULL);
    if (status == noErr)
    {
//        _playedTime = time.mSampleTime / _format.mSampleRate;
    }
    
//    return _playedTime;
    return 1.0;
}

- (BOOL)available
{
    return _audioQueue != NULL;
}

- (void)setVolume:(float)volume
{
    _volume = volume;
    [self setVolumeParameter];
}

- (void)setVolumeParameter
{
    [self setParameter:kAudioQueueParam_Volume value:_volume error:NULL];
}

#pragma mark - call back
static void MCAudioQueueOutputCallback(void *inClientData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer)
{
    QYAudioOutputQueue *audioOutputQueue = (__bridge QYAudioOutputQueue *)inClientData;
    [audioOutputQueue handleAudioQueueOutputCallBack:inAQ buffer:inBuffer];
}

- (void)handleAudioQueueOutputCallBack:(AudioQueueRef)audioQueue buffer:(AudioQueueBufferRef)buffer
{
    for (int i = 0; i < _buffers.count; ++i)
    {
        if (buffer == [_buffers[i] buffer])
        {
            [_reusableBuffers addObject:_buffers[i]];
            break;
        }
    }
    
    [self _mutexSignal];
}

static void MCAudioQueuePropertyCallback(void *inUserData, AudioQueueRef inAQ, AudioQueuePropertyID inID)
{
    QYAudioOutputQueue *audioQueue = (__bridge QYAudioOutputQueue *)inUserData;
    [audioQueue handleAudioQueuePropertyCallBack:inAQ property:inID];
}

- (void)handleAudioQueuePropertyCallBack:(AudioQueueRef)audioQueue property:(AudioQueuePropertyID)property
{
    if (property == kAudioQueueProperty_IsRunning)
    {
        UInt32 isRunning = 0;
        UInt32 size = sizeof(isRunning);
        AudioQueueGetProperty(audioQueue, property, &isRunning, &size);
        _isRunning = isRunning;
    }
}


@end
