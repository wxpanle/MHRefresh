//
//  UIView+MMainThreadMonitor.h
//  Memory
//
//  Created by zyx on 16/8/2.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMonitor.h"

#if M_MONITOR_ENABLED
@interface UIView (MMainThreadMonitor)

@end
#endif
