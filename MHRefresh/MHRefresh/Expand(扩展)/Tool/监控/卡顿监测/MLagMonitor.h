//
//  MLagMonitor.h
//  RunloopMonitor
//
//  Created by zyx on 16/7/6.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMonitor.h"
#if M_MONITOR_ENABLED
@interface MLagMonitor : NSObject

+ (instancetype)sharedMonitor;
- (void)beginMonitor;
- (void)endMonitor;

@end
#endif
