//
//  CALayer+QYNightMode.h
//  MHRefresh
//
//  Created by panle on 2018/7/25.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSObject+QYNightMode.h"

@interface CALayer (QYNightMode)

- (void)qy_setShadowColor:(UIColor *)color withNightMode:(QYNightMode)mode;

- (void)qy_setBorderColor:(UIColor *)color withNightMode:(QYNightMode)mode;

- (void)qy_setBackgroundColor:(UIColor *)color withNightMode:(QYNightMode)mode;

@end
