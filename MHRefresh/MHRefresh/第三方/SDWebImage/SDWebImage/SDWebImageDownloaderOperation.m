/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDownloaderOperation.h"
#import "SDWebImageDecoder.h"
#import "UIImage+MultiFormat.h"
#import <ImageIO/ImageIO.h>
#import "SDWebImageManager.h"
#import "NSImage+WebCache.h"

NSString *const SDWebImageDownloadStartNotification = @"SDWebImageDownloadStartNotification";  //下载开始
NSString *const SDWebImageDownloadReceiveResponseNotification = @"SDWebImageDownloadReceiveResponseNotification"; //收到响应通知
NSString *const SDWebImageDownloadStopNotification = @"SDWebImageDownloadStopNotification";    //下载停止
NSString *const SDWebImageDownloadFinishNotification = @"SDWebImageDownloadFinishNotification"; //下载结束

//回调进程key
static NSString *const kProgressCallbackKey = @"progress";  //回调进程key
//下载完成key
static NSString *const kCompletedCallbackKey = @"completed"; //下载完成key

typedef NSMutableDictionary<NSString *, id> SDCallbacksDictionary;  //宏定义

@interface SDWebImageDownloaderOperation ()

@property (strong, nonatomic, nonnull) NSMutableArray<SDCallbacksDictionary *> *callbackBlocks;  //回调数组

//线程正在执行
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
//线程结束执行
@property (assign, nonatomic, getter = isFinished) BOOL finished;
//请求响应的数据
@property (strong, nonatomic, nullable) NSMutableData *imageData;
//缓存的数据
@property (copy, nonatomic, nullable) NSData *cachedData;

// This is weak because it is injected（注入、引入） by whoever manages this session. If this gets nil-ed out, we won't be able to run
// the task associated（关联）with this operation
//弱引用的session
@property (weak, nonatomic, nullable) NSURLSession *unownedSession;
// This is set if we're using not using an injected NSURLSession. We're responsible（负责） of invalidating（无效） this one
//自身拥有
@property (strong, nonatomic, nullable) NSURLSession *ownedSession;

//当前的下载任务
@property (strong, nonatomic, readwrite, nullable) NSURLSessionTask *dataTask;

//栅栏队列
@property (SDDispatchQueueSetterSementics, nonatomic, nullable) dispatch_queue_t barrierQueue;

#if SD_UIKIT
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;
#endif

@end

@implementation SDWebImageDownloaderOperation {
    size_t _width, _height; 
#if SD_UIKIT || SD_WATCH
    UIImageOrientation _orientation;  //图片方向
#endif
    CGImageSourceRef _imageSource;  //图片源
}

//告诉编译器 由我们提供setter和getter方法
@synthesize executing = _executing;  //重写父类方法
@synthesize finished = _finished;

- (nonnull instancetype)init {
    return [self initWithRequest:nil inSession:nil options:0];
}

//指定的初始化方法
- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request
                              inSession:(nullable NSURLSession *)session
                                options:(SDWebImageDownloaderOptions)options {
    if ((self = [super init])) {
        _request = [request copy];
        _shouldDecompressImages = YES;  //默认开启图片解压
        _options = options;   //当前下载属性
        _callbackBlocks = [NSMutableArray new];  //回调主线程数组
        _executing = NO;      //是否正在执行
        _finished = NO;       //是否结束
        _expectedSize = 0;    //初始化接受数据
        _unownedSession = session; //配置sesseion
        _barrierQueue = dispatch_queue_create("com.hackemist.SDWebImageDownloaderOperationBarrierQueue", DISPATCH_QUEUE_CONCURRENT);  //创建栅栏函数
    }
    return self;
}

- (void)dealloc {  //释放
    SDDispatchQueueRelease(_barrierQueue);
    if (_imageSource) {
        CFRelease(_imageSource);
        _imageSource = NULL;
    }
}

