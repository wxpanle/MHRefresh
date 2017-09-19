//
//  NSString+QYMD5.m
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSString+QYMD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (QYMD5)

- (NSString *)getMD5String {
    return [[self class] getMD5String:self];
}

+ (NSString *)getMD5String:(NSString *)string {
    
    const char *md5Str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(md5Str, (CC_LONG)strlen(md5Str), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
