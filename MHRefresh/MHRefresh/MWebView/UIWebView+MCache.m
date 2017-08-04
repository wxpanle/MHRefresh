//
//  UIWebView+MCache.m
//  Memory
//
//  Created by developer on 17/4/13.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "UIWebView+MCache.h"


@implementation UIWebView (MCache)

+ (void)didReceiveMemoryWarning {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

+ (void)setCustomCache {
    int cacheSizeMemory = 1 * 1024 * 1024;
    int cacheSizeDisk = 5 * 1024 * 1024;
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
}

+ (void)setUserDefaults {
    /**
     *  博客 https://my.oschina.net/are1OfBlog/blog/387695?p={{totalPage}}
     */
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
