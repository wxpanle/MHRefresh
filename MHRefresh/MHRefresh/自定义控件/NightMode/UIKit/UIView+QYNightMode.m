//
//  UIView+QYNightMode.m
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "UIView+QYNightMode.h"
#import <objc/runtime.h>

@implementation UIView (QYNightMode)

#pragma mark - overwrite

- (void)qy_switchNightMode {
    [super qy_switchNightMode];
    [self.layer qy_switchNightMode];
    [UIView animateWithDuration:QYNightModeSwitchAnimation animations:^{
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTintColor:) nightMode:self.qy_nightNode]] != nil) {
            self.tintColor = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTintColor:) nightMode:self.qy_nightNode]];
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setBackgroundColor:) nightMode:self.qy_nightNode]] != nil) {
            self.backgroundColor = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setBackgroundColor:) nightMode:self.qy_nightNode]];
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setAlpha:) nightMode:self.qy_nightNode]] != nil) {
            self.alpha = [[self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setAlpha:) nightMode:self.qy_nightNode]] floatValue];
        }
    }];
}


#pragma mark - tintColor

- (void)qy_setTintColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color
                                    forKey:[self qy_saveKeyWithSEL:@selector(setTintColor:) nightMode:mode]];
    
    if (mode == self.qy_nightNode) {
        [self setTintColor:color];
    }
}


#pragma mark - backgroundColor

- (void)qy_setBackGroundColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color
                                    forKey:[self qy_saveKeyWithSEL:@selector(setBackgroundColor:) nightMode:mode]];
    
    if (mode == self.qy_nightNode) {
        [self setBackgroundColor:color];
    }
}

#pragma mark - alpha

- (void)qy_setAlpha:(CGFloat)alpha withNightMode:(QYNightMode)mode {
    
    [self.qy_nightModeDictionary setObject:@(alpha) forKey:[self qy_saveKeyWithSEL:@selector(setAlpha:) nightMode:mode]];
    
    if (mode == self.qy_nightNode) {
        self.alpha = alpha;
    }
}



@end
