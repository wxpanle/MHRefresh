//
//  QYAudioSession.h
//  MHRefresh
//
//  Created by panle on 2018/3/1.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@protocol QYAudioSessionDelegate <NSObject>

@optional
- (void)audioRouteChangeDetectorDidDetectAudioSessionPropertyChangeWithReason:(AVAudioSessionRouteChangeReason)reason notification:(NSNotification*)notification;

@end

@interface QYAudioSession : NSObject

+ (instancetype)shardeInstance;

- (void)addAudioSessionDelegate:(__weak id <QYAudioSessionDelegate>)delegate;

- (void)removeAudioSessionDelegate:(__weak id <QYAudioSessionDelegate>)delegate;

+ (void)requestRecordPermissionWithCallback:(void (^)(BOOL))callback;

+ (BOOL)setAudioSessionCategory:(NSString*)category withOptions:(AVAudioSessionCategoryOptions)options;
+ (BOOL)setAudioSessionCategoryIfNeeded:(NSString*)category withOptions:(AVAudioSessionCategoryOptions)options;
+ (BOOL)setAudioSessionCategoryAmbientIfNeeded;
+ (BOOL)setAudioSessionCategorySoloAmbientIfNeeded;
+ (BOOL)setAudioSessionCategoryPlaybackIfNeeded;
+ (BOOL)setAudioSessionCategoryRecordIfNeeded;
+ (BOOL)setAudioSessionCategoryPlayAndRecordIfNeeded;

+ (BOOL)setAudioSessionActive:(BOOL)active;

+ (BOOL)isUsingHeadset;
+ (BOOL)isAirplayActived;
+ (BOOL)isInputMicrophoneWiredAndOutputWiredHeadphones;




@end
