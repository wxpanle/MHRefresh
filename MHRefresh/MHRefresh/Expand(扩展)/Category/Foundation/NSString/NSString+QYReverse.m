//
//  NSString+QYReverse.m
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSString+QYReverse.h"

@implementation NSString (QYReverse)

- (NSString *)reserveString {
    return [[self class] reverseString:self];
}

+ (NSString *)reverseString:(NSString *)string {
    
    NSInteger length = string.length;
    if (!length) {
        return nil;
    }
    unichar *buffer = calloc(length, sizeof(unichar));
    [string getCharacters:buffer range:NSMakeRange(0, length)];
    for (NSInteger i = 0; i < length / 2; i++){
        unichar temp = buffer[i];
        buffer[i] = buffer[length - 1 - i];
        buffer[length - 1 - i] = temp;
    }
    NSString *result = [NSString stringWithCharacters:buffer length:length];
    free(buffer);
    return result;
}

@end
