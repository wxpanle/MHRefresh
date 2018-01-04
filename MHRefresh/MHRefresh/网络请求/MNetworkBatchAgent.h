//
//  MNetworkBatchAgent.h
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNetworkBatchRequest;

@interface MNetworkBatchAgent : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

+ (instancetype)sharedBatchAgent;

- (void)addBatchRequest:(MNetworkBatchRequest *)request;

- (void)removeBatchRequest:(MNetworkBatchRequest *)request;

@end
