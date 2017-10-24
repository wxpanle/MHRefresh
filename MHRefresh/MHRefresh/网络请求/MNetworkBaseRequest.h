//
//  MNetworkBaseRequest.h
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MNetworkRequestMethod) {
    MNetworkRequestMethodGET = 0,
    MNetworkRequestMethodPOST,
    MNetworkRequestMethodHEAD,
    MNetworkRequestMethodPUT,
    MNetworkRequestMethodDELETE,
    MNetworkRequestMethodPATCH
};

typedef NS_ENUM(NSInteger, MNetworkRequestType) {
    MNetworkRequestTypeNormal = 0,
    MNetworkRequestTypeDownload,
    MNetworkRequestTypeUpload
};

typedef NS_ENUM(NSInteger, MNetworkRequestPriority) {
    MNetworkRequestPriorityLow = -4L,
    MNetworkRequestPriorityDefault = 0,
    MNetworkRequestPriorityHight = 4
};

@class MNetworkBaseRequest;

/*  success block **/
typedef void (^MNetworkRequestSuccessBlock)(MNetworkBaseRequest * _Nullable request);
/*  fail block **/
typedef void (^MNetworkRequestFailureBlock)(MNetworkBaseRequest * _Nullable request);

@protocol MNetworkBaseRequestDelegate <NSObject>

- (void)mRequestFinishSuccess:(nullable MNetworkBaseRequest *)request;

- (void)mRequestFinishFail:(nullable MNetworkBaseRequest *)request;

@end

@interface MNetworkBaseRequest : NSObject

@property (nonatomic, weak, nullable) id <MNetworkBaseRequestDelegate> delegate;

@property (nonatomic, copy, nullable) NSString *url;

/** baseUrl/cdnUrl + detailUrl */
@property (nonatomic, copy, readonly, nullable) NSString *detailurl;

/** customUrl completeUrl */
@property (nonatomic, copy, readonly, nullable) NSString *customUrl;

/** header */
@property (nonatomic, strong, readonly, nullable) NSDictionary *requestHeader;

/** parameter */
@property (nonatomic, strong, readonly, nullable) NSDictionary *parameter;

/** timeout */
@property (nonatomic, assign) NSInteger timeoutInterval;

/** method MNetworkRequestMethod */
@property (nonatomic, assign, readonly) MNetworkRequestMethod requestMethod;

/** type MNetworkRequestType */
@property (nonatomic, assign, readonly) MNetworkRequestType requestType;

/** priority MNetworkRequestPriority */
@property (nonatomic, assign, readonly) MNetworkRequestPriority priority;

/** urlSessionTask */
@property (nonatomic, strong, nullable) NSURLSessionTask *requestTask;

/** response */
@property (nonatomic, strong, readonly, nullable) NSHTTPURLResponse *requestResponse;

/** response status code */
@property (nonatomic, assign, readonly) NSInteger responseStatusCode;

/** dataResponseErrorCode */
@property (nonatomic, assign) NSInteger dataResponseErrorCode;

/** response header */
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;

/** response data */
@property (nonatomic, strong, nullable) NSData *responseData;

/** serialized response object */
@property (nonatomic, strong, nullable) id responseObject;

/** serialization or net error */
@property (nonatomic, strong, nullable) NSError *error;

/** dataResponseError */
@property (nonatomic, strong, nullable) id dataResponseError;

/** isCancel request */
@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancel;

/** isExecuting request */
@property (nonatomic, assign, readonly, getter=isExecuting) BOOL executing;

/** isSuspend request */
@property (nonatomic, assign, readonly, getter=isSuspend) BOOL suspend;

/** request complete go back on main thread, default == YES, be careful use */
@property (nonatomic, assign) BOOL isGoBackOnMainThread;

/** successBlock */
@property (nonatomic, copy, nullable) MNetworkRequestSuccessBlock requestSuccessBlock;

/** failBlock */
@property (nonatomic, copy, nullable) MNetworkRequestFailureBlock requestFailBlock;


///------------------------------------------
/// @name detailUrl no mention parameter use default
///------------------------------------------
+ (instancetype)requestWithDeatilUrl:(NSString *)detailUrl;

+ (instancetype)requestWithDeatilUrl:(NSString *)detailUrl
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype)requestWithDeatilUrl:(NSString *)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type;

+ (instancetype)requestWithDeatilUrl:(NSString *)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype)requestWithDeatilUrl:(NSString *)detailUrl
                                requestHeader:(nullable NSDictionary *)headerDictionary
                             requestParameter:(nullable NSDictionary *)parameterDictionary;

+ (instancetype)requestWithDeatilUrl:(NSString *)detailUrl
                                requestHeader:(nullable NSDictionary *)headerDictionary
                             requestParameter:(nullable NSDictionary *)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(nullable NSDictionary *)headerDictionary
                             requestParameter:(nullable NSDictionary *)parameterDictionary;

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString *)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(nullable NSDictionary *)headerDictionary
                             requestParameter:(nullable NSDictionary *)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority;

///-------------------------------
/// @name customUrl
///-------------------------------
+ (instancetype _Nonnull)requestWithCustomUrl:(NSString *)customUrl;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString *)customUrl
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString *)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString *)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString *)customUrl
                                requestHeader:(nullable NSDictionary *)headerDictionary
                             requestParameter:(nullable NSDictionary *)parameterDictionary;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString *)customUrl
                                requestHeader:(nullable NSDictionary *)headerDictionary
                             requestParameter:(nullable NSDictionary *)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString *)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(nullable NSDictionary *)headerDictionary
                             requestParameter:(nullable NSDictionary *)parameterDictionary;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString *)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(nullable NSDictionary *)headerDictionary
                             requestParameter:(nullable NSDictionary *)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority;

///-------------------------------
/// @name operation
///-------------------------------
- (void)start;

- (void)suspend;

- (void)resume;

- (void)cancel;

- (void)startWithCompleteBlockSuccess:(nullable MNetworkRequestSuccessBlock)successBlock
                              failure:(nullable MNetworkRequestFailureBlock)failureBlock
                          immediately:(BOOL)immdiately;

- (void)clearBlock;

- (NSString *)requestMethodString;

- (BOOL)statusCodeValidator;

@end

NS_ASSUME_NONNULL_END
