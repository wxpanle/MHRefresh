//
//  NSDictionary+QYJSONString.m
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSDictionary+QYJSONString.h"

@implementation NSDictionary (QYJSONString)

- (NSString *)JSONString {
    
    __autoreleasing NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    
    if (nil == jsonData) {
#ifdef DEBUG
        DLog(@"fail to get JSON from dictionary: %@, error: %@", self, error);
#endif
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
