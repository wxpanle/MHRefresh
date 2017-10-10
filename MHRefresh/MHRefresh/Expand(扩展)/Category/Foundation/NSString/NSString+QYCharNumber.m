//
//  NSString+QYCharNumber.m
//  MHRefresh
//
//  Created by developer on 2017/9/22.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSString+QYCharNumber.h"

@implementation NSString (QYCharNumber)

+ (NSInteger)charNumberString:(NSString *)string {
    
    if (!string.length) {
        return 0;
    }
    
    NSString *tempString = [string copy];
    
    NSInteger strlength = 0;
    char *p = (char *)[tempString cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [tempString lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        } else {
            p++;
        }
    }
    return strlength;
}

- (NSInteger)charNumber {
    
    return [[self class] charNumberString:self];
}

@end
