//
//  NSString+QYMD5.h
//  MHRefresh
//
//  Created by developer on 2017/9/13.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QYMD5)

- (NSString *)getMD5String;

+ (NSString *)getMD5String:(NSString *)string;

@end
