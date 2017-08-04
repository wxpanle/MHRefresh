//
//  MWebViewCache.m
//  Memory
//
//  Created by developer on 17/4/14.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "MWebViewCache.h"
#import "WKWebView+MClearCache.h"
#import "UIWebView+MCache.h"

@interface MWebViewCache() <NSCacheDelegate>

/**
 * key -> NSURLResponse.URL.absoluteString    value -> NSURLResponse
 */
@property (nonatomic, strong) NSCache <NSString *, NSURLResponse *> *webResponseCache;

/**
 * key -> NSURLResponse.URL.absoluteString    value -> NSdata
 */
@property (nonatomic, strong) NSCache <NSString *, NSData *> *webResponseData;

@end

@implementation MWebViewCache

+ (instancetype)sharedMWebViewCache {
    
    static dispatch_once_t onceToken;
    static MWebViewCache *webViewCache = nil;
    dispatch_once(&onceToken, ^{
        webViewCache = [[MWebViewCache alloc] init];
    });
    return webViewCache;
}

#pragma mark - public method
- (void)addCacheURLResponse:(NSURLResponse *)response andResponseData:(NSData *)data{
    if (nil == response || nil == data || nil == response.URL.absoluteString) {
        return;
    }
    [self.webResponseCache setObject:response forKey:response.URL.absoluteString];
    [self.webResponseData setObject:data forKey:response.URL.absoluteString];
}

- (NSURLResponse *)getCacheURLResponseWithURL:(NSURL *)url {
    return [self getCacheURLResponseWithURLString:url.absoluteString];
}

- (NSURLResponse *)getCacheURLResponseWithURLString:(NSString *)urlString {
    if (nil == urlString) {
        return nil;
    }
    return [self.webResponseCache objectForKey:urlString];
}

- (NSArray <NSURLResponse *>*)getCacheURLResponseWithURLArray:(NSArray <NSURL *>*)urlArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSURL *url in urlArray) {
        NSURLResponse *response = [self getCacheURLResponseWithURL:url];
        if (response) {
            [resultArray addObject:response];
        }
    }
    
    if (resultArray.count == 0) {
        return nil;
    }
    return resultArray;
}

- (NSArray <NSURLResponse *>*)getCacheURLResponseWithURLStringArray:(NSArray <NSString *>*)stringArray {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSString *urlString in stringArray) {
        NSURLResponse *response = [self getCacheURLResponseWithURLString:urlString];
        if (response) {
            [resultArray addObject:response];
        }
    }
    
    if (resultArray.count == 0) {
        return nil;
    }
    return resultArray;
}

- (NSData *)getCacheDataWithURLResponse:(NSURLResponse *)response {
    return [self getCacheDataWithURL:response.URL];
}

- (NSData *)getCacheDataWithURL:(NSURL *)url {
    return [self getCacheDataWithUrlString:url.absoluteString];
}

- (NSData *)getCacheDataWithUrlString:(NSString *)urlString {
    if (nil == urlString) {
        return nil;
    }
    NSData *data = [self.webResponseData objectForKey:urlString];
    if (!data) { //data 不存在 移除response cache
        [self removeCacheURLString:urlString];
    }
    NSLog(@"获取缓存成功 %@", urlString);
    return data;
}

- (void)removeCacheDataWithURLResponse:(NSURLResponse *)response {
    [self removeCacheDataWithURL:response.URL];
}

- (void)removeCacheDataWithURL:(NSURL *)url {
    [self removeCacheDataWithURLString:url.absoluteString];
}

- (void)removeCacheDataWithURLString:(NSString *)urlString {
    if (nil == urlString) {
        return;
    }
    
    [self.webResponseData removeObjectForKey:urlString];
}

- (void)removeCacheURLResponse:(NSURLResponse *)response {
    [self removeCacheWithURL:response.URL];
}

- (void)removeCacheWithURL:(NSURL *)url {
    [self removeCacheURLString:url.absoluteString];
}

- (void)removeCacheURLString:(NSString *)string {
    if (nil == string) {
        return;
    }
    [self.webResponseCache removeObjectForKey:string];
}

- (void)removeCacheWithURLArray:(NSArray <NSURL *>*)urlArray {
    for (NSURL *url in urlArray) {
        [self removeCacheWithURL:url];
    }
}

- (void)removeCacheURLStringArray:(NSArray <NSString *>*)stringArray {
    for (NSString *string in stringArray) {
        [self removeCacheURLString:string];
    }
}

#pragma mark - private method
- (instancetype)init {
    if (self = [super init]) {
        [self layoutOfObserve];
    }
    return self;
}

- (NSCache *)webResponseCache {
    if (_webResponseCache == nil) {
        _webResponseCache = [[NSCache alloc] init];
        _webResponseCache.delegate = self;
    }
    return _webResponseCache;
}

- (NSCache *)webResponseData {
    if (_webResponseData == nil) {
        _webResponseData = [[NSCache alloc] init];
    }
    return _webResponseData;
}

- (void)layoutOfObserve {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)clearCache {
    //DLog(@"收到系统内存警告");
    [UIWebView didReceiveMemoryWarning];
    [WKWebView clearDiskCache];
    [self.webResponseCache removeAllObjects];
}

#pragma mark - NSCacheDelegate
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    //DLog(@"正在清理内存");
    if (cache == self.webResponseCache) {
        [self removeCacheDataWithURLResponse:obj];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
