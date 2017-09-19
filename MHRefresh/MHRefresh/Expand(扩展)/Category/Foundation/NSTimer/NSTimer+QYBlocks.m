//
//  NSTimer+QYBlocks.m
//  MHRefresh
//
//  Created by developer on 2017/9/18.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSTimer+QYBlocks.h"

@implementation NSTimer (QYBlocks)

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(QYTimerActionBlock)block {
    return [self scheduledTimerWithTimeInterval:timeInterval block:block repeats:YES];
}

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(QYTimerActionBlock)block repeats:(BOOL)repeats {
    
    QYTimerActionBlock tempBlock = [block copy];
    
    return [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(executeBlock:) userInfo:tempBlock repeats:repeats];
}

+ (id)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(QYTimerActionBlock)block {
    return [self timerWithTimeInterval:timeInterval block:block repeats:YES];
}

+ (id)timerWithTimeInterval:(NSTimeInterval)timeInterval block:(QYTimerActionBlock)block repeats:(BOOL)repeats {
    QYTimerActionBlock tempBlock = [block copy];
    return [self timerWithTimeInterval:timeInterval target:self selector:@selector(executeBlock:) userInfo:tempBlock repeats:repeats];
}

+ (void)executeBlock:(NSTimer *)timer {
    
    if ([timer userInfo]) {
        QYTimerActionBlock block = (QYTimerActionBlock)[timer userInfo];
        !block ? : block();
    }
}

@end
