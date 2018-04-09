
//
//  UINavigationController+MTracking.m
//  MLeaksFinder
//
//  Created by zyx on 16/7/8.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "UINavigationController+MTracking.h"
#import "NSObject+MLeaksFinder.h"
#import <objc/runtime.h>
#import <objc/message.h>
#if M_MONITOR_ENABLED
@implementation UINavigationController (MTracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(pushViewController:animated:) withSelector:@selector(zyx_pushViewController:animated:)];
        [self swizzleSelector:@selector(popViewControllerAnimated:) withSelector:@selector(zyx_popViewControllerAnimated:)];
        [self swizzleSelector:@selector(popToRootViewControllerAnimated:) withSelector:@selector(zyx_popToRootViewControllerAnimated:)];
        [self swizzleSelector:@selector(popToViewController:animated:) withSelector:@selector(zyx_popToViewController:animated:)];
    });
}

#pragma mark - swizzled

- (void)zyx_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self zyx_pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)zyx_popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [self zyx_popViewControllerAnimated:animated];
    
    if (vc == nil) {
        return nil;
    }
    NSArray *viewStack = [self viewStack];

    [vc setViewStack:[viewStack arrayByAddingObject:NSStringFromClass([vc class])]];
    [vc testDealloc];
    
    return vc;
}
- (nullable NSArray<__kindof UIViewController *> *)zyx_popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    NSArray *viewControllerArray = [self zyx_popToViewController:viewController animated:animated];
    
    NSArray *viewStack = [self viewStack];
    for (UIViewController *popVc in viewControllerArray) {
        [popVc setViewStack:[viewStack arrayByAddingObject:NSStringFromClass([popVc class])]];
        [popVc testDealloc];
    }
    
    return viewControllerArray;
    
}
- (nullable NSArray<__kindof UIViewController *> *)zyx_popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray *viewControllerArray = [self zyx_popToRootViewControllerAnimated:animated];

    NSArray *viewStack = [self viewStack];
    for (UIViewController *popVc in viewControllerArray) {
        [popVc setViewStack:[viewStack arrayByAddingObject:NSStringFromClass([popVc class])]];
        [popVc testDealloc];
    }
    return viewControllerArray;
}

#pragma mark - 

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
