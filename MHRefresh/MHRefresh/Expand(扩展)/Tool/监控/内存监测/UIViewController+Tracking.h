//
//  UIViewController+Tracking.h
//  MLeaksFinder
//
//  Created by zyx on 16/7/7.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMonitor.h"

#if M_MONITOR_ENABLED
@interface UIViewController (Tracking)

@end
#endif
