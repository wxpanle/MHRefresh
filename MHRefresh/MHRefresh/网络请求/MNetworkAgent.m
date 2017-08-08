//
//  MNetworkAgent.m
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkAgent.h"
#import "MNetworkConfig.h"
#import "AFNetworking.h"
#import <pthread/pthread.h>
#import "MNetRequestHeader.h"

@interface MNetworkAgent()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) MNetworkConfig *netWorkConfig;

@property (nonatomic, strong) NSMutableDictionary *downloadRequestRecord;

@property (nonatomic, strong) NSMutableSet *allRequestRecord;

@property (nonatomic, strong) dispatch_queue_t lowPriortyDownloadQueue;

@property (nonatomic, strong) dispatch_queue_t processingQueue;

@property (nonatomic, assign) pthread_mutex_t lock;

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
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_netWorkConfig.sessionConfiguration];
        _processingQueue = dispatch_queue_create("com.memory.networkagent.processing", DISPATCH_QUEUE_CONCURRENT);
        pthread_mutex_init(&_lock, NULL);
        
        AFCompoundResponseSerializer *serializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[[AFJSONResponseSerializer serializer], [AFImageResponseSerializer serializer]]];
        _manager.responseSerializer = serializer;
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"video/mp4", nil];
        AFJSONRequestSerializer *requestSerialzer = [AFJSONRequestSerializer serializer];
        requestSerialzer.timeoutInterval = 30.0;
        _manager.requestSerializer = requestSerialzer;

        _manager.securityPolicy = _netWorkConfig.securityPolicy;
       
        _manager.completionQueue = _processingQueue;
    }
    return self;
}

#pragma mark - public

- (void)addRequest:(MNetworkBaseRequest *)request {
    
}

- (void)addRrequestRecord:(MNetworkBaseRequest *)request {
    Lock();
    [self.allRequestRecord addObject:request];
    Unlock();
}

- (void)removeRequestFromRecord:(MNetworkBaseRequest *)request {
    Lock();
    [self.allRequestRecord removeObject:request];
    Unlock();
}


- (void)cancelRequest:(MNetworkBaseRequest *)request {
    NSParameterAssert(request != nil);
    
    [request.requestTask cancel];
    [request clearBlock];
    [self removeRequestFromRecord:request];
}

- (void)cancelAllRequests {
//    Lock();
//    NSArray *allKeys = [_requestsRecord allKeys];
//    Unlock();
//    if (allKeys && allKeys.count > 0) {
//        NSArray *copiedKeys = [allKeys copy];
//        for (NSNumber *key in copiedKeys) {
//            Lock();
//            YTKBaseRequest *request = _requestsRecord[key];
//            Unlock();
//            // We are using non-recursive lock.
//            // Do not lock `stop`, otherwise deadlock may occur.
//            [request stop];
//        }
//    }
}

- (void)removeRequest:(MNetworkBaseRequest *)request {
//    [request clearBlock];
    
}

- (NSString *)buildRequestUrlWithRequest:(MNetworkBaseRequest *)request {
    
//    if ([request isKindOfClass:[MNetworkDownloadRequest class]]) { // 下载任务
//        if (request.customUrl) {
//            return request.customUrl;
//        } else {
//            return [NSString stringWithFormat:@"%@/%@", _netWorkConfig.CDNUrl, request.detailurl];
//        }
//    } else { // 正常的任务
//        if (request.customUrl) {
//            return request.customUrl;
//        } else {
//            return [NSString stringWithFormat:@"%@/%@", _netWorkConfig.baseUrl, request.detailurl];
//        }
//    }
    return nil;
}


- (NSMutableSet *)allRequestRecord {
    if (nil == _allRequestRecord) {
        _allRequestRecord = [[NSMutableSet alloc] init];
    }
    return _allRequestRecord;
}

@end
