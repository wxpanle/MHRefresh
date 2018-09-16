//
//  NSCharacterSet+UPHTML.m
//  Up
//
//  Created by panle on 2018/4/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "NSCharacterSet+UPHTML.h"

@implementation NSCharacterSet (UPHTML)

+ (NSCharacterSet *)quoteCharacterSet {
    static dispatch_once_t predicate;
    static NSCharacterSet *quoteCharacterSet = nil;
    dispatch_once(&predicate, ^{
        quoteCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"'\""];
    });
    return quoteCharacterSet;
}

@end
