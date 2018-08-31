//
//  CAShapeLayer+QYNightMode.m
//  MHRefresh
//
//  Created by panle on 2018/7/25.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "CAShapeLayer+QYNightMode.h"

@implementation CAShapeLayer (QYNightMode)

- (void)qy_switchNightMode {
    [super qy_switchNightMode];
    [UIView animateWithDuration:QYNightModeSwitchAnimation animations:^{
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setFillColor:) nightMode:self.qy_nightNode]] != nil) {
            self.fillColor = ((UIColor *)[self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setFillColor:) nightMode:self.qy_nightNode]]).CGColor;
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setStrokeColor:) nightMode:self.qy_nightNode]] != nil) {
            self.strokeColor = ((UIColor *)[self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setStrokeColor:) nightMode:self.qy_nightNode]]).CGColor;
        }
    }];
}

- (void)qy_setFillColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setFillColor:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.fillColor = color.CGColor;
    }
}

- (void)qy_setStrokeColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setStrokeColor:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.strokeColor = color.CGColor;
    }
}

@end
