//
//  PLAudioHTTPRequest.h
//  MHRefresh
//
//  Created by panle on 2018/3/13.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PLAHTTPRStatus) {
    PLAHTTPRStatusNone,
    PLAHTTPRStatusDownloading,
    PLAHTTPRStatusSuspened,
    PLAHTTPRStatusCompleted,
    PLAHTTPRStatusFailed
};

typedef void (^ PLADHTTPRCompleteBlock)(BOOL isSuccess);
typedef void (^ PLADHTTPRDidReceiveResponseBlock)(void);
typedef void (^ PLADHTTPRProgressBlock)(NSProgress *progress, NSData * _Nullable data);

@interface PLAudioHTTPRequest : NSObject

+ (nullable instancetype)requestWithURL:(NSURL *)url;
- (nullable instancetype)initWithURL:(NSURL *)url;

+ (NSString *)defaultUserAgent;

@property (nonatomic, copy) NSString *cachePath;

@property (nonatomic, assign, readonly) PLAHTTPRStatus status;

/** default 30s */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, copy) NSString *userAgent;

@property (nonatomic, readonly) NSUInteger downloadSpeed;
@property (nonatomic, readonly, getter=isFailed) BOOL failed;

@property (nullable, nonatomic, copy) PLADHTTPRCompleteBlock completeBlock;
@property (nullable, nonatomic, copy) PLADHTTPRProgressBlock progressBlock;
@property (nullable, nonatomic, copy) PLADHTTPRDidReceiveResponseBlock receiveResponseBlock;

- (nullable NSDictionary *)responseHeaders;
- (NSUInteger)statusCode;

- (NSProgress *)progress;

- (void)start;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
