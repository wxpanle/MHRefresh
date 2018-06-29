//
//  QYLogSorting.m
//  MHRefresh
//
//  Created by panle on 2018/5/10.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYLogSorting.h"

/**
 给一个日志，由List< String >组成，每个元素代表一行日志。每行日志的信息用一个空格分开。最前面的是日志的ID，后面是日志的内容，内容要么是全部由字母和空格组成，要么是全部由数字和空格组成。现在将日志进行排序，要求字母内容按照内容字典序排序放在顶部，数字内容放到底部且按照输入顺序输出。(注意，空格也属于内容，并且当字母内容字典序相等时，按照日志ID字典序排序，保证ID都不重复)
 */

@implementation QYLogSorting

- (void)sorftArray:(NSArray <NSString *>*)array {
    
    
    NSArray *result = [array sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString *  _Nonnull obj2) {
        
        NSRange range1 = [obj1 rangeOfString:@" "];
        NSString *strings1 = [obj1 substringFromIndex:range1.location + range1.length];
        
        NSRange range2 = [obj2 rangeOfString:@" "];
        NSString *strings2 = [obj2 substringFromIndex:range2.location + range2.length];
        
        if ([self isNumber:strings1] && ![self isNumber:strings2]) {
            return NSOrderedDescending;
        }
        
        if (![self isNumber:strings1] && [self isNumber:strings2]) {
            return NSOrderedAscending;
        }
        
        return NSOrderedSame;
    }];
    
    [result class];
    
}

- (BOOL)isNumber:(NSString *)string {
    
    NSUInteger i = 0;
    unichar string1 = [string characterAtIndex:0];
    
    while (string1 == ' ' && i < string.length - 1) {
        string1 = [string characterAtIndex:++i];
    }
    
    if (string1 >= '0' && string1 <= '9') {
        return YES;
    }
    
    return NO;
}

@end
