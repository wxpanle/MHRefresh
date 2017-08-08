//
//  MNetworkBaseRequest.m
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkBaseRequest.h"

@interface MNetworkBaseRequest()

@property (nonatomic, copy, readwrite) NSString *detailurl;

@property (nonatomic, copy, readwrite) NSString *customUrl;

@property (nonatomic, strong, readwrite) NSDictionary *requestHeader;

@property (nonatomic, strong, readwrite) NSDictionary *parameter;

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;

@property (nonatomic, strong, readwrite) NSData *responseData;

@property (nonatomic, assign, readwrite) MNetworkRequestMethod requestMethod;

@property (nonatomic, assign, readwrite) MNetworkRequestType requestType;

@property (nonatomic, assign, readwrite) MNetworkRequestPriority priority;

@property (nonatomic, strong, readwrite) id responseObject;

@property (nonatomic, strong, readwrite) NSError *error;

@end

@implementation MNetworkBaseRequest

#pragma mark - init detailUrl
+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl {
    return [self requestWithDeatilUrl:detailUrl requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithCustomUrl:detailUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeNormal requestPriority:priority];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type {
    return [self requestWithCustomUrl:detailUrl requestMethod:method requestType:type requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithDeatilUrl:detailUrl requestMethod:method requestType:type requestHeader:nil requestParameter:nil requestPriority:priority];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary {
    return [self requestWithDeatilUrl:detailUrl requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithDeatilUrl:detailUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeNormal requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:priority];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary {
    return [self requestWithDeatilUrl:detailUrl requestMethod:method requestType:type requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority {
    
    MNetworkBaseRequest *request = [[self alloc] init];
    request.detailurl = detailUrl;
    request.requestMethod = method;
    request.requestType = type;
    request.requestHeader = headerDictionary;
    request.parameter = parameterDictionary;
    request.priority = priority;
    return request;
}

#pragma mark - init customUrl
+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl {
    return [self requestWithDeatilUrl:customUrl requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithCustomUrl:customUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeNormal requestPriority:priority];
}

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type {
    return [self requestWithCustomUrl:customUrl requestMethod:method requestType:type requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithCustomUrl:customUrl requestMethod:method requestType:type requestHeader:nil requestParameter:nil requestPriority:priority];
}

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary {
    return [self requestWithCustomUrl:customUrl requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithCustomUrl:customUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeNormal requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:priority];
}

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary {
    return [self requestWithCustomUrl:customUrl requestMethod:method requestType:type requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority {
    
    MNetworkBaseRequest *request = [[self alloc] init];
    request.customUrl = customUrl;
    request.requestMethod = method;
    request.requestType = type;
    request.requestHeader = headerDictionary;
    request.parameter = parameterDictionary;
    request.priority = priority;
    return request;
}

#pragma mark - operation
- (void)start {
    
}

- (void)suspend {
    [_requestTask suspend];
}

- (void)resume {
    [_requestTask resume];
}

- (void)cancel {
    [_requestTask cancel];
    [self clearBlock];
}

- (void)startWithCompleteBlockSuccess:(MNetworkRequestSuccessBlock _Nullable)successBlock
                              failure:(MNetworkRequestFailureBlock _Nullable)failureBlock
                          immediately:(BOOL)immdiately {
    self.requestSuccessBlock = successBlock;
    self.requestFailBlock = failureBlock;
    
    if (immdiately) {
        [self start];
    }
}

- (void)clearBlock {
    self.requestSuccessBlock = nil;
    self.requestFailBlock = nil;
}

#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)requestResponse {
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.requestResponse.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.requestResponse.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (BOOL)isCancelled {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}

- (BOOL)isSuspend {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateSuspended;
}


@end
