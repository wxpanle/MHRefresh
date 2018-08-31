//
//  UIBarButtonItem+QYNightMode.m
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "UIBarButtonItem+QYNightMode.h"

@implementation UIBarButtonItem (QYNightMode)

- (void)qy_switchNightMode {
    [super qy_switchNightMode];
    [UIView animateWithDuration:QYNightModeSwitchAnimation animations:^{
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTintColor:) nightMode:self.qy_nightNode]]) {
            self.tintColor = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTintColor:) nightMode:self.qy_nightNode]];
        }
    }];
}

- (void)qy_setTintColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setTintColor:) nightMode:mode]];
    
    if (mode == self.qy_nightNode) {
        [self setTintColor:color];
    }
}

@end
