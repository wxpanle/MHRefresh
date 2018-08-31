//
//  UIButton+QYNightMode.h
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+QYNightMode.h"

@interface UIButton (QYNightMode)

- (void)qy_setTitleColor:(UIColor *)color
                forState:(UIControlState)state
           withNightMode:(QYNightMode)mode;

- (void)qy_setTitle:(NSString *)title
           forState:(UIControlState)state
      withNightMode:(QYNightMode)mode;

- (void)qy_setTitleShadowColor:(UIColor *)color
                      forState:(UIControlState)state
                 withNightMode:(QYNightMode)mode;

- (void)qy_setImage:(UIImage *)image
           forState:(UIControlState)state
      withNightMode:(QYNightMode)mode;

- (void)qy_setBackgroundImage:(UIImage *)image
                     forState:(UIControlState)state
                withNightMode:(QYNightMode)mode;


@end
