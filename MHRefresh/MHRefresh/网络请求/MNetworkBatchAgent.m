//
//  MNetworkBatchAgent.m
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkBatchAgent.h"
#import "MNetworkBatchRequest.h"

@interface MNetworkBatchAgent()

@property (nonatomic, strong) NSMutableArray <MNetworkBatchRequest *> * requestArray;

@end

@implementation MNetworkBatchAgent

#pragma mark - ========== init ==========

+ (instancetype)sharedBatchAgent {
    static MNetworkBatchAgent *sharedAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAgent = [[self alloc] init];
    });
    return sharedAgent;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _requestArray = [NSMutableArray array];
    }
    return self;
}


#pragma mark - ========== public ==========

- (void)addBatchRequest:(MNetworkBatchRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

- (void)removeBatchRequest:(MNetworkBatchRequest *)request {
    @synchronized(self) {
        [_requestArray addObject:request];
    }
}

@end
