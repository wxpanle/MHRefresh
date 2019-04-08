//
//  MNetworkAgent.m
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkAgent.h"
#import "MNetworkConfig.h"
#import <pthread/pthread.h>
#import "MNetRequestHeader.h"
#import "MNetworkHelper.h"
#import "MNetworkRequestOperation.h"
#import "MNetworkImageCache.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

#if __has_include(<SDWebImage/SDWebImageDownloader.h>)
#import <SDWebImage/SDWebImageDownloader.h>
#else
#import "SDWebImageDownloader.h"
#endif

#if __has_include(<SDWebImage/SDImageCacheConfig.h>)
#import <SDWebImage/SDImageCacheConfig.h>
#else
#import "SDImageCacheConfig.h"
#endif

static inline dispatch_queue_t kGlobalQueueWithNetworkRequestPriority(MNetworkRequestPriority priority) {
    
    switch (priority) {
        case MNetworkRequestPriorityLow:
            return dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_LOW);
            break;
            
        case MNetworkRequestPriorityHight:
            return dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_HIGH);
            break;
            
        case MNetworkRequestPriorityDefault:
            return dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT);
            break;
            
        default:
            
            break;
    }
    
    return dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT);
}

static BOOL kImageIsNeedCacheToMemory(MNetworkRequestPriority priority) {
    
    switch (priority) {
        case MNetworkRequestPriorityLow:
            return NO;
            break;
            
        case MNetworkRequestPriorityHight:
            return YES;
            break;
            
        case MNetworkRequestPriorityDefault:
            return YES;
            break;
            
        default:
            return YES;
            break;
    }

}

@interface MNetworkAgent()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) MNetworkConfig *netWorkConfig;
/** 下载请求记录 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableArray *> *downloadRequestRecord;

@property (nonatomic, strong) NSMutableDictionary <NSNumber *, MNetworkBaseRequest *> *requestRecord;

@property (nonatomic, strong) NSMutableSet *allRequestRecord;

/** 下载控制队列 默认后台 */
@property (nonatomic, strong) NSOperationQueue *requestQueue;
/** 下载完成返回队列 */
@property (nonatomic, strong) dispatch_queue_t completionQueue;

@property (nonatomic, assign) pthread_mutex_t lock;

/** 状态码 */
@property (nonatomic, strong) NSIndexSet *allStatusCodes;

@property (nonatomic, strong) MNetworkImageCache *imageCache;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;


@end


@implementation MNetworkAgent

+ (instancetype)sharedAgent {
    static MNetworkAgent *sharedNetworkAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetworkAgent = [[self alloc] init];
    });
    return sharedNetworkAgent;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _netWorkConfig = [MNetworkConfig sharedConfig];
        
        //配置AF
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_netWorkConfig.sessionConfiguration];
        _completionQueue = dispatch_queue_create("com.qydm.network.completion", DISPATCH_QUEUE_CONCURRENT);
        _manager.completionQueue = _completionQueue;
        
        AFCompoundResponseSerializer *serializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFJSONResponseSerializer serializer], [AFImageResponseSerializer serializer]]];
        _manager.responseSerializer = serializer;
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"video/mp4", @"audio/mp3", nil];
        AFJSONRequestSerializer *requestSerialzer = [AFJSONRequestSerializer serializer];
        
        _manager.requestSerializer = requestSerialzer;
        _manager.securityPolicy = _netWorkConfig.securityPolicy;
        
        _requestQueue = [[NSOperationQueue alloc] init];
        _requestQueue.maxConcurrentOperationCount = 3;
        _requestQueue.name = @"com.qydm.network.request";
        
        _downloadRequestRecord = [NSMutableDictionary dictionary];
        _requestRecord = [NSMutableDictionary dictionary];
        
        _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        
        _imageCache = [MNetworkImageCache sharedImageCacheWithSubPath:nil];
        
        //设置图片下载的最大数目
        [SDWebImageDownloader sharedDownloader].maxConcurrentDownloads = 4;
        
#ifdef DEBUG
        int flag = pthread_mutex_init(&_lock, NULL);
        NSAssert(flag != 0, @"init lock error");
#else
        pthread_mutex_init(&_lock, NULL);
#endif
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
    }
    return self;
}

#pragma mark - public

