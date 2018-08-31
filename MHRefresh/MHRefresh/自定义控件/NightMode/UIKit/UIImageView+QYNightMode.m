//
//  UIImageView+QYNightMode.m
//  MHRefresh
//
//  Created by panle on 2018/7/25.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "UIImageView+QYNightMode.h"

@implementation UIImageView (QYNightMode)

- (void)qy_switchNightMode {
    
    [UIView animateWithDuration:QYNightModeSwitchAnimation animations:^{
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setImage:) nightMode:self.qy_nightNode]] != nil) {
            self.image = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setImage:) nightMode:self.qy_nightNode]];
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setHighlightedImage:) nightMode:self.qy_nightNode]] != nil) {
            self.highlightedImage = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setHighlightedImage:) nightMode:self.qy_nightNode]];
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setAnimations:) nightMode:self.qy_nightNode]] != nil) {
            self.animationImages = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setAnimations:) nightMode:self.qy_nightNode]];
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setHighlightedAnimationImages:) nightMode:self.qy_nightNode]] != nil) {
            self.highlightedAnimationImages = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setHighlightedAnimationImages:) nightMode:self.qy_nightNode]];
        }
        
        if ([self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTintColor:) nightMode:self.qy_nightNode]] != nil) {
            self.tintColor = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTintColor:) nightMode:self.qy_nightNode]];
        }
    }];
}

- (void)qy_setImage:(UIImage *)image withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:image forKey:[self qy_saveKeyWithSEL:@selector(setImage:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.image = image;
    }
}

- (void)qy_setHighlightedImage:(UIImage *)image withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:image forKey:[self qy_saveKeyWithSEL:@selector(setHighlightedImage:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.highlightedImage = image;
    }
}

- (void)qy_setAnimationImages:(NSArray <UIImage *>*)images withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:images forKey:[self qy_saveKeyWithSEL:@selector(setAnimations:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.animationImages = images;
    }
}

- (void)qy_setHighlightedAnimationImages:(NSArray <UIImage *>*)images withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:images forKey:[self qy_saveKeyWithSEL:@selector(setHighlightedAnimationImages:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.highlightedAnimationImages = images;
    }
}

- (void)qy_setTintColor:(UIColor *)color withNightMode:(QYNightMode)mode {
    [self.qy_nightModeDictionary setObject:color forKey:[self qy_saveKeyWithSEL:@selector(setTintColor:) nightMode:mode]];
    if (mode == self.qy_nightNode) {
        self.tintColor = color;
    }
}

@end
