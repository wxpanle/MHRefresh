//
//  WKWebView+QYNightMode.h
//  MHRefresh
//
//  Created by panle on 2018/7/25.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "NSObject+QYNightMode.h"

@interface WKWebView (QYNightMode)

/**
 改变背景色
 
 @param hexString hexString @"f2f2f2"
 @param mode mode
 */
- (void)qy_setBackgroundHexColorString:(NSString *)hexString withNightMode:(QYNightMode)mode;

- (void)qy_setTextColorHexColorString:(NSString *)hexString withNightMode:(QYNightMode)mode;

@end
