//
//  UIBarButtonItem+QYNightMode.h
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+QYNightMode.h"

@interface UIBarButtonItem (QYNightMode)

- (void)qy_setTintColor:(UIColor *)color withNightMode:(QYNightMode)mode;

@end
