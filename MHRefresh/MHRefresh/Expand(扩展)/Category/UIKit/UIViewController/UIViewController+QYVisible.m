//
//  UIViewController+QYVisible.m
//  MHRefresh
//
//  Created by developer on 2017/9/8.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "UIViewController+QYVisible.h"

@implementation UIViewController (QYVisible)

- (BOOL)isVisible {
    return ([self isViewLoaded] && self.view.window) ? YES : NO;
}

@end
