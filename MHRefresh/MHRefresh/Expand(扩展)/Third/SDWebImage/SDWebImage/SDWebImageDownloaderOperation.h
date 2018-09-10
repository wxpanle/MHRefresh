/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageOperation.h"

//通知 任务开始 接收到数据 暂停 结束
//下载开始
FOUNDATION_EXPORT NSString * _Nonnull const SDWebImageDownloadStartNotification;
//收到响应
FOUNDATION_EXPORT NSString * _Nonnull const SDWebImageDownloadReceiveResponseNotification;
//停止通知
FOUNDATION_EXPORT NSString * _Nonnull const SDWebImageDownloadStopNotification;
//结束通知
FOUNDATION_EXPORT NSString * _Nonnull const SDWebImageDownloadFinishNotification;



/**
 Describes a downloader operation. If one wants to use a custom downloader op, it needs to inherit from `NSOperation` and conform to this protocol
 如果想自定义下载器的一些操作  需要继承NSOperation  并且实现该协议
 */
@protocol SDWebImageDownloaderOperationInterface<NSObject>

/**
 初始化一个请求

 @param request request description
 @param session session description
 @param options options description
 @return return value description
 */
- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request
                              inSession:(nullable NSURLSession *)session
                                options:(SDWebImageDownloaderOptions)options;

/**
 添加对下载进度的处理

 @param progressBlock progressBlock description
 @param completedBlock completedBlock description
 @return return value description
 */
- (nullable id)addHandlersForProgress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock;

/**
 是否压缩该图片

 @return return value description
 */
- (BOOL)shouldDecompressImages;

/**
 设置是否压缩图片

 @param value <#value description#>
 */
- (void)setShouldDecompressImages:(BOOL)value;

/**
 SSL验证证明

 @return return value description
 */
- (nullable NSURLCredential *)credential;

/**
 设置一个证明

 @param value value description
 */
- (void)setCredential:(nullable NSURLCredential *)value;

@end


@interface SDWebImageDownloaderOperation : NSOperation <SDWebImageDownloaderOperationInterface, SDWebImageOperation, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

/**
 * The request used by the operation's task. 当前线程执行的请求
 */
@property (strong, nonatomic, readonly, nullable) NSURLRequest *request;

/**
 * The operation's task  任务
 */
@property (strong, nonatomic, readonly, nullable) NSURLSessionTask *dataTask;

/**
 是否压缩图片 默认NO
 */
@property (assign, nonatomic) BOOL shouldDecompressImages;

/**
 *  Was used to determine whether the URL connection should consult the credential storage for authenticating the connection.
 *  @deprecated Not used for a couple of versions
 */
@property (nonatomic, assign) BOOL shouldUseCredentialStorage __deprecated_msg("Property deprecated. Does nothing. Kept only for backwards compatibility");

/**
 * The credential used for authentication challenges in `-connection:didReceiveAuthenticationChallenge:`.
 *
 * This will be overridden by any shared credentials that exist for the username or password of the request URL, if present.
 */
@property (nonatomic, strong, nullable) NSURLCredential *credential;

/**
 * The SDWebImageDownloaderOptions for the receiver.
 */
@property (assign, nonatomic, readonly) SDWebImageDownloaderOptions options;

/**
 * The expected size of data.  期望接收的数据
 */
@property (assign, nonatomic) NSInteger expectedSize;

/**
 * The response returned by the operation's connection.  请求的响应
 */
@property (strong, nonatomic, nullable) NSURLResponse *response;

/**
 *  Initializes a `SDWebImageDownloaderOperation` object  初始化一个请求
 *
 *  @see SDWebImageDownloaderOperation
 *
 *  @param request        the URL request
 *  @param session        the URL session in which this operation will run
 *  @param options        downloader options
 *
 *  @return the initialized instance
 */
- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request
                              inSession:(nullable NSURLSession *)session
                                options:(SDWebImageDownloaderOptions)options NS_DESIGNATED_INITIALIZER;

/**
 *  Adds handlers for progress and completion. Returns a tokent that can be passed to -cancel: to cancel this set of
 *  callbacks.
 *
 *  @param progressBlock  the block executed when a new chunk of data arrives.
 *                        @note the progress block is executed on a background queue
 *  @param completedBlock the block executed when the download is done.
 *                        @note the completed block is executed on the main queue for success. If errors are found, there is a chance the block will be executed on a background queue
 *
 *  @return the token to use to cancel this set of handlers
 */
- (nullable id)addHandlersForProgress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock;

/**
 *  Cancels a set of callbacks. Once all callbacks are canceled, the operation is cancelled.
 *
 *  @param token the token representing a set of callbacks to cancel
 *
 *  @return YES if the operation was stopped because this was the last token to be canceled. NO otherwise.
 */
- (BOOL)cancel:(nullable id)token;

@end
