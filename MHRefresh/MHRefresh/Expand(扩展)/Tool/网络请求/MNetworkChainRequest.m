//
//  MNetworkChainRequest.m
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkChainRequest.h"
#import "MNetworkDownloadRequest.h"
#import "MNetworkBatchRequest.h"
#import "MNetworkChainAgent.h"

@interface MNetworkChainRequest() <MNetworkBaseRequestDelegate, MNetworkBatchRequestDelegate, MNetworkChainRequestDelegate>

@property (nonatomic, assign) NSUInteger nextRequestIndex;

@end

@implementation MNetworkChainRequest

- (instancetype)initWithRequestArray:(NSArray *)array {
    
    if (self = [super init]) {
        _nextRequestIndex = 0;
        _requestArray = [NSArray arrayWithArray:array];
    }
    return self;
}

- (void)startWithSuccessBlock:(MNetworkChainSuccessBlock)successBlock
                    failBlock:(MNetworkChainFailBlock)failBlock {
    self.successBlock = successBlock;
    self.failBlock = failBlock;
    [self start];
}

- (void)start {
    
    if (_nextRequestIndex > 0) {
        return;
    }
    
    if (!_requestArray.count) {
        if (self.successBlock) {
            self.successBlock();
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(mChainRequestFinished:)]) {
            [self.delegate mChainRequestFinished:self];
        }
        return;
    }
    
    [[MNetworkChainAgent sharedChainAgent] addBatchRequest:self];
    [self nextRequestIndex];
}

- (void)cancel {
    
    NSUInteger currentRequestIndex = _nextRequestIndex;
    
    if (currentRequestIndex < [_requestArray count]) {
        MNetworkBaseRequest *request = _requestArray[currentRequestIndex];
        [request cancel];
    }
    
    _requestArray = nil;
    [self clean];
}

- (void)clean {
    _successBlock = nil;
    _failBlock = nil;
}

- (void)startNextRequest {
    
    id request = nil;
    if (_nextRequestIndex < [_requestArray count]) {
        request = [_requestArray objectAtIndex:_nextRequestIndex];
    } else {
        return;
    }
    
    if ([request isKindOfClass:[MNetworkBaseRequest class]]) {
        MNetworkBaseRequest *baseRequest = (MNetworkBaseRequest *)request;
        baseRequest.delegate = self;
        [baseRequest clearBlock];
        [baseRequest start];
    } else if ([request isKindOfClass:[MNetworkBatchRequest class]]) {
        MNetworkBatchRequest *batchRequest = (MNetworkBatchRequest *)request;
        batchRequest.delegate = self;
        [batchRequest clean];
        [batchRequest start];
    } else if ([request isKindOfClass:[MNetworkChainRequest class]]) {
        MNetworkChainRequest *chainRequest = (MNetworkChainRequest *)request;
        chainRequest.delegate = self;
        [chainRequest start];
    } else {
        DLog(@"%@", NSStringFromClass([request class]));
    }
}

#pragma mark - MNetworkBaseRequestDelegate
- (void)mRequestFinishSuccess:(nullable MNetworkBaseRequest *)request {
    [self handleRequestFinish];
}

- (void)mRequestFinishFail:(nullable MNetworkBaseRequest *)request {
    _failRequest = request;
    [self handleRequestFailWithBaseNetwork:request];
}

#pragma mark - MNetworkBatchRequestDelegate
- (void)mBatchRequestFinish:(MNetworkBatchRequest *)request {
    [self handleRequestFinish];
}

- (void)mBatchRequestFail:(MNetworkBatchRequest *)request {
    [self handleRequestFailWithBaseNetwork:request.failedRequest];
}

#pragma mark - MNetworkChainRequestDelegate
- (void)mChainRequestFinished:(MNetworkChainRequest *)request {
    [self handleRequestFinish];
}

- (void)mChainRequestFailed:(MNetworkChainRequest *)request {
    [self handleRequestFailWithBaseNetwork:request.failRequest];
}

#pragma mark - private
- (void)handleRequestFinish {
    
    _nextRequestIndex++;
    
    if (_nextRequestIndex < _requestArray.count) {
        [self nextRequestIndex];
    } else if (_nextRequestIndex >= _requestArray.count) {
        
        if (_successBlock) {
            _successBlock();
        }
        
        if ([self.delegate respondsToSelector:@selector(mChainRequestFinished:)]) {
            [self.delegate mChainRequestFinished:self];
        }
        
        [[MNetworkChainAgent sharedChainAgent] removeBatchRequest:self];
        _nextRequestIndex = 0;
    }
}

- (void)handleRequestFailWithBaseNetwork:(MNetworkBaseRequest *)request {
    
    if (self.failBlock) {
        self.failBlock(request);
    }
    
    if ([self.delegate respondsToSelector:@selector(mChainRequestFailed:)]) {
        [self.delegate mChainRequestFailed:self];
    }
    
    [self clean];
    
    [[MNetworkChainAgent sharedChainAgent] removeBatchRequest:self];
}

@end
