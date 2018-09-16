//
//  NSString+UPLinkUrl.m
//  Up
//
//  Created by panle on 2018/4/18.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "NSString+UPLinkUrl.h"

@implementation NSString (UPLinkUrl)

- (BOOL)isLinkUrl {
    return [[self class] isLinkUrl:self];
}

- (BOOL)isHasHttpPrefix {
    
    NSString *string = [self lowercaseString];
    
    return [string hasPrefix:@"http://"] || [string hasPrefix:@"https://"];
}

+ (BOOL)isLinkUrl:(NSString *)string {
    
    if (string.length == 0) {
        NSAssert(string.length != 0, @"匹配的字符串不能为空");
        return NO;
    }
    
    NSArray *resultArray = [[self getLinkUrlExpression] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return resultArray.count == 0 ? NO : YES;
}

+ (NSString *)getFirstLinkUrlOnString:(NSString *)string{
    if (string.length == 0) {
        NSAssert(string.length != 0, @"匹配的字符串不能为空");
        return nil;
    }
    
    NSArray *resultArray = [[self getLinkUrlExpression] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSString *subStringForMatch = nil;
    
    for (NSTextCheckingResult *result in resultArray) {
        subStringForMatch = [string substringWithRange:result.range];
        break;
    }
    
    return subStringForMatch;
}

+ (NSString *)getLastLinkUrlOnString:(NSString *)string {
    
    if (string.length == 0) {
        NSAssert(string.length != 0, @"匹配的字符串不能为空");
        return string;
    }
    
    NSArray *resultArray = [[self getLinkUrlExpression] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSString *subStringForMatch = nil;
    
    for (NSTextCheckingResult *result in [resultArray reverseObjectEnumerator]) {
        subStringForMatch = [string substringWithRange:result.range];
        break;
    }
    
    return subStringForMatch;
    
}

+ (NSString *)clearLinkUrlPrefixWithString:(NSString *)string {
    
    if (nil == string) {
        NSAssert(string.length != 0, @"匹配的字符串不能为空");
        return string;
    }
    
    NSArray *resultArray = [[self getPrefixUrlExpression] matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (0 == resultArray.count) {
        return string;
    }
    
    NSString *subStringForMatch = nil;
    
    for (NSTextCheckingResult *result in resultArray) {
        if (result.range.location == (NSUInteger)0) {
            subStringForMatch = [string substringFromIndex:result.range.length];
        }
    }
    
    return subStringForMatch;
}


+ (NSRegularExpression *)getPrefixUrlExpression {
    static NSRegularExpression *regularExpression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regularExpression = [[NSRegularExpression alloc] initWithPattern:@"(http[s]{0,1}|ftp)://" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return regularExpression;
}

+ (NSRegularExpression *)getLinkUrlExpression {
    
    static NSRegularExpression *regularExpression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regularExpression = [[NSRegularExpression alloc] initWithPattern:[self getRegularExpressionPattern] options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return regularExpression;
}

+ (NSString *)getRegularExpressionPattern {
    return @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
}

@end
