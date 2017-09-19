//
//  NSTimer+QYAddition.h
//  MHRefresh
//
//  Created by developer on 2017/9/18.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (QYAddition)

- (void)pauseTimer;

- (void)resumeTimer;

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
