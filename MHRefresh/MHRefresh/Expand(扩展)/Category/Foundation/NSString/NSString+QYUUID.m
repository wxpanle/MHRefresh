//
//  NSString+QYUUID.m
//  MHRefresh
//
//  Created by developer on 2017/9/19.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSString+QYUUID.h"

@implementation NSString (QYUUID)

+ (NSString *)UUID {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0) {
        return [[NSUUID UUID] UUIDString];
    }
    
    NSString *result = nil;
    
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result = [NSString stringWithFormat:@"%@", uuidStr];
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

+ (NSString *)UUIDTimestamp {
    return [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970] * 1000] stringValue];
}

@end
