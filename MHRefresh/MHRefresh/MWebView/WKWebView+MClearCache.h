//
//  WKWebView+MClearCache.h
//  Memory
//
//  Created by developer on 17/4/13.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WKWebView (MClearCache)

/**
 *  清除磁盘里的文件
 */
+ (void)clearDiskCache;

@end
