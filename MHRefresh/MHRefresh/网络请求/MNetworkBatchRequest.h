//
//  MNetworkBatchRequest.h
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MNetworkBatchRequest, MNetworkBaseRequest;

typedef void (^ MNetworkBatchRequestProgressBlock) (CGFloat progress);
typedef void (^ MNetworkBatchRequestSuccessBlock) (MNetworkBatchRequest *request);
typedef void (^ MNetworkBatchRequestFailBlock) (MNetworkBatchRequest *request);

@protocol MNetworkBatchRequestDelegate  <NSObject>

- (void)mBatchRequestFinish:(MNetworkBatchRequest *)request;

- (void)mBatchRequestFail:(MNetworkBatchRequest *)request;

@end

@interface MNetworkBatchRequest : NSObject

/** request array */
@property (nonatomic, strong, readonly) NSArray <MNetworkBaseRequest *> *requestArray;

@property (nonatomic, copy) MNetworkBatchRequestSuccessBlock success;

@property (nonatomic, copy) MNetworkBatchRequestFailBlock failure;

@property (nonatomic, copy) MNetworkBatchRequestProgressBlock process;

@property (nonatomic, weak) id <MNetworkBatchRequestDelegate> delegate;

/** default no */
@property (nonatomic, assign, getter=isConsiderFailure, readonly) BOOL considerFailure;

@property (nonatomic, strong, readonly, nullable) MNetworkBaseRequest *failedRequest;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

- (nullable instancetype)initWithRequestArray:(NSArray <MNetworkBaseRequest *> *)requestArray;

- (void)startWithprogressBlock:(MNetworkBatchRequestProgressBlock)progressBlock
                  successBlock:(MNetworkBatchRequestSuccessBlock)successBlock
                     failBlock:(MNetworkBatchRequestFailBlock)failBlock;

- (void)startWithprogressBlock:(MNetworkBatchRequestProgressBlock)progressBlock
                  successBlock:(MNetworkBatchRequestSuccessBlock)successBlock
                     failBlock:(MNetworkBatchRequestFailBlock)failBlock
               considerFailure:(BOOL)consider;

- (void)start;

- (void)cancel;

- (void)clean;

@end

NS_ASSUME_NONNULL_END
