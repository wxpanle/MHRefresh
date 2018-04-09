//
//  UIViewController+Tracking.m
//  MLeaksFinder
//
//  Created by zyx on 16/7/7.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+MLeaksFinder.h"

#if M_MONITOR_ENABLED
@implementation UIViewController (Tracking)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSelector:@selector(zyx_viewWillAppear:) withSelector:@selector(viewWillAppear:)];
        [self swizzleSelector:@selector(zyx_viewDidDisappear:) withSelector:@selector(viewDidDisappear:)];
        [self swizzleSelector:@selector(zyx_dismissViewControllerAnimated:completion:) withSelector:@selector(dismissViewControllerAnimated:completion:)];
    });
    
}

- (void)zyx_viewWillAppear:(BOOL)animated
{
    [self zyx_viewWillAppear:animated];
}

- (void)zyx_viewDidDisappear:(BOOL)animated
{
    [self zyx_viewDidDisappear:animated];    
//    BOOL flag = [objc_getAssociatedObject(self, &kTestDealloc) boolValue];
//    if (flag) {
//        [self testDealloc];
//    }
}

- (void)zyx_dismissViewControllerAnimated:(BOOL)animatied completion:(void(^)(void))completion
{
    [self zyx_dismissViewControllerAnimated:animatied completion:completion];
    UIViewController *dismissViewController = self.presentedViewController;
    if (!dismissViewController && self.presentingViewController) {
        dismissViewController = self;
    }
    [dismissViewController testDealloc];
}

- (BOOL)testDealloc
{
    if (![super testDealloc]) {
        return NO;
    }
    
    NSArray *viewStack = [self viewStack];
    for (UIViewController *controller in self.childViewControllers) {
        [controller setViewStack:[viewStack arrayByAddingObject:NSStringFromClass([controller class])]];
        [controller testDealloc];
    }
    
    [self.view setViewStack:[viewStack arrayByAddingObject:NSStringFromClass([self.view class])]];
    [self.view testDealloc];

    
    return YES;
}





@end
#endif
