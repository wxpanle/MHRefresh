//
//  NSString+UPHTML.h
//  Up
//
//  Created by panle on 2018/4/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UPHTML)

/**
 获取html中 来自七牛的图片 去除七牛域名之后
 
 @return 图片数组
 */
- (NSArray *)getImageNameArray;

/**
 判断一个字符串是不是html字符串 根据prefix来判断 @"<!DOCTYPE html>"
 
 @return BOOL
 */
- (BOOL)isHTMLString;

- (BOOL)isHTMLStringOfDiyCard;

- (NSString *)addHtmlDOCTYPE;

- (NSString *)clearHtmlTag;

/**
 获取卡片组合 font
 
 @param string 卡片文字
 @return       font
 */
+ (UIFont *)getCombinationFont:(NSString *)string;

+ (NSString *)getCombinationHtmlAudio;

+ (NSString *)getCombinationHtmlText:(NSString *)text;

+ (NSString *)getCombinationHtmlImage:(NSString *)image;

+ (NSString *)getCombinationHtmlImage:(NSString *)image andText:(NSString *)text;

@end
