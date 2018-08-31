//
//  CALayer+QYNightMode.m
//  MHRefresh
//
//  Created by panle on 2018/7/25.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "CALayer+QYNightMode.h"

@implementation CALayer (QYNightMode)

- (void)qy_switchNightMode {
    [UIView animateWithDuration:QYNightModeSwitchAnimation animations:^{
       
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setShadowColor:) nightMode:self.qy_nightNode]] != nil) {
            self.shadowColor = ((UIColor *)[self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setShadowColor:) nightMode:self.qy_nightNode]]).CGColor;
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setBorderColor:) nightMode:self.qy_nightNode]] != nil) {
            self.borderColor = ((UIColor *)[self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setBorderColor:) nightMode:self.qy_nightNode]]).CGColor;
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setBackgroundColor:) nightMode:self.qy_nightNode]] != nil) {
            self.backgroundColor = ((UIColor *)[self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setBackgroundColor:) nightMode:self.qy_nightNode]]).CGColor;
        }
    }];
}

- (void)qy_setShadowColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setShadowColor:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.shadowColor = color.CGColor;
    }
}

- (void)qy_setBorderColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setBorderColor:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.borderColor = color.CGColor;
    }
}

- (void)qy_setBackgroundColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setBackgroundColor:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.backgroundColor = color.CGColor;
    }
}

@end
