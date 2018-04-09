//
//  QYAudioSession.m
//  MHRefresh
//
//  Created by panle on 2018/3/1.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYAudioSession.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface QYAudioSession () {
    NSHashTable *_observesTable;
}

@end

@implementation QYAudioSession

#pragma mark - ======== init ========

+ (instancetype)shardeInstance {
    static QYAudioSession *audioSession = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioSession = [[self alloc] init];
    });
    return audioSession;
}

- (instancetype)init {
    if (self = [super init]) {
        _observesTable = [NSHashTable weakObjectsHashTable];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionDidChangeProperty:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    }
    return self;
}


#pragma mark - ======== public object method ========

- (void)addAudioSessionDelegate:(id <QYAudioSessionDelegate>)delegate {
    
    if ([delegate conformsToProtocol:@protocol(QYAudioSessionDelegate)] &&
        ![_observesTable containsObject:delegate]) {
        [_observesTable addObject:delegate];
    }
}

- (void)removeAudioSessionDelegate:(id <QYAudioSessionDelegate>)delegate {
    if ([_observesTable containsObject:delegate]) {
        [_observesTable removeObject:delegate];
    }
}


#pragma mark - ======== public class method ========

+ (void)requestRecordPermissionWithCallback:(void (^)(BOOL))callback
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (callback) {
            if ([NSThread isMainThread]) {
                callback(granted);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(granted);
                });
            }
        }
    }];
}

+ (BOOL)setAudioSessionCategory:(NSString*)category withOptions:(AVAudioSessionCategoryOptions)options {
    
    BOOL success = NO;
    NSError* error = nil;
    success = [[AVAudioSession sharedInstance] setCategory:category withOptions:options error:&error];
    if(success == NO || error){
        DLog(@"setCategory:withOption: failure, error: %@", error);
    }
    return success;
}

+ (BOOL)setAudioSessionCategoryIfNeeded:(NSString*)category withOptions:(AVAudioSessionCategoryOptions)options {
    
    if ([[[AVAudioSession sharedInstance] category] isEqualToString:category]) {
        return YES;
    } else {
        return [self setAudioSessionCategory:category withOptions:options];
    }
}

+ (BOOL)setAudioSessionCategoryAmbientIfNeeded {
    return [self setAudioSessionCategoryIfNeeded:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers];
}

+ (BOOL)setAudioSessionCategorySoloAmbientIfNeeded {
    return [self setAudioSessionCategoryIfNeeded:AVAudioSessionCategorySoloAmbient withOptions:AVAudioSessionCategoryOptionMixWithOthers];
}

+ (BOOL)setAudioSessionCategoryPlaybackIfNeeded {
    return [self setAudioSessionCategoryIfNeeded:AVAudioSessionCategoryPlayback withOptions:0];
}

+ (BOOL)setAudioSessionCategoryRecordIfNeeded {
    return [self setAudioSessionCategoryIfNeeded:AVAudioSessionCategoryRecord withOptions:0];
}

+ (BOOL)setAudioSessionCategoryPlayAndRecordIfNeeded {
    return [self setAudioSessionCategoryIfNeeded:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker];
}

+ (BOOL)setAudioSessionActive:(BOOL)active {
    BOOL success = NO;
    NSError* error = nil;
    success = [[AVAudioSession sharedInstance] setActive:YES error:&error];
    if (success == NO || error) {
        DLog(@"setActive: failure, error: %@", error);
    }
    return success;
}

+ (BOOL)isUsingHeadset {
    
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif

    BOOL isUsingHeadset = NO;
    for (AVAudioSessionPortDescription *outputPortDescription in [[[AVAudioSession sharedInstance] currentRoute] outputs]) {
        if ([outputPortDescription.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            isUsingHeadset = YES;
        }
    }
    
    return isUsingHeadset;
}

+ (BOOL)isAirplayActived {
    
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif
    
    BOOL isAirplayActived = NO;
    for (AVAudioSessionPortDescription *outputPortDescription in [[[AVAudioSession sharedInstance] currentRoute] outputs]) {
        if ([outputPortDescription.portType isEqualToString:AVAudioSessionPortAirPlay]) {
            isAirplayActived = YES;
        }
    }
    
    return isAirplayActived;
}

+ (BOOL)isInputMicrophoneWiredAndOutputWiredHeadphones {
    
    if (![self setAudioSessionCategoryPlayAndRecordIfNeeded]){
        return NO;
    }
    if (![self setAudioSessionActive:YES]) {
        return NO;
    }
    
    BOOL isInputMicrophoneWired  = NO;
    BOOL isOutputWiredHeadphones = NO;
    
    for (AVAudioSessionPortDescription* inputPortDescription in [[[AVAudioSession sharedInstance] currentRoute] inputs]) {
        if ([inputPortDescription.portType isEqualToString:AVAudioSessionPortHeadsetMic]) {
            isInputMicrophoneWired = YES;
        }
    }
    for (AVAudioSessionPortDescription* outputPortDescription in [[[AVAudioSession sharedInstance] currentRoute] outputs]) {
        if ([outputPortDescription.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            isOutputWiredHeadphones = YES;
        }
    }
    
    return (isInputMicrophoneWired & isOutputWiredHeadphones);
}


#pragma mark - ======== notification ========

- (void)audioSessionDidChangeProperty:(NSNotification*)notification {
    
    if (_observesTable.count == 0) {
        return;
    }
    
    AVAudioSessionRouteChangeReason routeChangeReason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    for (id <QYAudioSessionDelegate> observer in _observesTable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([observer respondsToSelector:@selector(audioRouteChangeDetectorDidDetectAudioSessionPropertyChangeWithReason:notification:)]) {
                [observer audioRouteChangeDetectorDidDetectAudioSessionPropertyChangeWithReason:routeChangeReason notification:notification];
            }
        });
    }
}



@end
