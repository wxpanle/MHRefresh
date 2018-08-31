//
//  UILabel+QYNightMode.m
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "UILabel+QYNightMode.h"

@implementation UILabel (QYNightMode)

- (void)qy_switchNightMode {
    [super qy_switchNightMode];
    [UIView animateWithDuration:QYNightModeSwitchAnimation animations:^{
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTextColor:) nightMode:self.qy_nightNode]] != nil) {
            self.textColor = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTextColor:) nightMode:self.qy_nightNode]];
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setShadowColor:) nightMode:self.qy_nightNode]] != nil) {
            self.shadowColor = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setShadowColor:) nightMode:self.qy_nightNode]];
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setHighlightedTextColor:) nightMode:self.qy_nightNode]] != nil) {
            self.highlightedTextColor = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setHighlightedTextColor:) nightMode:self.qy_nightNode]];
        }
    }];
}

- (void)qy_setTextColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setTextColor:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        [self setTextColor:color];
    }
}

- (void)qy_setShadowColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setShadowColor:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        [self setShadowColor:color];
    }
}

- (void)qy_setHighlightedTextColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setHighlightedTextColor:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        [self setHighlightedTextColor:color];
    }
}

@end