- (void)addRequest:(MNetworkBaseRequest *)request {
    
#if DEBUG
    NSParameterAssert(request != nil);
#else
    if (nil == request) {
        return;
    }
#endif
    
    if ([request isKindOfClass:[MNetworkDownloadRequest class]]) { //下载请求
        [self addDownloadRequest:(MNetworkDownloadRequest *)request];
    } else { //普通请求
        [self addBaseRequest:request];
    }
}

- (void)cancelRequest:(MNetworkBaseRequest *)request {
#if DEBUG
    NSParameterAssert(request != nil);
#else
    if (nil == request) {
        return;
    }
#endif
    
    [request.requestTask cancel];
    [request clearBlock];
    [self removeRequestFromRecord:request];
}

- (void)cancelAllRequests {
    Lock();
    NSArray *array = [self.allRequestRecord allObjects];
    Unlock();
    
    for (MNetworkBaseRequest *baseRequest in array) {
        [baseRequest cancel];
    }
    
    [self.allRequestRecord removeAllObjects];
}

- (void)removeRequest:(MNetworkBaseRequest *)request {
    [request clearBlock];
}

#pragma mark - baseRequest

- (void)addBaseRequest:(MNetworkBaseRequest *)request {
    
    NSURLSessionDataTask *dataTask = [self sessionTaskWithRequest:request];
    
    if (nil == dataTask) {
        return;
    }
    
    request.requestTask = dataTask;
    [self addRequestRecord:request];
    
    MNetworkRequestOperation *operation = [[MNetworkRequestOperation alloc] initWithNetworkBaseRequest:request];
    operation.queuePriority = (NSOperationQueuePriority)request.priority;
    [self.requestQueue addOperation:operation];
}

- (nullable NSURLSessionDataTask *)sessionTaskWithRequest:(MNetworkBaseRequest *)request {
    
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];
    
    __autoreleasing NSError *serializationError = nil;
    NSMutableURLRequest *mutableRequest = [requestSerializer requestWithMethod:[request requestMethodString] URLString:[self buildRequestUrlWithRequest:request] parameters:request.parameter error:&serializationError];
    
    if (serializationError) {
        
        if (!request.requestFailBlock) {
            return nil;
        }
        request.error = serializationError;
        dispatch_async(request.isGoBackOnMainThread == YES ? dispatch_get_main_queue() : self.completionQueue, ^{
            request.requestFailBlock(request);
        });
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_manager dataTaskWithRequest:mutableRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleBaseRequestResult:request resonseObject:responseObject error:error];
    }];

    return dataTask;
}

- (void)handleBaseRequestResult:(MNetworkBaseRequest *)request resonseObject:(id)responseObject error:(NSError *)error {
    
    if ([request statusCodeValidator]) {
        
        [MNetworkHelper analysisResponsedData:responseObject successBlock:^(id data) {
            request.responseObject = data;
            [self baseRequestSuccessCallBack:request];
        } failureBlock:^(id errors, NSInteger errorCode) {
            DLog(@"%@请求失败 错误代码:%ld 详情:%@", request.detailurl.length ? request.detailurl : request.customUrl, errorCode, errors);
            request.dataResponseError = error;
            request.dataResponseErrorCode = errorCode;
            [self baseRequestFailCallBack:request];
        }];
        
    } else {
        request.error = error;
        [self baseRequestFailCallBack:request];
    }
    
    //结束任务  开始下一个任务
    MNetworkRequestOperation *operation = [self operationWithrequest:request];
    [operation networkRequestFinish:request];
}

- (void)baseRequestSuccessCallBack:(MNetworkBaseRequest *)request {
    
    dispatch_block_t block = ^ {
        if (request.requestSuccessBlock) {
            request.requestSuccessBlock(request);
        }
        
        if (request.delegate && [request.delegate respondsToSelector:@selector(mRequestFinishSuccess:)]) {
            [request.delegate mRequestFinishSuccess:request];
        }
        
        [request clearBlock];
        [self removeRequestFromRecord:request];
    };
    
    if (request.isGoBackOnMainThread) {
        dispatch_async_main_safe(block);
    } else {
        block();
    }
}

- (void)baseRequestFailCallBack:(MNetworkBaseRequest *)request {
    
    dispatch_block_t block = ^{
        if (request.requestFailBlock) {
            request.requestFailBlock(request);
        }
        
        if (request.delegate && [request.delegate respondsToSelector:@selector(mRequestFinishFail:)]) {
            [request.delegate mRequestFinishFail:request];
        }
        
        [request clearBlock];
        [self removeRequestFromRecord:request];
    };

    if (request.isGoBackOnMainThread) {
        dispatch_async_main_safe(block);
    } else {
        block();
    }
}

