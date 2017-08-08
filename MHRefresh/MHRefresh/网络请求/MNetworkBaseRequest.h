//
//  MNetworkBaseRequest.h
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

- (void)mRequestFinishSuccess:(MNetworkBaseRequest * _Nullable)request;

- (void)mRequestFinishFail:(MNetworkBaseRequest * _Nullable)request;

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
@property (nonatomic, strong, readonly, nullable) NSURLSessionTask *requestTask;

/** response */
@property (nonatomic, strong, readonly, nullable) NSHTTPURLResponse *requestResponse;

/** response status code */
@property (nonatomic, assign, readonly) NSInteger responseStatusCode;

/** response header */
@property (nonatomic, strong, readonly, nullable) NSDictionary *responseHeaders;

/** response data */
@property (nonatomic, strong, readonly, nullable) NSData *responseData;

/** serialized response object */
@property (nonatomic, strong, readonly, nullable) id responseObject;

/** serialization or net error */
@property (nonatomic, strong, readonly, nullable) NSError *error;

/** isCancel request */
@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancel;

/** isExecuting request */
@property (nonatomic, assign, readonly, getter=isExecuting) BOOL executing;

/** isSuspend request */
@property (nonatomic, assign, readonly, getter=isSuspend) BOOL suspend;

/** successBlock */
@property (nonatomic, copy, nullable) MNetworkRequestSuccessBlock requestSuccessBlock;

/** failBlock */
@property (nonatomic, copy, nullable) MNetworkRequestFailureBlock requestFailBlock;


///------------------------------------------
/// @name detailUrl no mention parameter use default
///------------------------------------------
+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl;

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type;

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary;

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary;

+ (instancetype _Nonnull)requestWithDeatilUrl:(NSString * _Nonnull)detailUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority;

///-------------------------------
/// @name customUrl
///-------------------------------
+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary;

+ (instancetype _Nonnull)requestWithCustomUrl:(NSString * _Nonnull)customUrl
                                requestMethod:(MNetworkRequestMethod)method
                                  requestType:(MNetworkRequestType)type
                                requestHeader:(NSDictionary * _Nullable)headerDictionary
                             requestParameter:(NSDictionary * _Nullable)parameterDictionary
                              requestPriority:(MNetworkRequestPriority)priority;

///-------------------------------
/// @name operation
///-------------------------------
- (void)start;

- (void)suspend;

- (void)resume;

- (void)cancel;

- (void)startWithCompleteBlockSuccess:(MNetworkRequestSuccessBlock _Nullable)successBlock
                              failure:(MNetworkRequestFailureBlock _Nullable)failureBlock
                          immediately:(BOOL)immdiately;

- (void)clearBlock;

@end
