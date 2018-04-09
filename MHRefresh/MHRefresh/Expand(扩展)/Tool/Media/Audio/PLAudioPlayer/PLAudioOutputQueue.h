//
//  PLAudioOutputQueue.h
//  MHRefresh
//
//  Created by panle on 2018/3/6.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef NS_ENUM(NSInteger, PLAudioQueueStatus) {
    PLAudioQueueStatusIdle,
    PLAudioQueueStatusRunning,
    PLAudioQueueStatusPaused,
    PLAudioQueueStatusPlaying
};

@class PLAudioOutputQueue;

@protocol PLAudioOutputQueueDelegate <NSObject>

- (void)pl_audioQueueStatusChange:(PLAudioOutputQueue *)audioQueue oldStatus:(PLAudioQueueStatus)oldStatus newStatus:(PLAudioQueueStatus)newStatus;

- (void)pl_audioQueueBuffersIsEmpty:(PLAudioOutputQueue *)audioQueue;

- (void)pl_audioQueueINitializationFailed:(PLAudioOutputQueue *)audioQueue;

- (void)pl_audioQueueFinishedPlayingPacket:(PLAudioOutputQueue *)audioQueue;

@end

@interface PLAudioOutputQueue : NSObject

@property (nonatomic, weak) id <PLAudioOutputQueueDelegate> delegate;

@property (nonatomic, assign, readonly, getter=isAvailable) BOOL available;

@property (nonatomic, assign, readonly, getter=isRunning) BOOL running;

@property (nonatomic, assign) UInt32 bufferSize;

@property (nonatomic, assign, readonly) AudioStreamBasicDescription format;

/** audioQueue playerTime */
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

/** default value 1.0  values[0.5, 2.0] */
@property (nonatomic, assign) CGFloat playRate;

/** defalut 0.7, values[0, 1.0] */
@property (nonatomic, assign) CGFloat volume;

- (instancetype)initWithFormat:(AudioStreamBasicDescription)format bufferSize:(UInt32)bufferSize macgicCookie:(NSData *)macgicCookie;

- (BOOL)handleAudioWithNumberPackets:(UInt32)numberPackets inPacketDescriptions:(AudioStreamPacketDescription *)inPacketDescriptions inputData:(NSData *)data;

- (BOOL)start;

- (BOOL)pause;
- (BOOL)resume;

- (void)stop;
- (void)stop:(BOOL)immediately;

- (BOOL)reset;

- (BOOL)flush;

@end