#pragma mark - downloadRequest
- (void)addDownloadRequest:(MNetworkDownloadRequest *)request {
    
    //下载请求
    //不同情况分批处理
    
    NSString *urlStr = [self buildRequestUrlWithRequest:request];
    if (!urlStr.length) {
        [self downloadRequestFailCallBack:request];
        return;
    }
    
    NSString *key = request.storeKey;
    
    __block id image = nil;
    if (request.downloadType == MNetworkDownloadTypeImage) {
        image = [_imageCache imageFromMemoryCacheForKey:key];
        if (image) {
            request.responseObject = image;
            [self downloadRequestSuccessCallBack:request];
            return;
        }
    }
    
    // 2、 判断文件有没有
    NSString *downloadPath = [self syncSearchFileIsExistWithPath:request.storagePath];
    
    if (downloadPath.length) {
        switch (request.downloadType) {
            case MNetworkDownloadTypeImage: {
                
                dispatch_async(kGlobalQueueWithNetworkRequestPriority(request.priority), ^{
                    
                    UIImage *image = [self.imageCache imageFromDiskForCustomPath:downloadPath];
                    request.responseObject = image;
                    if (kImageIsNeedCacheToMemory(request.priority)) {
                        [self.imageCache storeImageAsynchronous:image forKey:key saveDisk:NO completeBlock:nil];
                    }
                    [self downloadRequestSuccessCallBack:request];
                });
                break;
            }
                
            case MNetworkDownloadTypeVideo:
            case MNetworkDownloadTypeFile:
            case MNetworkDownloadTypeAudio: {
                //将地址赋给请求
                request.responseObject = downloadPath;
                [self downloadRequestSuccessCallBack:request];
                break;
            }
            default:
                break;
        }
        
        return;
    }
    

    //  3、没有的话开始下载,下载存到缓存、文件中
    //  3、1 防止多次同时下载同一个东西
    Lock();
    if ([self.downloadRequestRecord objectForKey:key]) {
        NSMutableArray *array = [self.downloadRequestRecord objectForKey:key];
        [array addObject:request];
        Unlock();
        return;
    } else {
        NSMutableArray *recordArray = [NSMutableArray array];
        [recordArray addObject:request];
        [self.downloadRequestRecord setObject:recordArray forKey:key];
    }
    Unlock();
    
    switch (request.downloadType) {
        case MNetworkDownloadTypeImage: {
            
            dispatch_block_t block = ^ {
                SDWebImageDownloaderOptions downloadOptions = 0;
                
                switch (request.priority) {
                    case MNetworkRequestPriorityLow:
                        downloadOptions = SDWebImageDownloaderLowPriority;
                        break;
                        
                    case MNetworkRequestPriorityHight:
                        downloadOptions = SDWebImageDownloaderHighPriority;
                        break;
                        
                    case MNetworkRequestPriorityDefault:
                        break;
                        
                    default:
                        break;
                }
                
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlStr] options:downloadOptions progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        for (MNetworkDownloadRequest *request in [self.downloadRequestRecord objectForKey:key]) {
                            if (request.progressBlock) {
                                request.progressBlock((CGFloat)receivedSize / expectedSize);
                            }
                        }
                    });
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    
                    dispatch_async(self.completionQueue, ^{
                        if (error) {
                            request.responseObject = nil;
                            request.error = error;
                            [self downloadRequestFailCallBack:request];
                        } else {
                            //获取image
                            UIImage *cacheImage = image;
                            
                            if (cacheImage) {
                                request.responseObject = image;
                                //缓存image
                                
                                if (!kImageIsNeedCacheToMemory(request.priority)) {
                                    _imageCache.cacheConfig.shouldCacheImagesInMemory = NO;
                                }
                                [_imageCache storeImageAsynchronous:image imageData:data forKey:key completeBlock:nil];
                                _imageCache.cacheConfig.shouldCacheImagesInMemory = YES;
                                
                                [self downloadRequestSuccessCallBack:request];
                            } else {
                                request.responseObject = nil;
                                request.error = error;
                                [self downloadRequestFailCallBack:request];
                            }
                        }
                    });
                }];
            };
            
            NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:block];
            blockOperation.queuePriority = (NSOperationQueuePriority)request.priority;
            [self.requestQueue addOperation:blockOperation];
            
            break;
        }

        default: {
            
            NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request downloadUrl:urlStr];
            
            if (nil != downloadTask) {
                MNetworkRequestOperation *downloadOperation = [[MNetworkRequestOperation alloc] initWithNetworkBaseRequest:request];
                downloadOperation.queuePriority = (NSOperationQueuePriority)request.priority;
                [self.requestQueue addOperation:downloadOperation];
            }
            
            break;
        }
    }
    
    [self addRequestRecord:request];
}

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(MNetworkDownloadRequest *)request downloadUrl:(NSString *)urlString {
    
    if (request.requestHeader.allKeys.count) {
        for (NSString *key in request.requestHeader.allKeys) {
            [_manager.requestSerializer setValue:[request.requestHeader objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    if (!urlRequest) {
        dispatch_async(request.isGoBackOnMainThread ? dispatch_get_main_queue() : self.completionQueue, ^{
            if (request.requestFailBlock) {
                request.requestFailBlock(request);
            }
        });
        return nil;
    }
    
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:urlRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        [self downloadRequestProgressCallBack:request progress:downloadProgress];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:request.storagePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self handleDownloadRequestWithRequest:request error:error];
    }];
    
    request.requestTask = downloadTask;
    
    return downloadTask;
}

- (void)handleDownloadRequestWithRequest:(MNetworkDownloadRequest *)request error:(NSError *)error {
    
    if (error) {
        
        //移除文件
        switch (request.downloadType) {
                
            case MNetworkDownloadTypeFile:
            case MNetworkDownloadTypeAudio:
            case MNetworkDownloadTypeVideo: {
                
                BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:request.storagePath];
                
                __autoreleasing NSError *removeError = nil;
                
                BOOL removeResult = NO;
                
                if (isExist) {
                    removeResult = [[NSFileManager defaultManager] removeItemAtPath:request.storagePath error:&removeError];
                }
                
                if (removeResult == YES) {
                    DLog(@"下载失败 %@ 文件移除成功 下载失败原因 %@", request.storeKey, error);
                } else {
                    DLog(@"下载失败 %@ 文件移除失败原因 %@", request.storeKey, removeError);
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    request.responseObject = nil;
    
    switch (request.priority) {
        case MNetworkRequestPriorityLow: {
            
            NSArray *array = self.downloadRequestRecord[request.storeKey];
            for (MNetworkDownloadRequest *request in array) {
                [self downloadRequestSuccessCallBack:request];
            }
            [self.downloadRequestRecord removeObjectForKey:request.storeKey];
            break;
        }
            
        case MNetworkRequestPriorityHight:
        case MNetworkRequestPriorityDefault: {
            
            if (error == nil) {//请求成功
                NSArray *array = self.downloadRequestRecord[request.storeKey];
                for (MNetworkDownloadRequest *request in array) {
                    [self downloadRequestSuccessCallBack:request];
                }
            } else {
                NSArray *array = self.downloadRequestRecord[request.storeKey];
                for (MNetworkDownloadRequest *request in array) {
                    request.error = error;
                    [self downloadRequestFailCallBack:request];
                }
            }
            [self.downloadRequestRecord removeObjectForKey:request.storeKey];
            break;
        }
    }
    
    [self removeRequestFromRecord:request];
}

- (void)downloadRequestProgressCallBack:(MNetworkDownloadRequest *)request progress:(NSProgress *)downloadProgress {
    
    dispatch_async_main_safe(^{
        for (MNetworkDownloadRequest *tempRequest in [self.downloadRequestRecord objectForKey:request.storeKey]) {
            if (tempRequest.progressBlock) {
                tempRequest.progressBlock(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            }
        }
    });
}

- (void)downloadRequestSuccessCallBack:(MNetworkDownloadRequest *)request {
    
    dispatch_block_t block = ^ {
        if (request.requestSuccessBlock) {
            request.requestSuccessBlock(request);
        }
        
        if (request.delegate && [request.delegate respondsToSelector:@selector(mRequestFinishSuccess:)]) {
            [request.delegate mRequestFinishSuccess:request];
        }
        
        [request clearBlock];
        [self removeRequestFromRecord:request];
    };
    
    if (request.isGoBackOnMainThread) {
        dispatch_async_main_safe(block);
    } else {
        block();
    }
}

- (void)downloadRequestFailCallBack:(MNetworkDownloadRequest *)request {
    
    dispatch_block_t block = ^{
        if (request.requestFailBlock) {
            request.requestFailBlock(request);
        }
        
        if (request.delegate && [request.delegate respondsToSelector:@selector(mRequestFinishFail:)]) {
            [request.delegate mRequestFinishFail:request];
        }
        
        [request clearBlock];
        [self removeRequestFromRecord:request];
    };
    
    if (request.isGoBackOnMainThread) {
        dispatch_async_main_safe(block);
    } else {
        block();
    }
}

#pragma mark - requestRecord
- (void)addRequestRecord:(MNetworkBaseRequest *)request {
    Lock();
    [self.allRequestRecord addObject:request];
    Unlock();
}

- (void)removeRequestFromRecord:(MNetworkBaseRequest *)request {
    Lock();
    [self.allRequestRecord removeObject:request];
    Unlock();
}

- (void)removeDownloadRequest:(MNetworkDownloadRequest *)downloadRequest {
    Lock();
    [self.downloadRequestRecord removeObjectForKey:downloadRequest.storeKey];
    Unlock();
}

#pragma mark -

- (NSString *)buildRequestUrlWithRequest:(MNetworkBaseRequest *)request {
    
    NSParameterAssert(request != nil);
    
    if ([request isKindOfClass:[MNetworkDownloadRequest class]]) {
        if (request.customUrl) {
            return [self encodingUrlString:request.customUrl];
        } else {
            return  [self encodingUrlString:[NSString stringWithFormat:@"%@/%@", _netWorkConfig.cdnUrl, request.detailurl]];
        }
    } else {
        if (request.customUrl) {
            return [self encodingUrlString:request.customUrl];
        } else {
            return [self encodingUrlString:[NSString stringWithFormat:@"%@/%@", _netWorkConfig.baseUrl, request.detailurl]];
        }
    }
    
    return nil;
}

- (NSString *)encodingUrlString:(NSString *)urlString {
    return [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

#pragma mark - ========== notifiction ==========

- (void)applicationWillTerminate:(NSNotification *)not {
    
    [self suspendAll];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)not {
    
    //暂停正在下载的文件
    
    
}

- (void)applicationWillResignActive:(NSNotification *)not {
    
    //app
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
    if (hasApplication ) {
        __weak __typeof__ (self) wself = self;
        UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
        self.backgroundTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
            __strong __typeof (wself) sself = wself;
            
            if (sself) {
                [sself suspendAll];
                
                [app endBackgroundTask:sself.backgroundTaskIdentifier];
                sself.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
            }
        }];
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)not {
    
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskIdentifier];
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
    
    if (self.requestQueue.isSuspended) {
        [self.requestQueue setSuspended:NO];
    }
}


#pragma mark - ===== private =====

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(MNetworkBaseRequest *)request {
    
    //can add other query
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    requestSerializer.timeoutInterval = request.timeoutInterval;
    
    if (!request.requestHeader.allKeys.count) {
        return requestSerializer;
    }
    
    for (NSString *key in request.requestHeader.allKeys) {
        [requestSerializer setValue:[request.requestHeader objectForKey:key] forHTTPHeaderField:key];
    }
    
    return requestSerializer;
}

- (MNetworkRequestOperation *)operationWithrequest:(MNetworkBaseRequest *)request {
    MNetworkRequestOperation *returnOperation = nil;
    
    NSUInteger taskIdentifier = request.requestTask.taskIdentifier;
    for (MNetworkRequestOperation *operation in self.requestQueue.operations) {

        if ([operation isOperationOfDataTaskIdentifier:taskIdentifier]) {
            returnOperation = operation;
            break;
        }
    }
    return returnOperation;
}


/**
 查询file是否存在  如果存在  返回路径  否则返回nil

 @param path 路径
 @return     路径
 */
- (NSString *)syncSearchFileIsExistWithPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        return path;
    }
    
    if ([fileManager fileExistsAtPath:path.stringByDeletingPathExtension]) {
        return path.stringByDeletingPathExtension;
    }
    
    return nil;
}

- (void)suspendAll {

    if (self.requestQueue.operationCount) {
        self.requestQueue.suspended = YES;
    }
}


#pragma mark - ===== getter =====

- (NSMutableSet *)allRequestRecord {
    if (nil == _allRequestRecord) {
        _allRequestRecord = [[NSMutableSet alloc] init];
    }
    return _allRequestRecord;
}

@end
