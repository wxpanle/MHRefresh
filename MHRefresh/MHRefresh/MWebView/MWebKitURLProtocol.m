//
//  MWebKitURLProtocol.m
//  Memory
//
//  Created by developer on 17/4/12.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "MWebKitURLProtocol.h"
#import "NSData+ImageContentType.h"
#import <SDWebImage/SDWebImageDownloaderOperation.h>
#import "MWebViewCache.h"
#import "NSURLProtocol+MWebKitSupport.h"
#import "MWebViewheader.h"

static NSString * const PropertyKey = @"PropertyKey";
static NSString * const APIURLONE = @"https://oiijtsooa.qnssl.com/";
static NSString * const APIURLTWO = @"http://7xryms.com1.z0.glb.clouddn.com/";

@interface MWebKitURLProtocol()

@property (nonatomic, strong) SDWebImageDownloaderOperation <SDWebImageOperation>*operation;

@property (nonatomic, strong) NSURLResponse *response;

@property (nonatomic, strong) NSMutableData *cacheData;

@end

@implementation MWebKitURLProtocol

+ (void)registerInterceptSchem {
    
    if (!IS_IOS_NINE_POINT_ZERO_LATER) {
        return;
    }
    
    for (NSString *schem in @[@"http", @"https"]) {
        [NSURLProtocol registerWebKitSupportScheme:schem];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    NSString *string = request.URL.absoluteString;
    
    NSLog(@"拦截图片 %@", string);
    
    if ([string hasPrefix:APIURLONE] || [string hasPrefix:APIURLTWO]) {
        NSString *extension = request.URL.pathExtension;
        
        NSLog(@"已拦截图片 %@ %@", request.URL.pathExtension, request.URL.absoluteString);
        
        BOOL isImage = [@[@"png", @"jpeg", @"gif", @"jpg", @"img", @"img-large", @"jpg-large", @"jpeg-large", @"png-large"] indexOfObjectPassingTest:^BOOL(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            return [extension compare:obj options:NSCaseInsensitiveSearch] == NSOrderedSame;
        }] != NSNotFound;
        
        return [NSURLProtocol propertyForKey:PropertyKey inRequest:request] == nil && isImage;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {

    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //标记，防止递归调用
    [NSURLProtocol setProperty:@YES forKey:PropertyKey inRequest:mutableReqeust];
    
    NSRange range = NSMakeRange(0, 0);
    if ([mutableReqeust.URL.absoluteString hasPrefix:APIURLONE]) {
        range = [mutableReqeust.URL.absoluteString rangeOfString:APIURLONE];
    } else if ([mutableReqeust.URL.absoluteString hasPrefix:APIURLTWO]) {
        range = [mutableReqeust.URL.absoluteString rangeOfString:APIURLTWO];
    }
    
    NSString *downLoadUrl = [mutableReqeust.URL.absoluteString substringFromIndex:range.length];
    
    
    BOOL isNeedDownLoad = NO;
    MWebViewCache *webViewCache = [MWebViewCache sharedMWebViewCache];
    NSURLResponse *response = [webViewCache getCacheURLResponseWithURLString:mutableReqeust.URL.absoluteString];
    if (response) {
        NSData *data = [webViewCache getCacheDataWithURLResponse:response];
        if (data) {
            [self clientResponseFinishWithURLResponse:response andData:data];
        } else {
            isNeedDownLoad = YES;
        }
    } else {
        isNeedDownLoad = YES;
    }
    
    if (isNeedDownLoad == YES && [[NSFileManager defaultManager] fileExistsAtPath:[downLoadUrl imagePath]]) {
        NSData *data = [NSData dataWithContentsOfFile:[downLoadUrl imagePath]];
        
        if (data) {
            isNeedDownLoad = NO;
            NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL MIMEType:[NSData sd_contentTypeForImageData:data] expectedContentLength:data.length textEncodingName:nil];
            [self clientResponseFinishWithURLResponse:response andData:data];
            [self addCacheResponse:response andData:data];  //追加cache
        } else {
            isNeedDownLoad = YES;
        }
    }
    if (isNeedDownLoad) {
        
        WeakSelf
        self.operation = (SDWebImageDownloaderOperation <SDWebImageOperation>*)[[SDWebImageDownloader sharedDownloader] downloadImageWithURL:mutableReqeust.URL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"1 receivedSize %ld expectedSize %ld", (long)receivedSize, (long)expectedSize);
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            NSLog(@"拦截URL请求完成");
            
            if (nil == weakSelf.operation) {
                return;
            }
            
            if (error) {
                [weakSelf sd_downLoadError];
            } else {
            
                [weakSelf addCacheResponse:weakSelf.operation.response andData:data];
                
                //在此处缓存
                BOOL flag = [[NSFileManager defaultManager] createFileAtPath:[downLoadUrl imagePath] contents:data attributes:nil];
                if (flag) {
                    NSLog(@"创建文件成功");
                } else {
                    NSLog(@"创建文件失败");
                }
                
                [weakSelf clientResponseFinishWithURLResponse:weakSelf.operation.response andData:data];
            }
        }];
    }
}