- (nullable id)addHandlersForProgress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock {
    SDCallbacksDictionary *callbacks = [NSMutableDictionary new];
    if (progressBlock) callbacks[kProgressCallbackKey] = [progressBlock copy];
    if (completedBlock) callbacks[kCompletedCallbackKey] = [completedBlock copy];
    dispatch_barrier_async(self.barrierQueue, ^{//异步开启栅栏函数  //dispatch_barrier_async  后续任务可以继续插入  队列  并且等待此次任务执行完成后 才会执行后续任务
        //dispatch_barrier_sync  后续任务无法继续插入队列   等待此次任务执行完成后  才会将后续任务继续插入队列  并执行后续任务
        //两者区别  都会等待当前任务执行完成后才会继续执行下一个任务 不同:是否允许后续任务插入队列  使用具体情况具体对待
        [self.callbackBlocks addObject:callbacks];  //添加回调
    });
    return callbacks;
}

- (nullable NSArray<id> *)callbacksForKey:(NSString *)key {  //回调
    __block NSMutableArray<id> *callbacks = nil;
    dispatch_sync(self.barrierQueue, ^{ //同步开启栅栏函数  此时不再接受回调函数
        // We need to remove [NSNull null] because there might not always be a progress block for each callback
        callbacks = [[self.callbackBlocks valueForKey:key] mutableCopy];
        [callbacks removeObjectIdenticalTo:[NSNull null]]; //移除数组中指定相同地址的元素
    });
    return [callbacks copy];    // strip mutability here  清除空函数
}

- (BOOL)cancel:(nullable id)token { //取消一个任务
    __block BOOL shouldCancel = NO;
    dispatch_barrier_sync(self.barrierQueue, ^{ //同步开启栅栏函数
        [self.callbackBlocks removeObjectIdenticalTo:token]; //[array removeObject:(id)] :删除数组中指定元素，根据对象isEqual消息判断。
        //[array  removeObjectIdenticalTo:(id)] : 删除数组中指定元素,根据对象的地址判断
        if (self.callbackBlocks.count == 0) { //是否结束当前线程
            //如果还有别的地方调用了这张图片  不允许结束线程
            shouldCancel = YES;
        }
    });
    if (shouldCancel) {
        [self cancel];//取消本次操作
    }
    return shouldCancel;
}

- (void)start {  //开始
    @synchronized (self) {
        if (self.isCancelled) {  //已经取消 返回
            self.finished = YES;
            [self reset];
            return;
        }

#if SD_UIKIT
        Class UIApplicationClass = NSClassFromString(@"UIApplication");
        BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
        if (hasApplication && [self shouldContinueWhenAppEntersBackground]) {  //开启后台任务
            __weak __typeof__ (self) wself = self;
            UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
            self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
                __strong __typeof (wself) sself = wself;

                if (sself) {
                    [sself cancel];

                    [app endBackgroundTask:sself.backgroundTaskId];
                    sself.backgroundTaskId = UIBackgroundTaskInvalid;
                }
            }];
        }
#endif
        if (self.options & SDWebImageDownloaderIgnoreCachedResponse) {
            // Grab the cached data for later check
            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:self.request];
            if (cachedResponse) {
                self.cachedData = cachedResponse.data;
            }
        }
        
        NSURLSession *session = self.unownedSession;
        if (!self.unownedSession) {
            NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            sessionConfig.timeoutIntervalForRequest = 15;
            
            /**
             *  Create the session for this task
             *  We send nil as delegate queue so that the session creates a serial operation queue for performing all delegate
             *  method calls and completion handler calls.
             */
            //自己创建一个seeesion
            self.ownedSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                              delegate:self
                                                         delegateQueue:nil];
            session = self.ownedSession;
        }
        
        self.dataTask = [session dataTaskWithRequest:self.request];
        self.executing = YES;
    }
    
    [self.dataTask resume];

    if (self.dataTask) {
        //回调进程开始下载
        for (SDWebImageDownloaderProgressBlock progressBlock in [self callbacksForKey:kProgressCallbackKey]) {
            progressBlock(0, NSURLResponseUnknownLength, self.request.URL);
        }
        //发出请求开始下载
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStartNotification object:weakSelf];
        });
    } else {
        //session 初始化失败
        [self callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Connection can't be initialized"}]];
    }

#if SD_UIKIT
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) { //对应上面  结束后台任务
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
#endif
}

- (void)cancel {  //取消当前操作
    @synchronized (self) { //
        [self cancelInternal];
    }
}

