//
//  MNetworkRequestOperation.m
//  MHRefresh
//
//  Created by developer on 2017/10/19.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkRequestOperation.h"
#import "MNetworkBaseRequest.h"

@interface MNetworkRequestOperation()

@property (nonatomic, strong) MNetworkBaseRequest *request;

@property (nonatomic, assign, getter = isExecuting) BOOL executing;

@property (nonatomic, assign, getter = isFinished) BOOL finished;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;

@end

@implementation MNetworkRequestOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

#pragma mark - ===== init =====

- (instancetype)initWithNetworkBaseRequest:(id)request {
    if (self = [super init]) {
        _request = request;
        _executing = NO;
        _finished = NO;
    }
    return self;
}


#pragma mark - ===== public =====

- (BOOL)isOperationOfDataTaskIdentifier:(NSUInteger)identifier {
    
    if (!self.request) {
        return NO;
    }
    
    if (!self.request.requestTask) {
        return NO;
    }
    
    return self.request.requestTask.taskIdentifier == identifier ? YES : NO;
}


#pragma mark - ===== overwrite =====

- (void)start {
    @synchronized (self) {

        if (self.isCancelled) {
            [self done];
            return;
        }

        if (!self.request || self.request.isCancelled) {
            self.finished = YES;
            return;
        }

        Class UIApplicationClass = NSClassFromString(@"UIApplication");
        BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
        if (hasApplication) {
            WeakSelf
            UIApplication *application = [UIApplicationClass performSelector:@selector(sharedApplication)];
            self.backgroundTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
                StrongSelf
                if (strongSelf) {
                    [strongSelf cancel];
                    [application endBackgroundTask:strongSelf.backgroundTaskId];
                    strongSelf.backgroundTaskId = UIBackgroundTaskInvalid;
                }
            }];
        }
        self.executing = YES;
    }

    [self loadData];

    //同步开启
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
        [application endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
}

- (void)loadData {
    
    if (!self.request) {
        [self done];
        return;
    }
    
    [self.request.requestTask resume];
}

- (void)cancel {
    @synchronized (self) {
        [self cancelInternal];
    }
}

- (void)cancelInternal {
    if (self.isFinished) {
        return;
    }
    [super cancel];
    [self.request cancel];
    [self done];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    self.request = nil;
}

#pragma mark - ===== MNetworkFinishOperationProtocol =====

- (void)networkRequestFinish:(MNetworkBaseRequest *)request {
    if (self.isFinished) {
        return;
    }
    
    [self done];
}


#pragma mark - ===== setter =====

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

@end
