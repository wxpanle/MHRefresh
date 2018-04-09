//
//  QYPlayerTest.m
//  MHRefresh
//
//  Created by panle on 2018/3/15.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYPlayerTest.h"

@implementation QYPlayerTest

- (NSURL *)audioFileSourceUrl {
    
    
    NSString *url = @"https://oiijtsooa.qnssl.com/of5864728e74fc0.mp3";
    return [NSURL URLWithString:url];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AAA" ofType:@"mp3"];
    return [NSURL URLWithString:path];
}

@end
