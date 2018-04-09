//
//  UITabBarController+MTracking.m
//  MLeaksFinder
//
//  Created by zyx on 16/7/8.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "UITabBarController+MTracking.h"
#import "NSObject+MLeaksFinder.h"
#if M_MONITOR_ENABLED
@implementation UITabBarController (MTracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
}

#pragma mark - swizzled

- (BOOL)testDealloc
{
    
    if (![super testDealloc]) {
        return NO;
    }
    
    NSArray *viewStack = [self viewStack];
    for (UIViewController *vc in self.viewControllers) {
        [vc setViewStack:[viewStack arrayByAddingObject:NSStringFromClass([vc class])]];
        [vc testDealloc];
    }
    
    return YES;
}


@end
#endif
