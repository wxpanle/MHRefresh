//
//  PLAudioHTTPRequest.m
//  MHRefresh
//
//  Created by panle on 2018/3/13.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLAudioHTTPRequest.h"

@interface PLAudioHTTPRequest () <NSURLSessionDataDelegate> {
    
    NSURL *_requestUrl;
    
    NSError *_error;

    NSUInteger _requestStartTime;
    
    NSUInteger _downloadSpeed;
    
    BOOL _failed;
    
    NSProgress *_progress;
    
    UInt64 _receivedLength;
    
    NSURLSession *_urlSession;
}

@property (nonatomic, strong) NSURLSessionDataTask *sessionTask;

@property (nonatomic, assign, readwrite) PLAHTTPRStatus status;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation PLAudioHTTPRequest

@synthesize failed = _failed;
@synthesize downloadSpeed = _downloadSpeed;

#pragma mark - ======== init & dealloc ========

+ (instancetype)requestWithURL:(NSURL *)url {
    if (nil == url) {
        return nil;
    }
    return [[self alloc] initWithURL:url];
}


- (instancetype)initWithURL:(NSURL *)url {
    
    if (!url) {
        return nil;
    }
    
    if (self = [super init]) {
        _requestUrl = url;
    }
    return self;
}

- (void)dealloc {
    [self cancel];
}

#pragma mark - ======== public ========

+ (NSString *)defaultUserAgent {
    
    static NSString *defaultUserAgent = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [infoDict objectForKey:@"CFBundleName"];
        NSString *shortVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
        NSString *bundleVersion = [infoDict objectForKey:@"CFBundleVersion"];

        NSString *deviceName = nil;
        NSString *systemName = nil;
        NSString *systemVersion = nil;

        UIDevice *device = [UIDevice currentDevice];
        deviceName = [device model];
        systemName = [device systemName];
        systemVersion = [device systemVersion];

        NSString *locale = [[NSLocale currentLocale] localeIdentifier];
        defaultUserAgent = [NSString stringWithFormat:@"%@ %@ build %@ (%@; %@ %@; %@)", appName, shortVersion, bundleVersion, deviceName, systemName, systemVersion, locale];
    });

    return defaultUserAgent;
}

- (void)start {
    
    if (_sessionTask) {
        return;
    }
    
    NSURLSessionConfiguration *defaultURLSessionConfiguration = [self defaultURLSessionConfiguration];
    _urlSession = [NSURLSession sessionWithConfiguration:defaultURLSessionConfiguration delegate:self delegateQueue:nil];
    
    _sessionTask = [_urlSession dataTaskWithURL:_requestUrl];
    //开始请求
    [_sessionTask resume];
}

- (void)cancel {
    
    if (_sessionTask) {
        [_sessionTask cancel];
    }
    
    [self p_clearCallBlock];
}

- (NSProgress *)progress {
    return _progress;
}

#pragma mark - ======== private ========

- (NSURLSessionConfiguration *)defaultURLSessionConfiguration {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.allowsCellularAccess = YES;
    configuration.timeoutIntervalForRequest = 60.0;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    configuration.discretionary = YES;
    return configuration;
}

- (void)p_addObserves {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_applicationDidReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_addlicationDidEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(p_applicationWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)p_updateDownloadSpeed {
    
    _downloadSpeed = _receivedLength / (CFAbsoluteTimeGetCurrent() - _requestStartTime);
}

- (void)p_clearCallBlock {
    _completeBlock = nil;
    _progressBlock = nil;
    _receiveResponseBlock = nil;
}


#pragma mark -  NSNotification
- (void)p_applicationWillTerminate {
    
    [_sessionTask cancel];
}

- (void)p_applicationDidReceiveMemoryWarning {
    
    //收到内存警告 暂不处理
}

- (void)p_addlicationDidEnterBackgroundNotification {
    
    Class applecationClass = NSClassFromString(@"UIApplication");

    if (applecationClass && [applecationClass respondsToSelector:@selector(sharedApplication)]) {
        __weak typeof(self) weakSelf = self;
        UIApplication *app = [applecationClass performSelector:@selector(sharedApplication)];
        _backgroundTaskIdentifier = [app beginBackgroundTaskWithExpirationHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (!strongSelf) {
                return;
            }
            
            if (strongSelf.sessionTask.state == NSURLSessionTaskStateRunning) {
                [strongSelf.sessionTask suspend];
            }
            
            [app endBackgroundTask:_backgroundTaskIdentifier];
            strongSelf.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }];
    }
}

