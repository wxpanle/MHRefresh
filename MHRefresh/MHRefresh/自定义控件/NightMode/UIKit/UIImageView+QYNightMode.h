//
//  UIImageView+QYNightMode.h
//  MHRefresh
//
//  Created by panle on 2018/7/25.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+QYNightMode.h"

@interface UIImageView (QYNightMode)

- (void)qy_setImage:(UIImage *)image withNightMode:(QYNightMode)mode;

- (void)qy_setHighlightedImage:(UIImage *)image withNightMode:(QYNightMode)mode;

- (void)qy_setAnimationImages:(NSArray <UIImage *>*)images withNightMode:(QYNightMode)mode;

- (void)qy_setHighlightedAnimationImages:(NSArray <UIImage *>*)images withNightMode:(QYNightMode)mode;

- (void)qy_setTintColor:(UIColor *)color withNightMode:(QYNightMode)mode;

@end
