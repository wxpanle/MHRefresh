//
//  NSBundle+QYSearchExtension.h
//  MHRefresh
//
//  Created by panle on 2018/7/18.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (QYSearchExtension)

/**
 Get the localized string
 
 @param key     key for localized string
 @return a localized string
 */
+ (NSString *)qy_localizedStringForKey:(NSString *)key;

/**
 Get the path of `QYSearch.bundle`.
 
 @return path of the `QYSearch.bundle`
 */
+ (NSBundle *)qy_searchBundle;

@end