- (void)p_applicationWillEnterForegroundNotification {
    
    if (_sessionTask.state == NSURLSessionTaskStateSuspended) {
        [_sessionTask resume];
    }
    
    if (_backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        Class applecationClass = NSClassFromString(@"UIApplication");
        if (applecationClass && [applecationClass respondsToSelector:@selector(sharedApplication)]) {
            UIApplication *app = [applecationClass performSelector:@selector(sharedApplication)];
            [app endBackgroundTask:_backgroundTaskIdentifier];
            _backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        }
    }
}


#pragma mark - ======== getter ========

- (nullable NSHTTPURLResponse *)p_httpURLResponse {
    return (NSHTTPURLResponse *)_sessionTask.response;
}

- (nullable NSDictionary *)responseHeaders {
    return [self p_httpURLResponse].allHeaderFields;
}

- (NSUInteger)statusCode {
    return [self p_httpURLResponse].statusCode;
}

- (BOOL)isFailed {
    return _status == PLAHTTPRStatusFailed;
}


#pragma mark - <NSURLSessionDataDelegate>

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
                didReceiveResponse:(NSURLResponse *)response
        completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    if (dataTask.taskIdentifier != _sessionTask.taskIdentifier) {
        completionHandler(NSURLSessionResponseCancel);
        return;
    }

    _status = PLAHTTPRStatusDownloading;
    
    _receivedLength = 0;
    
    _progress = [NSProgress progressWithTotalUnitCount:dataTask.countOfBytesExpectedToReceive];
    
    //回调接收到响应
    if (_receiveResponseBlock) {
        _receiveResponseBlock();
    }
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    if (dataTask.taskIdentifier != _sessionTask.taskIdentifier) {
        return;
    }
    
    _receivedLength += data.length;
    
    [self p_updateDownloadSpeed];
    
    // Write Data
    NSInputStream *inputStream =  [[NSInputStream alloc] initWithData:data];
    NSOutputStream *outputStream = [[NSOutputStream alloc] initWithURL:[NSURL fileURLWithPath:self.cachePath] append:YES];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [inputStream open];
    [outputStream open];
    
    while ([inputStream hasBytesAvailable] && [outputStream hasSpaceAvailable]) {
        uint8_t buffer[1024];
        
        NSInteger bytesRead = [inputStream read:buffer maxLength:1024];
        if (inputStream.streamError || bytesRead < 0) {
            _error = inputStream.streamError;
            break;
        }
        
        NSInteger bytesWritten = [outputStream write:buffer maxLength:(NSUInteger)bytesRead];
        if (outputStream.streamError || bytesWritten < 0) {
            _error = outputStream.streamError;
            break;
        }
        
        if (bytesRead == 0 && bytesWritten == 0) {
            break;
        }
    }
    [outputStream close];
    [inputStream close];
    
    _progress.totalUnitCount = dataTask.countOfBytesExpectedToReceive;
    _progress.completedUnitCount = dataTask.countOfBytesReceived;
    
    if (_progressBlock) {
        _progressBlock(_progress, data);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (task.taskIdentifier != _sessionTask.taskIdentifier) {
        return;
    }
    
    if (error) {
        _error = error;
        _status = PLAHTTPRStatusFailed;
    } else {
        _status = PLAHTTPRStatusCompleted;
    }

    if (_completeBlock) {
        _completeBlock(_status == PLAHTTPRStatusFailed ? NO : YES);
    }
}

- (NSString *)formatByteCount:(long long)size {

    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

@end
