//
//  WKWebView+MElementFrame.h
//  Memory
//
//  Created by developer on 17/5/8.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "MWebViewheader.h"

@interface WKWebView (MElementFrame)

- (void)elementFrameWithPoint:(CGPoint)point callBlock:(WKWebViewCallBack)block;

@end