- (void)cancelInternal {  //内部取消
    if (self.isFinished) return; //如果已经结束  返回
    [super cancel];  //通知父类取消

    if (self.dataTask) { //如果下载任务存在
        [self.dataTask cancel]; //取消任务执行
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{  //发出下载停止的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:weakSelf];
        });

        // As we cancelled the connection, its callback won't be called and thus won't
        // maintain the isFinished and isExecuting flags.
        if (self.isExecuting) self.executing = NO; //如果任务正在执行  改变状态发出通知
        if (!self.isFinished) self.finished = YES; //如果任务没有结束  改变结束状态r
    }

    [self reset];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset { //清除本次操作的所有回调
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(self.barrierQueue, ^{  //异步开启栅栏删除  清除所有操作函数
        [weakSelf.callbackBlocks removeAllObjects];
    });
    self.dataTask = nil; //置nil请求
    
    NSOperationQueue *delegateQueue;
    if (self.unownedSession) {
        delegateQueue = self.unownedSession.delegateQueue; //NSURLSession 创建时
    } else {
        delegateQueue = self.ownedSession.delegateQueue;
    }
    if (delegateQueue) {
        //串行队列
        NSAssert(delegateQueue.maxConcurrentOperationCount == 1, @"NSURLSession delegate queue should be a serial queue");
        [delegateQueue addOperationWithBlock:^{
            weakSelf.imageData = nil; //清除缓存数据
        }];
    }
    
    if (self.ownedSession) {
        [self.ownedSession invalidateAndCancel];  //释放URLSession
        self.ownedSession = nil;
    }
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];  //发出通知
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    //'304 Not Modified' is an exceptional(异常的) one  //图片没有被修改过
    if (![response respondsToSelector:@selector(statusCode)] || (((NSHTTPURLResponse *)response).statusCode < 400 && ((NSHTTPURLResponse *)response).statusCode != 304)) {  //正确状态码
        NSInteger expected = (NSInteger)response.expectedContentLength;  //预期的长度
        expected = expected > 0 ? expected : 0;  //清除错误长度
        self.expectedSize = expected;  //赋值
        for (SDWebImageDownloaderProgressBlock progressBlock in [self callbacksForKey:kProgressCallbackKey]) {
            progressBlock(0, expected, self.request.URL);   //回调进度
        }
        
        //初始化数据 准备接受数据
        self.imageData = [[NSMutableData alloc] initWithCapacity:expected];
        self.response = response; //响应
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            //任务开始接收到响应
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadReceiveResponseNotification object:weakSelf];
        });
    } else {  //错误状态码
        NSUInteger code = ((NSHTTPURLResponse *)response).statusCode;  //获取响应状态码
        
        //This is the case when server returns '304 Not Modified'. It means that remote image is not changed.
        //In case of 304 we need just cancel the operation and return cached image from the cache.
        if (code == 304) {
            //如果当前状态码是304  意味着图片没有发生改变  返回缓存的图片即可
            [self cancelInternal];
        } else {
            //取消当前任务
            [self.dataTask cancel];  //取消当前任务
        }
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            //停止下载
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:weakSelf];
        });
        //回调
        [self callCompletionBlocksWithError:[NSError errorWithDomain:NSURLErrorDomain code:((NSHTTPURLResponse *)response).statusCode userInfo:nil]];

        [self done];  //结束
    }
    
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);  //响应结束回调
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    //接受到数据 开始拼接数据
    [self.imageData appendData:data];

    if ((self.options & SDWebImageDownloaderProgressiveDownload) && self.expectedSize > 0) {  //下载进度
        // The following code is from http://www.cocoaintheshell.com/2011/05/progressive-images-download-imageio/
        // Thanks to the author @Nyx0uf
        
        // Get the image data
        NSData *imageData = [self.imageData copy];  //图片数据缓存
        // Get the total bytes downloaded
        const NSInteger totalSize = imageData.length; //当前下载大小
        // Get the finish status
        BOOL finished = (totalSize >= self.expectedSize); //如果当前下载总数 >= 期望大小  代表下载完成
        
        if (!_imageSource) {
            _imageSource = CGImageSourceCreateIncremental(NULL);  //创建一个空的图像源  之后添加数据
        }
        // Update the data source, we must pass ALL the data, not just the new bytes
        CGImageSourceUpdateData(_imageSource, (__bridge CFDataRef)imageData, finished); //添加图像源
        
        if (_width + _height == 0) {
            CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(_imageSource, 0, NULL);
            if (properties) {
                NSInteger orientationValue = -1;
                CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight); //宽度
                if (val) CFNumberGetValue(val, kCFNumberLongType, &_height);
                val = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth); //高度
                if (val) CFNumberGetValue(val, kCFNumberLongType, &_width);
                val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation); //方向
                if (val) CFNumberGetValue(val, kCFNumberNSIntegerType, &orientationValue);
                CFRelease(properties);  //释放
                
                // When we draw to Core Graphics, we lose orientation information,
                // which means the image below born of initWithCGIImage will be
                // oriented incorrectly sometimes. (Unlike the image born of initWithData
                // in didCompleteWithError.) So save it here and pass it on later.
