//
//  MNetworkChainAgent.m
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkChainAgent.h"

@interface MNetworkChainAgent()

@property (nonatomic, strong) NSMutableArray *requestArray;

@end

@implementation MNetworkChainAgent

- (instancetype)init {
    if (self = [super init]) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)sharedChainAgent {
    
    static MNetworkChainAgent *sharedChainAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedChainAgent = [[self alloc] init];
    });
    return sharedChainAgent;
}

- (void)addBatchRequest:(MNetworkChainRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeBatchRequest:(MNetworkChainRequest *)request {
    @synchronized(self) {
        [_requestArray removeObject:request];
    }
}

@end
