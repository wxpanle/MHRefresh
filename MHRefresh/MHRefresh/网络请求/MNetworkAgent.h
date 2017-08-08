//
//  MNetworkAgent.h
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MNetworkBaseRequest;

@interface MNetworkAgent : NSObject

+ (instancetype)sharedAgent;

- (void)addRequest:(MNetworkBaseRequest *)request;

- (void)cancelRequest:(MNetworkBaseRequest *)request;

- (void)cancelAllRequests;

@end
