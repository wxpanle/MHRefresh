//
//  NSString+Path.m
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSString+Path.h"

@implementation NSString (Path)

- (NSString *)imagePath {
    return [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"image"] stringByAppendingPathComponent:self];
}

@end
