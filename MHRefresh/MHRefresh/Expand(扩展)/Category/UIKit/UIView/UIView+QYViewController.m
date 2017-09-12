//
//  UIView+QYViewController.m
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIView+QYViewController.h"

@implementation UIView (QYViewController)

- (nullable UIViewController *)getContainerViewController {
    
    UIViewController *resultController = nil;
    
    for (UIView *next = self.superview; next; next = next.superview) {
        
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            resultController = (UIViewController *)nextResponder;
            break;
        }
    }
    
    return resultController;
}

@end
