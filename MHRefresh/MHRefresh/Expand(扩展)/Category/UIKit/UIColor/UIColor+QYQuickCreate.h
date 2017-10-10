//
//  UIColor+QYQuickCreate.h
//  MHRefresh
//
//  Created by developer on 2017/9/21.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QYQuickCreate)

+ (UIColor *)colorWithHex:(UInt32)hex;

+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithIntegerRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

+ (UIColor *)gradientFromColor:(UIColor *)fromColor toColor:(UIColor*)toColor height:(CGFloat)height;

+ (UIColor *)randomColor;

- (NSString *)HEXString;

- (NSString *)canvasColorString;

- (NSString *)webColorString;

- (UIColor *)invertedColor;

- (UIColor *)colorForTranslucency;

- (UIColor *)lightenColor:(CGFloat)lighten;

- (UIColor *)darkenColor:(CGFloat)darken;

@end
