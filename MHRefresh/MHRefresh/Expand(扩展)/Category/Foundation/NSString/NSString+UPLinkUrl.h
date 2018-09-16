//
//  NSString+UPLinkUrl.h
//  Up
//
//  Created by panle on 2018/4/18.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UPLinkUrl)

/**
 判断是不是链接

 @return BOOL
 */
- (BOOL)isLinkUrl;

/**
 *  判断一个字符串是不是链接
 */
+ (BOOL)isLinkUrl:(NSString *)string;

/**
 *  得到一个字符串中的第一条是链接的字符串  如果无  返回nil
 */
+ (NSString *)getFirstLinkUrlOnString:(NSString *)string;

/**
 *  得到一个字符串中的最后一条是链接的字符串  如果无  返回nil
 */
+ (NSString *)getLastLinkUrlOnString:(NSString *)string;

/**
 *  清除一条链接的前缀
 */
+ (NSString *)clearLinkUrlPrefixWithString:(NSString *)string;

- (BOOL)isHasHttpPrefix;

@end
