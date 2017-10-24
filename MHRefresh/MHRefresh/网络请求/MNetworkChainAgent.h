//
//  MNetworkChainAgent.h
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNetworkChainRequest;

@interface MNetworkChainAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedChainAgent;

- (void)addBatchRequest:(MNetworkChainRequest *)request;

- (void)removeBatchRequest:(MNetworkChainRequest *)request;

@end
