//
//  WKWebView+MClearCache.m
//  Memory
//
//  Created by developer on 17/4/13.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "WKWebView+MClearCache.h"
#import "MWebViewheader.h"

@implementation WKWebView (MClearCache)

/**
 *  清除磁盘里的文件
 */
+ (void)clearDiskCache {
    [self removeDiskCache];
}

+ (void)removeDiskCache {
    
    if(IS_IOS_NINE_POINT_ZERO_LATER) {
        //NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        //WKWebsiteDataTypeDiskCache,
                                                        //WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        //WKWebsiteDataTypeMemoryCache,
                                                        //WKWebsiteDataTypeLocalStorage,
                                                        //WKWebsiteDataTypeCookies,
                                                        //WKWebsiteDataTypeSessionStorage,
                                                        //WKWebsiteDataTypeIndexedDBDatabases,
                                                        //WKWebsiteDataTypeWebSQLDatabases
                                                        //]];
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                   modifiedSince:dateFrom completionHandler:^{
                                                       // code
                                                   }];
    } else {
        
        //9.0之前的缓存存放地方
        NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                                   NSUserDomainMask, YES).firstObject;
        NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString
                                          stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];

        __autoreleasing NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        if (error) {
            NSLog(@"清除WkWebView disk 失败 原因 - %@", error);
        }
    }

}


@end
