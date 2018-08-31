//
//  PLAudioSession.h
//  MHRefresh
//
//  Created by panle on 2018/3/9.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol PLAudioSessionDelegate <NSObject>

@optional
- (void)audioRouteChangeDetectorDidDetectAudioSessionPropertyChangeWithReason:(AVAudioSessionRouteChangeReason)reason notification:(NSNotification*)notification;

- (void)audioInterruptNotification:(NSNotification *)notification;

@end

@interface PLAudioSession : NSObject

+ (instancetype)shardeInstance;

- (void)addAudioSessionDelegate:(__weak id <PLAudioSessionDelegate>)delegate;

- (void)removeAudioSessionDelegate:(__weak id <PLAudioSessionDelegate>)delegate;

+ (void)requestRecordPermissionWithCallback:(void (^)(BOOL))callback;

+ (BOOL)setAudioSessionCategory:(NSString*)category withOptions:(AVAudioSessionCategoryOptions)options;
+ (BOOL)setAudioSessionCategoryIfNeeded:(NSString*)category withOptions:(AVAudioSessionCategoryOptions)options;
+ (BOOL)setAudioSessionCategoryAmbientIfNeeded;
+ (BOOL)setAudioSessionCategorySoloAmbientIfNeeded;
+ (BOOL)setAudioSessionCategoryPlaybackIfNeeded;
+ (BOOL)setAudioSessionCategoryRecordIfNeeded;
+ (BOOL)setAudioSessionCategoryPlayAndRecordIfNeeded;

+ (BOOL)setAudioSessionActive:(BOOL)active;

+ (BOOL)setAudioSessionActive:(BOOL)active options:(AVAudioSessionSetActiveOptions)options;


+ (BOOL)isUsingHeadset;
+ (BOOL)isAirplayActived;
+ (BOOL)isInputMicrophoneWiredAndOutputWiredHeadphones;

@end
