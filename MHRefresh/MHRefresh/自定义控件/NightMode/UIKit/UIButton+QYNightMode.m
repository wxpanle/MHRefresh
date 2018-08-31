//
//  UIButton+QYNightMode.m
//  MHRefresh
//
//  Created by panle on 2018/7/24.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "UIButton+QYNightMode.h"

@implementation UIButton (QYNightMode)

- (void)qy_switchNightMode {
    
    [super qy_switchNightMode];
    
    [UIView animateWithDuration:QYNightModeSwitchAnimation animations:^{
        
        NSMutableDictionary *titleDict = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTitle:forState:) nightMode:self.qy_nightNode]];
        if (titleDict != nil) {
            for (NSString *state in titleDict.allKeys) {
                NSString *title = [titleDict objectForKey:state];
                [self setTitle:title forState:[state integerValue]];
            }
        }
       
        NSMutableDictionary *titleColorDict = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTitleColor:forState:) nightMode:self.qy_nightNode]];
        if (titleColorDict != nil) {
            for (NSString *state in titleColorDict.allKeys) {
                UIColor *color = [titleColorDict objectForKey:state];
                [self setTitleColor:color forState:[state integerValue]];
            }
        }
        
        NSMutableDictionary *titleShadowColorDict = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setTitleShadowColor:forState:) nightMode:self.qy_nightNode]];
        if (titleShadowColorDict != nil) {
            for (NSString *state in titleShadowColorDict.allKeys) {
                UIColor *color = [titleShadowColorDict objectForKey:state];
                [self setTitleShadowColor:color forState:[state integerValue]];
            }
        }
        
        NSMutableDictionary *imageDict = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setImage:forState:) nightMode:self.qy_nightNode]];
        if (imageDict != nil) {
            for (NSString *state in imageDict.allKeys) {
                UIImage *image = [imageDict objectForKey:state];
                [self setImage:image forState:[state integerValue]];
            }
        }
        
        NSMutableDictionary *backgroundImageDict = [self.qy_nightModeDictionary objectForKey:[self qy_saveKeyWithSEL:@selector(setBackgroundImage:forState:) nightMode:self.qy_nightNode]];
        if (backgroundImageDict != nil) {
            for (NSString *state in backgroundImageDict.allKeys) {
                UIImage *image = [backgroundImageDict objectForKey:state];
                [self setBackgroundImage:image forState:[state integerValue]];
            }
        }
    }];
}

- (void)qy_setTitleColor:(UIColor *)color
                forState:(UIControlState)state
           withNightMode:(QYNightMode)mode {
    
    NSString *saveKey = [self qy_saveKeyWithSEL:@selector(setTitleColor:forState:) nightMode:mode];
    NSMutableDictionary *titleColorDict = [self.qy_nightModeDictionary objectForKey:saveKey];
    if (!titleColorDict) {
        titleColorDict = [[NSMutableDictionary alloc] init];
    }
    [titleColorDict setObject:color forKey:@(state).stringValue];
    [self.qy_nightModeDictionary setObject:titleColorDict forKey:saveKey];
    
    if (mode == self.qy_nightNode) {
        [self setTitleColor:color forState:state];
    }
}

- (void)qy_setTitle:(NSString *)title
           forState:(UIControlState)state
      withNightMode:(QYNightMode)mode {
    NSString *saveKey = [self qy_saveKeyWithSEL:@selector(setTitle:forState:) nightMode:mode];
    NSMutableDictionary *titleColorDict = [self.qy_nightModeDictionary objectForKey:saveKey];
    if (!titleColorDict) {
        titleColorDict = [[NSMutableDictionary alloc] init];
    }
    [titleColorDict setObject:title forKey:@(state).stringValue];
    [self.qy_nightModeDictionary setObject:titleColorDict forKey:saveKey];
    
    if (mode == self.qy_nightNode) {
        [self setTitle:title forState:state];
    }
}

- (void)qy_setTitleShadowColor:(UIColor *)color
                      forState:(UIControlState)state
                 withNightMode:(QYNightMode)mode {
    NSString *saveKey = [self qy_saveKeyWithSEL:@selector(setTitleShadowColor:forState:) nightMode:mode];
    NSMutableDictionary *titleShadowColorDict = [self.qy_nightModeDictionary objectForKey:saveKey];
    if (!titleShadowColorDict) {
        titleShadowColorDict = [[NSMutableDictionary alloc] init];
    }
    [titleShadowColorDict setObject:color forKey:@(state).stringValue];
    [self.qy_nightModeDictionary setObject:titleShadowColorDict forKey:saveKey];
    
    if (mode == self.qy_nightNode) {
        [self setTitleShadowColor:color forState:state];
    }
}

- (void)qy_setImage:(UIImage *)image
           forState:(UIControlState)state
      withNightMode:(QYNightMode)mode {
    
    NSString *saveKey = [self qy_saveKeyWithSEL:@selector(setImage:forState:) nightMode:mode];
    NSMutableDictionary *imageDict = [self.qy_nightModeDictionary objectForKey:saveKey];
    if (!imageDict) {
        imageDict = [[NSMutableDictionary alloc] init];
    }
    [imageDict setObject:image forKey:@(state).stringValue];
    [self.qy_nightModeDictionary setObject:imageDict forKey:saveKey];
    
    if (mode == self.qy_nightNode) {
        [self setImage:image forState:state];
    }
}

- (void)qy_setBackgroundImage:(UIImage *)image
                     forState:(UIControlState)state
                withNightMode:(QYNightMode)mode {
    
    NSString *saveKey = [self qy_saveKeyWithSEL:@selector(setBackgroundImage:forState:) nightMode:mode];
    NSMutableDictionary *imageDict = [self.qy_nightModeDictionary objectForKey:saveKey];
    if (!imageDict) {
        imageDict = [[NSMutableDictionary alloc] init];
    }
    [imageDict setObject:image forKey:@(state).stringValue];
    [self.qy_nightModeDictionary setObject:imageDict forKey:saveKey];
    
    if (mode == self.qy_nightNode) {
        [self setBackgroundImage:image forState:state];
    }
}

@end
