//
//  NSDictionary+QYXML.m
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSDictionary+QYXML.h"

@implementation NSDictionary (QYXML)

- (NSString *)XMLString {
    
    NSString *xmlStr = @"<xml>";
    
    [xmlStr stringByAppendingString:[self XMLStringValue:self]];
    
    xmlStr = [xmlStr stringByAppendingString:@"</xml>"];
    
    return xmlStr;
}

- (NSString *)XMLStringValue:(id)value {
    
    NSString *string = nil;
    
    for (NSString *key in self.allKeys) {
        
        id value = [self objectForKey:key];
        
        if ([value isDictionaryClass]) {
            [string stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>", key, [self XMLStringValue:value], key]];
        } else if ([value isStringClass]) {
            return [string stringByAppendingString:[NSString stringWithFormat:@"<%@>%@</%@>", key, value, key]];
        }
    }
    
    return string;
}


@end
