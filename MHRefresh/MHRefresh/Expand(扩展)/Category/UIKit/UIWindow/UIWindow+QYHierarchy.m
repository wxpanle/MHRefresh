//
//  UIWindow+QYHierarchy.m
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIWindow+QYHierarchy.h"

@implementation UIWindow (QYHierarchy)

- (UIViewController *)topMostController {
    
    UIViewController *topViewController = [self rootViewController];
    
    while ([topViewController presentedViewController]) {
        topViewController = [topViewController presentedViewController];
    }
    
    return topViewController;
}

- (UIViewController *)currentViewController {
    
    UIViewController *currentViewController = [self topMostController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController]) {
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    }

    return currentViewController;
}

@end
