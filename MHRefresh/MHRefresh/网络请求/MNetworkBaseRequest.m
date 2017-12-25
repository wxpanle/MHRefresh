//
//  MNetworkBaseRequest.m
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkBaseRequest.h"
#import "MNetworkAgent.h"

@interface MNetworkBaseRequest()

@property (nonatomic, copy, readwrite) NSString *detailurl;

@property (nonatomic, copy, readwrite) NSString *customUrl;

@property (nonatomic, strong, readwrite) NSDictionary *requestHeader;

@property (nonatomic, strong, readwrite) NSDictionary *parameter;

@property (nonatomic, assign, readwrite) MNetworkRequestMethod requestMethod;

@property (nonatomic, assign, readwrite) MNetworkRequestType requestType;

@property (nonatomic, assign, readwrite) MNetworkRequestPriority priority;

@end

@implementation MNetworkBaseRequest

#pragma mark - init detailUrl
+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl {
    return [self requestWithDeatilUrl:detailUrl requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithCustomUrl:detailUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeNormal requestPriority:priority];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type {
    return [self requestWithCustomUrl:detailUrl requestMethod:method requestType:type requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithDeatilUrl:detailUrl requestMethod:method requestType:type requestHeader:nil requestParameter:nil requestPriority:priority];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl
                                requestHeader:(NSDictionary *)headerDictionary
                             requestParameter:(NSDictionary *)parameterDictionary {
    return [self requestWithDeatilUrl:detailUrl requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl
                                requestHeader:(NSDictionary *)headerDictionary
                             requestParameter:(NSDictionary *)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithDeatilUrl:detailUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeNormal requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:priority];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary *)headerDictionary
                             requestParameter:(NSDictionary *)parameterDictionary {
    return [self requestWithDeatilUrl:detailUrl requestMethod:method requestType:type requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary *)headerDictionary
                             requestParameter:(NSDictionary *)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority {
    
    MNetworkBaseRequest *request = [[self alloc] init];
    request.detailurl = detailUrl;
    request.requestMethod = method;
    request.requestType = type;
    request.requestHeader = headerDictionary;
    request.parameter = parameterDictionary;
    request.priority = priority;
    request.isGoBackOnMainThread = YES;
    return request;
}

#pragma mark - init customUrl
+ (instancetype)requestWithCustomUrl:(NSString *)customUrl {
    return [self requestWithDeatilUrl:customUrl requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype)requestWithCustomUrl:(NSString *)customUrl
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithCustomUrl:customUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeNormal requestPriority:priority];
}

+ (instancetype)requestWithCustomUrl:(NSString *)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type {
    return [self requestWithCustomUrl:customUrl requestMethod:method requestType:type requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype)requestWithCustomUrl:(NSString *)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithCustomUrl:customUrl requestMethod:method requestType:type requestHeader:nil requestParameter:nil requestPriority:priority];
}

+ (instancetype)requestWithCustomUrl:(NSString *)customUrl
                                requestHeader:(NSDictionary *)headerDictionary
                             requestParameter:(NSDictionary *)parameterDictionary {
    return [self requestWithCustomUrl:customUrl requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype)requestWithCustomUrl:(NSString *)customUrl
                                requestHeader:(NSDictionary *)headerDictionary
                             requestParameter:(NSDictionary *)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority {
    return [self requestWithCustomUrl:customUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeNormal requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:priority];
}

+ (instancetype)requestWithCustomUrl:(NSString *)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary *)headerDictionary
                             requestParameter:(NSDictionary *)parameterDictionary {
    return [self requestWithCustomUrl:customUrl requestMethod:method requestType:type requestHeader:headerDictionary requestParameter:parameterDictionary requestPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype)requestWithCustomUrl:(NSString *)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary *)headerDictionary
                             requestParameter:(NSDictionary *)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority {
    
    MNetworkBaseRequest *request = [[self alloc] init];
    request.customUrl = customUrl;
    request.requestMethod = method;
    request.requestType = type;
    request.requestHeader = headerDictionary;
    request.parameter = parameterDictionary;
    request.priority = priority;
    request.isGoBackOnMainThread = YES;
    return request;
}

#pragma mark - operation
- (void)start {
    [[MNetworkAgent sharedAgent] addRequest:self];
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

- (void)startWithCompleteBlockSuccess:(MNetworkRequestSuccessBlock)successBlock
                              failure:(MNetworkRequestFailureBlock)failureBlock
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

- (NSString *)requestMethodString {
    
    NSString *requestMethod = @"GET";
    
    switch (_requestMethod) {
        case MNetworkRequestMethodGET:
        
            break;
            
        case MNetworkRequestMethodPOST:
            requestMethod = @"POST";
            break;
            
        case MNetworkRequestMethodHEAD:
            requestMethod = @"HEAD";
            break;
            
        case MNetworkRequestMethodPUT:
            requestMethod = @"PUT";
            break;
            
        case MNetworkRequestMethodDELETE:
            requestMethod = @"DELETE";
            break;
            
        case MNetworkRequestMethodPATCH:
            requestMethod = @"PATCH";
            break;
            
        default:
            break;
    }
    return requestMethod;
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

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    return (statusCode >= 200 && statusCode <= 299) ? YES : NO;
}

- (NSTimeInterval)timeoutInterval {
    if (_timeoutInterval != 0.0) {
        return _timeoutInterval;
    }
    
    return 60.0;
}

#pragma mark - dealloc
- (void)dealloc {
#ifdef DEBUG
    NSString *url = self.detailurl.length ? self.detailurl : self.customUrl;
    if (self.detailurl.length) {
        DLog(@"%@", [NSString stringWithFormat:@"%@ 请求移除", url]);
    }
#endif
}

@end
