//
//  NSTimer+QYAddition.m
//  MHRefresh
//
//  Created by developer on 2017/9/18.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSTimer+QYAddition.h"

@implementation NSTimer (QYAddition)

- (void)pauseTimer {
    
    if (!self.isValid) {
        return;
    }
    
    [self setFireDate:[NSDate distantFuture]];
}

- (void)resumeTimer {
    
    if (!self.isValid) {
        return;
    }
    
    [self setFireDate:[NSDate distantPast]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
