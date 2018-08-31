//
//  QYNightCore.h
//  MHRefresh
//
//  Created by panle on 2018/7/25.
//  Copyright © 2018年 developer. All rights reserved.
//

#ifndef QYNightCore_h
#define QYNightCore_h

#ifdef __OBJC__

static NSString *const QYNightModeSwitchNotification = @"kNightModeSwitchNotification";
static const CGFloat QYNightModeSwitchAnimation = 0.25;

typedef NS_ENUM(NSInteger, QYNightMode) {
    QYNightModeDay = 0,
    QYNightModeNight
};

#endif

#endif /* QYNightCore_h */
