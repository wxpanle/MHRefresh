//
//  NSURLProtocol+MWebKitSupport.m
//  Memory
//
//  Created by developer on 17/4/12.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "NSURLProtocol+MWebKitSupport.h"
#import <WebKit/WebKit.h>
#import "MWebViewheader.h"

/**
 * The functions below use some undocumented APIs, which may lead to rejection by Apple.  for iOS 8.4 later
 *  before 8.4  UIWebView 
 */

FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    static Class cls;
    if (!cls) {
        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    }
    
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}

@implementation NSURLProtocol (MWebKitSupport)

+ (void)registerWebKitSupportScheme:(NSString *)scheme {
    
    if (!IS_IOS_NINE_POINT_ZERO_LATER) {
        return;
    }
    
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)unregisterWebKitSupportScheme:(NSString *)scheme {
    if (!IS_IOS_NINE_POINT_ZERO_LATER) {
        return;
    }
    Class cls = ContextControllerClass();
    SEL sel = UnregisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

@end
