//
//  MNetworkChainRequest.h
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MNetworkChainRequest, MNetworkBaseRequest;

typedef void (^ MNetworkChainSuccessBlock) (void);
typedef void (^ MNetworkChainFailBlock) (MNetworkBaseRequest *_Nullable request);

@protocol MNetworkChainRequestDelegate <NSObject>

- (void)mChainRequestFinished:(MNetworkChainRequest *)request;

- (void)mChainRequestFailed:(MNetworkChainRequest *)request;

@end

@interface MNetworkChainRequest : NSObject

@property (nonatomic, strong, readonly) NSArray *requestArray;

@property (nonatomic, strong, readonly, nullable) MNetworkBaseRequest *failRequest;

@property (nonatomic, weak) id <MNetworkChainRequestDelegate> delegate;

@property (nonatomic, copy) MNetworkChainSuccessBlock successBlock;

@property (nonatomic, copy) MNetworkChainFailBlock failBlock;

- (instancetype)initWithRequestArray:(NSArray *)array;

- (void)startWithSuccessBlock:(MNetworkChainSuccessBlock)successBlock
                    failBlock:(MNetworkChainFailBlock)failBlock;

- (void)start;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