#if SD_UIKIT || SD_WATCH
                _orientation = [[self class] orientationFromPropertyValue:(orientationValue == -1 ? 1 : orientationValue)];  //修正方向
#endif
            }
        }
        
        if (_width + _height > 0 && !finished) {  //正在传输
            // Create the image
            CGImageRef partialImageRef = CGImageSourceCreateImageAtIndex(_imageSource, 0, NULL);  //
            
#if SD_UIKIT || SD_WATCH
            // Workaround for iOS anamorphic image
            if (partialImageRef) {
                const size_t partialHeight = CGImageGetHeight(partialImageRef); //高度
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();  //创建依赖设备的颜色空间
                CGContextRef bmContext = CGBitmapContextCreate(NULL, _width, _height, 8, _width * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst); //位图
                CGColorSpaceRelease(colorSpace);   //释放颜色空间
                if (bmContext) {
                    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = _width, .size.height = partialHeight}, partialImageRef);//绘制image
                    CGImageRelease(partialImageRef); //释放
                    partialImageRef = CGBitmapContextCreateImage(bmContext); //复制了一份image
                    CGContextRelease(bmContext);
                }
                else {
                    CGImageRelease(partialImageRef);
                    partialImageRef = nil;
                }
            }
#endif
            
            if (partialImageRef) {   //如果重新绘制图片成功
#if SD_UIKIT || SD_WATCH
                UIImage *image = [UIImage imageWithCGImage:partialImageRef scale:1 orientation:_orientation];  //创建image
#elif SD_MAC
                UIImage *image = [[UIImage alloc] initWithCGImage:partialImageRef size:NSZeroSize];
#endif
                CGImageRelease(partialImageRef);
                NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:self.request.URL];  //获取缓存key值
                UIImage *scaledImage = [self scaledImageForKey:key image:image]; //缩放image
                if (self.shouldDecompressImages) {  //是否将图片解压到内存中
                    image = [UIImage decodedImageWithImage:scaledImage];  //解压图片
                }
                else {
                    image = scaledImage;
                }
                
                [self callCompletionBlocksWithImage:image imageData:nil error:nil finished:NO];
            }
        }
        
        if (finished) {
            if (_imageSource) {
                CFRelease(_imageSource);
                _imageSource = NULL;
            }
        }
    }

    for (SDWebImageDownloaderProgressBlock progressBlock in [self callbacksForKey:kProgressCallbackKey]) {
        progressBlock(self.imageData.length, self.expectedSize, self.request.URL);
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    
    NSCachedURLResponse *cachedResponse = proposedResponse;

    if (self.request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData) { //如果不需要缓存响应  那么会清空缓存中的数据
        // Prevents caching of responses  阻止缓存响应
        cachedResponse = nil;  //
    }
    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}

