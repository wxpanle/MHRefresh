//
//  NSDictionary+QYMerge.m
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSDictionary+QYMerge.h"

@implementation NSDictionary (QYMerge)

+ (NSDictionary *)dictionaryByMerge:(NSDictionary *)dictionary withOtherDictionary:(NSDictionary *)otherDictionary {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    NSMutableDictionary *resultTemp = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    
    [resultTemp addEntriesFromDictionary:otherDictionary];
    [resultTemp enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        if ([dictionary objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * newVal = [[dictionary objectForKey: key] dictionaryByMergeWithOtherDictionary:(NSDictionary *) obj];
                [result setObject: newVal forKey: key];
            } else {
                [result setObject: obj forKey: key];
            }
        } else if([otherDictionary objectForKey:key]) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary * newVal = [[otherDictionary objectForKey: key] dictionaryByMergeWithOtherDictionary: (NSDictionary *)obj];
                [result setObject:newVal forKey:key];
            } else {
                [result setObject:obj forKey:key];
            }
        }
    }];
    
    return (NSDictionary *) [result mutableCopy];
}

- (NSDictionary *)dictionaryByMergeWithOtherDictionary:(NSDictionary *)otherDictionary {
    return [[self class] dictionaryByMerge:self withOtherDictionary:otherDictionary];
}

@end
