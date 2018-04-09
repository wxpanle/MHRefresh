//
//  MWebViewCache.h
//  Memory
//
//  Created by developer on 17/4/14.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  该类只负责来自于webView的图片缓存 其余图片缓存则由之前的类负责完成 
 */

@interface MWebViewCache : NSObject

+ (instancetype)sharedMWebViewCache;

- (void)addCacheURLResponse:(NSURLResponse *)response andResponseData:(NSData *)data;

- (NSURLResponse *)getCacheURLResponseWithURL:(NSURL *)url;

- (NSURLResponse *)getCacheURLResponseWithURLString:(NSString *)urlString;

- (NSArray <NSURLResponse *>*)getCacheURLResponseWithURLArray:(NSArray <NSURL *>*)urlArray;

- (NSArray <NSURLResponse *>*)getCacheURLResponseWithURLStringArray:(NSArray <NSString *>*)stringArray;

- (NSData *)getCacheDataWithURLResponse:(NSURLResponse *)response;

- (NSData *)getCacheDataWithUrlString:(NSString *)urlString;

- (void)removeCacheURLResponse:(NSURLResponse *)response;

- (void)removeCacheWithURL:(NSURL *)url;

- (void)removeCacheURLString:(NSString *)string;

- (void)removeCacheWithURLArray:(NSArray <NSURL *>*)urlArray;

- (void)removeCacheURLStringArray:(NSArray <NSString *>*)stringArray;

@end
