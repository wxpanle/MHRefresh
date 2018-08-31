//
//  UIView+QYSearchExtension.m
//  MHRefresh
//
//  Created by panle on 2018/7/18.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "UIView+QYSearchExtension.h"

@implementation UIView (QYSearchExtension)

- (UIViewController *)qy_searchVc {
    
    UIResponder *next = [self nextResponder];
    UIViewController *vc = nil;
    
    while (next != nil) {
        
        if ([next isKindOfClass:[UIViewController class]]) {
            vc = (UIViewController *)next;
            break;
        }
        
        next = [next nextResponder];
    }
    
    return vc;
}

- (UINavigationController *)qy_searchNavigationVc {
    
    UIViewController *vc = [self qy_searchVc];
    
    if ([vc isKindOfClass:[UINavigationController class]] ||
        [[vc class] isSubclassOfClass:[UINavigationController class]]) {
        return (UINavigationController *)vc;
    }
    
    if (vc.parentViewController &&
        ([vc.parentViewController isKindOfClass:[UINavigationController class]] ||
         [[vc.parentViewController class] isSubclassOfClass:[UINavigationController class]])) {
        return (UINavigationController *)(vc.parentViewController);
    }
    
    return nil;
}

@end
