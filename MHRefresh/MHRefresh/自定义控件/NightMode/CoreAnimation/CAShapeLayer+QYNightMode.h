//
//  CAShapeLayer+QYNightMode.h
//  MHRefresh
//
//  Created by panle on 2018/7/25.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSObject+QYNightMode.h"

@interface CAShapeLayer (QYNightMode)

- (void)qy_setFillColor:(UIColor *)color withNightMode:(QYNightMode)mode;

- (void)qy_setStrokeColor:(UIColor *)color withNightMode:(QYNightMode)mode;

@end
