//
//  UIView+MTracking.m
//  MLeaksFinder
//
//  Created by zyx on 16/7/7.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "UIView+MTracking.h"
#import "NSObject+MLeaksFinder.h"
#if M_MONITOR_ENABLED
@implementation UIView (MTracking)

- (BOOL)testDealloc
{
    if (![super testDealloc]) {
        return NO;
    }
    
    NSArray *viewStack = [self viewStack];
    for (UIView *subView in self.subviews) {
        [viewStack setViewStack:[viewStack arrayByAddingObject:NSStringFromClass([subView class])]];
        [viewStack testDealloc];
    }
    return YES;
}

@end
#endif
