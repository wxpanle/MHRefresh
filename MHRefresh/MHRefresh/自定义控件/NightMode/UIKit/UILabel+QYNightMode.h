//
//  UILabel+QYNightMode.h
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+QYNightMode.h"

@interface UILabel (QYNightMode)

- (void)qy_setTextColor:(UIColor *)color withNightMode:(QYNightMode)mode;

- (void)qy_setShadowColor:(UIColor *)color withNightMode:(QYNightMode)mode;

- (void)qy_setHighlightedTextColor:(UIColor *)color withNightMode:(QYNightMode)mode;

@end
