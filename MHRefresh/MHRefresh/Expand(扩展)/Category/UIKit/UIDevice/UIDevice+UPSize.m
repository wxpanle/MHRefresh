//
//  UIDevice+UPSize.m
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UIDevice+UPSize.h"

static const CGFloat HeightOf3_5InchScreen = 480;
static const CGFloat HeightOf4_0InchScreen = 568;
static const CGFloat HeightOf4_7InchScreen = 667;
static const CGFloat HeightOf5_5InchScreen = 736;
static const CGFloat HeightOf5_8InchScreen = 812;

@implementation UIDevice (UPSize)

+ (PhoneSize)currentPhoneSize {
    
    static PhoneSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (SCREEN_W == HeightOf3_5InchScreen) {
            size = PhoneSize3_5;
        } else if (SCREEN_W == HeightOf4_0InchScreen) {
            size = PhoneSize4_0;
        } else if (SCREEN_W == HeightOf4_7InchScreen) {
            size = PhoneSize4_7;
        } else if (SCREEN_W == HeightOf5_5InchScreen) {
            size = PhoneSize5_5;
        } else if (SCREEN_W == HeightOf5_8InchScreen) {
            size = PhoneSize5_8;
        } else {
            size = PhoneSize4_0;
        }
        
    });
    return size;
}

@end
