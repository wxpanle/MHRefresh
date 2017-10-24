//
//  MNetworkBatchRequest.m
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkBatchRequest.h"
#import "MNetworkBaseRequest.h"
#import "MNetworkBatchAgent.h"

@interface MNetworkBatchRequest() <MNetworkBaseRequestDelegate>

@property (nonatomic, assign) NSInteger finishedCount;

@property (nonatomic, assign) NSInteger totalCount;

@end

@implementation MNetworkBatchRequest

- (instancetype)initWithRequestArray:(NSArray <MNetworkBaseRequest *> *)requestArray {
    
    if (self = [super init]) {
        _requestArray = [NSArray arrayWithArray:requestArray];
        _finishedCount = 0;
        
        for (MNetworkBaseRequest *request in _requestArray) {
            if (![request isKindOfClass:[MNetworkBaseRequest class]]) {
                NSAssert([request isKindOfClass:[MNetworkBaseRequest class]], NSStringFromClass([request class]));
                return nil;
            }
        }
    }
    return self;
}

- (void)startWithprogressBlock:(MNetworkBatchRequestProgressBlock)progressBlock
                  successBlock:(MNetworkBatchRequestSuccessBlock)successBlock
                     failBlock:(MNetworkBatchRequestFailBlock)failBlock {
    [self startWithprogressBlock:progressBlock successBlock:successBlock failBlock:failBlock considerFailure:NO];
}

- (void)startWithprogressBlock:(MNetworkBatchRequestProgressBlock)progressBlock
                  successBlock:(MNetworkBatchRequestSuccessBlock)successBlock
                     failBlock:(MNetworkBatchRequestFailBlock)failBlock
               considerFailure:(BOOL)consider {
    self.process = progressBlock;
    self.success = successBlock;
    self.failure = failBlock;
    _considerFailure = consider;
    [self start];
}

- (void)start {
    
    if (_finishedCount != 0) {
        return;
    }
    
    _failedRequest = nil;
    
    WeakSelf
    if (_requestArray.count == 0) {
        dispatch_async_main_safe(^{
            StrongSelf
            !strongSelf.process ? : strongSelf.process(1.f);
            !strongSelf.success ? : strongSelf.success(strongSelf);
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(mBatchRequestFinish:)]) {
                [strongSelf.delegate mBatchRequestFinish:strongSelf];
            }
        });
        return;
    }
    
    //start request
    dispatch_async_main_safe(^{
        if (self.process) {
            self.process(0.0);
        }
    });
    
    [[MNetworkBatchAgent sharedBatchAgent] addBatchRequest:self];

    
    for (MNetworkBaseRequest *request in _requestArray) {
        request.delegate = self;
        [request clearBlock];
        [request start];
    }
}

- (void)cancel {
    
    for (MNetworkBaseRequest *request in _requestArray) {
        [request cancel];
    }
    
    [self clean];
    [[MNetworkBatchAgent sharedBatchAgent] removeBatchRequest:self];
}

- (void)clean {
    _success = nil;
    _process = nil;
    _failure = nil;
    _failedRequest = nil;
}

#pragma mark - MNetworkBaseRequestDelegate
- (void)mRequestFinishSuccess:(nullable MNetworkBaseRequest *)request {
    self.finishedCount++;
}

- (void)mRequestFinishFail:(nullable MNetworkBaseRequest *)request {
    
    _failedRequest = request;
    
    if (!_considerFailure) {
        self.finishedCount++;
        return;
    }
    
    _failedRequest = request;
    dispatch_async_main_safe(^{
        if (self.failure) {
            self.failure(self);
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(mBatchRequestFail:)]) {
            [self.delegate mBatchRequestFail:self];
        }
    });
    
    [self cancel];
}

- (void)setFinishedCount:(NSInteger)finishedCount {
    _finishedCount = finishedCount;
    
    if (self.process) {
        self.process(finishedCount / self.requestArray.count);
    }
    
    if (finishedCount >= self.requestArray.count) {
        
        if (self.success) {
            self.success(self);
        }
        if ([self.delegate respondsToSelector:@selector(mBatchRequestFinish:)]) {
            [self.delegate mBatchRequestFinish:self];
        }
        
        [self cancel];
        [[MNetworkBatchAgent sharedBatchAgent] removeBatchRequest:self];
    }
}

- (void)dealloc {
    
    DLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
