//
//  MLagMonitor.m
//  RunloopMonitor
//
//  Created by zyx on 16/7/6.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "MLagMonitor.h"
#import <CrashReporter/CrashReporter.h>

#if M_MONITOR_ENABLED
@interface MLagMonitor()

@property (nonatomic, strong) dispatch_semaphore_t semaphore;

@property (nonatomic, assign) CFRunLoopActivity currentActivity;

@property (nonatomic, assign) NSUInteger timeoutCount;

@property (nonatomic, assign) CFRunLoopObserverRef monitorObserver;

@property (nonatomic, strong) NSOperation *monitorOperation;


@end

@implementation MLagMonitor

+ (void)load
{
    [[MLagMonitor sharedMonitor] beginMonitor];
}

+ (instancetype)sharedMonitor
{
    static MLagMonitor *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[self alloc] init];
    });
    return monitor;
}



- (void)beginMonitor
{
    _semaphore = dispatch_semaphore_create(0);
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    _monitorObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    CFRunLoopAddObserver(CFRunLoopGetMain(), _monitorObserver, kCFRunLoopCommonModes);
    
    
    _monitorOperation = [NSBlockOperation blockOperationWithBlock:^{
        while (YES) { // 监测runloop回调的时间间隔，判断是否有超时的现象
        
            if (_monitorOperation.isCancelled) {
                break;
            }
            
            if (_monitorObserver) {
                long sem = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC));
                if (sem != 0) {
                    
                    if (_currentActivity == kCFRunLoopBeforeSources || _currentActivity == kCFRunLoopAfterWaiting) {
                        
                        _timeoutCount ++;
                        if (_timeoutCount <= 3) {
                            continue;
                        }
                        DLog(@"监测出问题了, 当前线程为 - %@", [NSThread currentThread]);
                        
//                        NSData *lagData = [[[PLCrashReporter alloc]
//                                            initWithConfiguration:[[PLCrashReporterConfig alloc] initWithSignalHandlerType:PLCrashReporterSignalHandlerTypeBSD symbolicationStrategy:PLCrashReporterSymbolicationStrategyAll]] generateLiveReport];
//                        PLCrashReport *lagReport = [[PLCrashReport alloc] initWithData:lagData error:NULL];
//                        NSString *lagReportString = [PLCrashReportTextFormatter stringValueForCrashReport:lagReport withTextFormat:PLCrashReportTextFormatiOS];
////                        //将字符串上传服务器
//                        NSLog(@"lag happen, detail below: \n %@",lagReportString);
//                        AVObject *obj = [AVObject objectWithClassName:@"lag"];
//                        [obj setObject:lagReportString forKey:@"lagInfo"];
//                        [obj save];
                    }
                    
                    
                }
                _timeoutCount = 0;
            }
        }
    }];
    [[[NSOperationQueue alloc] init] addOperation:_monitorOperation];
}

- (void)endMonitor
{
    
    if (!_monitorObserver) {
        return;
    }
    
    [_monitorOperation cancel];
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), _monitorObserver, kCFRunLoopCommonModes);
    CFRelease(_monitorObserver);
    _monitorObserver = NULL;
}

#pragma park - 

void (runLoopObserverCallBack)(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    MLagMonitor *monitor = (__bridge MLagMonitor *)info;
    monitor.currentActivity = activity;
    dispatch_semaphore_signal(monitor.semaphore);
}




@end

#endif