#pragma mark NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    @synchronized(self) {
        self.dataTask = nil;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{  //下载已经停止
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:weakSelf];
            if (!error) { //下载已经完成
                [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadFinishNotification object:weakSelf];
            }
        });
    }
    
    if (error) {
        [self callCompletionBlocksWithError:error];  //主线程回调错误响应
    } else {
        if ([self callbacksForKey:kCompletedCallbackKey].count > 0) {  //回调存在
            /**
             *  If you specified to use `NSURLCache`, then the response you get here is what you need.
             */
            NSData *imageData = [self.imageData copy];  //数据
            if (imageData) {  
                UIImage *image = [UIImage sd_imageWithData:imageData]; //创建image
                /**  if you specified to only use cached data via `SDWebImageDownloaderIgnoreCachedResponse`,
                 *  then we should check if the cached data is equal to image data
                 */
                if (self.options & SDWebImageDownloaderIgnoreCachedResponse && [self.cachedData isEqualToData:imageData]) {
                    // call completion block with nil
                    [self callCompletionBlocksWithImage:nil imageData:nil error:nil finished:YES]; //回调数据
                } else {
                    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:self.request.URL];//缓存数据
                    image = [self scaledImageForKey:key image:image];  //缩放image
                    
                    BOOL shouldDecode = YES;  //是否应该解码
                    // Do not force decoding animated GIFs and WebPs  //动图和webp不会解码
                    if (image.images) { //动图
                        shouldDecode = NO;
                    } else {   //webp
#ifdef SD_WEBP
                        SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:imageData];
                        if (imageFormat == SDImageFormatWebP) {
                            shouldDecode = NO;
                        }
#endif
                    }
                    
                    if (shouldDecode) {  //允许解压
                        if (self.shouldDecompressImages) {
                            if (self.options & SDWebImageDownloaderScaleDownLargeImages) {  //解压image
#if SD_UIKIT || SD_WATCH
                                image = [UIImage decodedAndScaledDownImageWithImage:image];
                                imageData = UIImagePNGRepresentation(image);
#endif
                            } else {
                                image = [UIImage decodedImageWithImage:image];
                            }
                        }
                    }
                    if (CGSizeEqualToSize(image.size, CGSizeZero)) {  //如果image不存在像素点
                        [self callCompletionBlocksWithError:[NSError errorWithDomain:SDWebImageErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Downloaded image has 0 pixels"}]]; //不存在像素点
                    } else {  //回调下载成功
                        [self callCompletionBlocksWithImage:image imageData:imageData error:nil finished:YES];
                    }
                }
            } else {//回调下载失败
                [self callCompletionBlocksWithError:[NSError errorWithDomain:SDWebImageErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Image data is nil"}]];
            }
        }
    }
    [self done];  //结束当前正在下载的operation
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    //处理重定向问题
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (!(self.options & SDWebImageDownloaderAllowInvalidSSLCertificates)) {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        } else {
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            disposition = NSURLSessionAuthChallengeUseCredential;
        }
    } else {
        if (challenge.previousFailureCount == 0) {
            if (self.credential) {
                credential = self.credential;
                disposition = NSURLSessionAuthChallengeUseCredential;
            } else {
                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
            }
        } else {
            disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
        }
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}

#pragma mark Helper methods

#if SD_UIKIT || SD_WATCH
+ (UIImageOrientation)orientationFromPropertyValue:(NSInteger)value {
    switch (value) {
        case 1:
            return UIImageOrientationUp;
        case 3:
            return UIImageOrientationDown;
        case 8:
            return UIImageOrientationLeft;
        case 6:
            return UIImageOrientationRight;
        case 2:
            return UIImageOrientationUpMirrored;
        case 4:
            return UIImageOrientationDownMirrored;
        case 5:
            return UIImageOrientationLeftMirrored;
        case 7:
            return UIImageOrientationRightMirrored;
        default:
            return UIImageOrientationUp;
    }
}
#endif

- (nullable UIImage *)scaledImageForKey:(nullable NSString *)key image:(nullable UIImage *)image {
    return SDScaledImageForKey(key, image);
}

/**
 判断任务是否允许在后台执行

 @return return value description
 */
- (BOOL)shouldContinueWhenAppEntersBackground {
    return self.options & SDWebImageDownloaderContinueInBackground;
}

- (void)callCompletionBlocksWithError:(nullable NSError *)error {
    [self callCompletionBlocksWithImage:nil imageData:nil error:error finished:YES];
}

/**
 回调任务

 @param image image description
 @param imageData imageData description
 @param error error description
 @param finished finished description
 */
- (void)callCompletionBlocksWithImage:(nullable UIImage *)image
                            imageData:(nullable NSData *)imageData
                                error:(nullable NSError *)error
                             finished:(BOOL)finished {
    NSArray<id> *completionBlocks = [self callbacksForKey:kCompletedCallbackKey];
    dispatch_main_async_safe(^{  //开启主线程
        for (SDWebImageDownloaderCompletedBlock completedBlock in completionBlocks) {
            completedBlock(image, imageData, error, finished);
        }
    });
}

@end
