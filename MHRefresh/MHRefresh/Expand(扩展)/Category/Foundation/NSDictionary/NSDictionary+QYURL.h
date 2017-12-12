//
//  NSDictionary+QYURL.h
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QYURL)

/**
 将url参数转换成NSDictionary

 @param query url
 @return      dictionary
 */
+ (NSDictionary *)dictionaryWithURLQuery:(NSString *)query;

/**
 将NSDictionary转换成url 参数字符串

 @return string
 */
- (NSString *)URLQueryString;

@end