- (void)clientResponseFinishWithURLResponse:(NSURLResponse *)response andData:(NSData *)data {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [self.client URLProtocol:self didLoadData:data];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)sd_downLoadError {

    NSString *string = @"webLinkErrorPlaceholder.png";
    
    NSURLResponse *response = [[MWebViewCache sharedMWebViewCache] getCacheURLResponseWithURLString:string];
    
    BOOL isNeedLoad = NO;
    
    if (response) {
        NSData *data = [[MWebViewCache sharedMWebViewCache] getCacheDataWithURLResponse:response];
        if (data) {
            [self clientResponseFinishWithURLResponse:response andData:data];
        } else {
            isNeedLoad = YES;
        }
    }
    
    if (isNeedLoad) {
        NSString *pathString = [[NSBundle mainBundle] pathForResource:string ofType:nil];
        NSURL *url = [NSURL URLWithString:string];
        NSData *data = [NSData dataWithContentsOfFile:pathString];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:url MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:nil];
        [self clientResponseFinishWithURLResponse:response andData:data];
        [self addCacheResponse:response andData:data];  //追加cache
    }
    
}

- (void)stopLoading {
    [self.operation cancel];
    self.operation = nil;
    self.cacheData = nil;
    self.response = nil;
}


#pragma mark - session delegate 此处由sd_webImage 实现  

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    
    //处理重定向问题
    if (response != nil) {
        NSMutableURLRequest *redirectableRequest = [[NSMutableURLRequest alloc] initWithURL:[request URL]
                                                                              cachePolicy:[request cachePolicy]
                                                                          timeoutInterval:[request timeoutInterval]];
        [redirectableRequest setAllHTTPHeaderFields:[request allHTTPHeaderFields]];
        if ([request HTTPBodyStream]) {
            [redirectableRequest setHTTPBodyStream:[request HTTPBodyStream]];
        } else {
            [redirectableRequest setHTTPBody:[request HTTPBody]];
        }
        [redirectableRequest setHTTPMethod:[request HTTPMethod]];
        
        [self.client URLProtocol:self wasRedirectedToRequest:redirectableRequest redirectResponse:response];
        completionHandler(request);
        
    } else {
        completionHandler(request);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);
    self.response = response;
}

-  (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.cacheData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"error url = %@", task.currentRequest.URL.absoluteString);
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        NSLog(@"ok url = %@",task.currentRequest.URL.absoluteString);
        [self.client URLProtocolDidFinishLoading:self];
    }
}

#pragma mark - MWebViewCache
- (void)addCacheResponse:(NSURLResponse *)response andData:(NSData *)data {
    NSLog(@"addCacheResponseURL = %@", response.URL.absoluteString);
    MWebViewCache *webViewCache = [MWebViewCache sharedMWebViewCache];
    [webViewCache addCacheURLResponse:response andResponseData:data];
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}


@end
