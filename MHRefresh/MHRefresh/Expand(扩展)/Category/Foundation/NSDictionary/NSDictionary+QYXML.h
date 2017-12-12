//
//  NSDictionary+QYXML.h
//  MHRefresh
//
//  Created by developer on 2017/12/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QYXML)

/**
 将NSDictionary转换成XML 字符串
 
 @return string
 */
- (NSString *)XMLString;

@end
