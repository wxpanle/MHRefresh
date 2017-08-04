//
//  MWebViewheader.h
//  Memory
//
//  Created by developer on 17/4/12.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#ifndef MWebViewheader_h
#define MWebViewheader_h

//#define __IPHONE_8_4      80400
//#define __IPHONE_9_0      90000
//#define __IPHONE_10_0    100000
//#define __IPHONE_8_0      80000
#define MCURRENTSYSTEMVERSION [[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_NINE_POINT_ZERO_LATER ((MCURRENTSYSTEMVERSION >= 9.0) ? YES : NO)
#define IS_IOS_TEN_POINT_ZERO_LATER ((MCURRENTSYSTEMVERSION >= 10.0) ? YES : NO)

typedef void (^WKWebViewCallBack)(CGRect frame);
typedef void (^WKWebViewElementCallBack)(CGFloat value);

#import "UIWebView+MCache.h"
#import "WKWebView+MClearCache.h"
#import "UIWebView+MElementFrame.h"
#import "WKWebView+MElementFrame.h"
#import "NSString+Path.h"
#import "UIView+WebViewExtern.h"

#endif /* MWebViewheader_h */
