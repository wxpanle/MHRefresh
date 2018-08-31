//
//  QYNightModeManager.h
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYNightCore.h"

@interface QYNightModeManager : NSObject

@property (nonatomic, assign, readonly) QYNightMode qy_nightMode;

+ (instancetype)qy_nightModeManager;

- (void)qy_switchMode;

- (void)qy_switchModeToNight;

- (void)qy_switchModeToDay;

@end
