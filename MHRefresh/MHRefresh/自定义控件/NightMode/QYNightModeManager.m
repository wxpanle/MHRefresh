//
//  QYNightModeManager.m
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYNightModeManager.h"

static NSString *const kUserCurrentNightMode = @"kUserCurrentNightMode";

@interface QYNightModeManager ()

@property (nonatomic, assign, readwrite) QYNightMode qy_nightMode;

@end

@implementation QYNightModeManager

#pragma mark - init

+ (instancetype)qy_nightModeManager {
    
    static dispatch_once_t onceToken;
    static QYNightModeManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[QYNightModeManager alloc] init];
        manager.qy_nightMode = [manager p_nightMode];
    });
    return manager;
}


#pragma mark - public

- (void)qy_switchMode {
    [self p_switchModeWithMode:_qy_nightMode == QYNightModeNight ? QYNightModeDay : QYNightModeNight];
}

- (void)qy_switchModeToNight {
    [self p_switchModeWithMode:QYNightModeNight];
}

- (void)qy_switchModeToDay {
    [self p_switchModeWithMode:QYNightModeDay];
}


#pragma mark - private

- (void)p_switchModeWithMode:(QYNightMode)mode {
    switch (mode) {
        case QYNightModeNight:
            [self p_switchToNightMode];
            break;
            
        case QYNightModeDay:
            [self p_switchToDayMode];
            break;
    }
}

- (void)p_switchToNightMode {
    //方法
    _qy_nightMode = QYNightModeNight;
    [self p_postNotificationToSwitchNightMode];
}

- (void)p_switchToDayMode {
    //方法
    _qy_nightMode = QYNightModeDay;
    [self p_postNotificationToSwitchNightMode];
}

- (void)p_postNotificationToSwitchNightMode {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:QYNightModeSwitchNotification
                                                            object:nil];
    });
}

- (void)p_saveMode {
    [[NSUserDefaults standardUserDefaults] setInteger:_qy_nightMode forKey:kUserCurrentNightMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (QYNightMode)p_nightMode {
    return (QYNightMode)[[NSUserDefaults standardUserDefaults] integerForKey:kUserCurrentNightMode];
}

@end
