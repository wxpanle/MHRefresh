//
//  PLAudioPlayer.h
//  MHRefresh
//
//  Created by panle on 2018/3/6.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLAudioFileSource.h"

typedef NS_ENUM(NSInteger, PLAudioPlayerStatus) {
    PLAPStatusPlaying,
    PLAPStatusPaused,
    PLAPStatusStopped,
    PLAPStatusBuffering,
    PLAPStatusError,
};

@interface PLAudioPlayer : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)initWithAudioFileSource:(id <PLAudioFileSource>)audioFileSource;

@property (nonatomic, assign, readonly) PLAudioPlayerStatus status;
@property (nonatomic, readonly) NSError *error;

@property (nonatomic, readonly) id <PLAudioFileSource> audioFileSource;
@property (nonatomic, readonly) NSURL *url;

@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign, readonly) NSTimeInterval currentTime;

@property (nonatomic, readonly) NSString *cachedPath;
@property (nonatomic, readonly) NSURL *cacheURL;

@property (nonatomic, assign, readonly) UInt64 audioLength;

@property (nonatomic, assign, readonly) CGFloat bufferingRation;

/** value [0, 1.0] */
@property (nonatomic, assign) CGFloat volume;
/** value [0.5, 2.0] */
@property (nonatomic, assign) CGFloat playRate;


- (void)play;
- (void)pause;
- (void)stop;

- (void)seekTime:(NSTimeInterval)time;

@end




