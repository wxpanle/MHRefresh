//
//  NSDictionary+QYURL.m
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSDictionary+QYURL.h"

@implementation NSDictionary (QYURL)

+ (NSDictionary *)dictionaryWithURLQuery:(NSString *)query {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    for(NSString *parameter in parameters) {
        NSArray *contents = [parameter componentsSeparatedByString:@"="];
        if([contents count] == 2) {
            NSString *key = [contents objectAtIndex:0];
            NSString *value = [contents objectAtIndex:1];
            value = [value stringByRemovingPercentEncoding];
            if (key && value) {
                [dict setObject:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}


- (NSString *)URLQueryString {
    
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in [self allKeys]) {
        if ([string length]) {
            [string appendString:@"&"];
        }
        
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"];
        
        NSString *tempStr = [(NSString *)[self objectForKey:key] stringByAddingPercentEncodingWithAllowedCharacters:set];

        [string appendFormat:@"%@=%@", key, tempStr];
    }
    return string;
}

@end
