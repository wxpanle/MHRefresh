//
//  NSBundle+QYSearchExtension.m
//  MHRefresh
//
//  Created by panle on 2018/7/18.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "NSBundle+QYSearchExtension.h"
#import "QYSearchController.h"

@implementation NSBundle (QYSearchExtension)

+ (NSBundle *)qy_searchBundle {
    
    static NSBundle *searchBundle = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        searchBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"QYSearch" ofType:@"bundle"]];
        
        if (nil == searchBundle) {
            searchBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QYSearchController class]] pathForResource:@"QYSearch" ofType:@"bundle"]];
        }
    });
    
    return searchBundle;
}

+ (NSString *)qy_localizedStringForKey:(NSString *)key {
    return [self p_localizedStringForKey:key value:nil];
}

+ (NSString *)p_localizedStringForKey:(NSString *)key value:(NSString *)value {
    
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *language = [NSLocale preferredLanguages].firstObject;
        
        if ([language hasPrefix:@"en"]) {
            language = @"en";
        } else {
            language = @"zh-Hans";
        }
        
        // Find resources from `PYSearch.bundle`
        bundle = [NSBundle bundleWithPath:[[NSBundle qy_searchBundle] pathForResource:language ofType:@"lproj"]];
    });
    
    value = [bundle localizedStringForKey:key value:value table:nil];
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:nil];
}
@end
