//
//  MNetworkDownloadRequest.h
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkBaseRequest.h"

typedef NS_ENUM(NSInteger, MNetworkDownloadType) {
    MNetworkDownloadTypeImage,
    MNetworkDownloadTypeVideo,
    MNetworkDownloadTypeAudio,
    MNetworkDownloadTypeFile
};

/** progress block */
typedef void (^MNetworkDownloadProgressBlock)(CGFloat progress);

@interface MNetworkDownloadRequest : MNetworkBaseRequest

/** download file save path */
@property (nonatomic, copy, readonly) NSString *storagePath;

/** download file save name default use file name */
@property (nonatomic, copy, readonly) NSString *storeKey;

/** download type */
@property (nonatomic, assign) MNetworkDownloadType downloadType;

/** progress block */
@property (nonatomic, copy) MNetworkDownloadProgressBlock progressBlock;

///-------------------------------
/// @name 默认请求  GET
///-------------------------------
+ (instancetype)downloadRequestWithDetailUrl:(NSString *)detailUrl
                                downloadType:(MNetworkDownloadType)type;

+ (instancetype)downloadRequestWithDetailUrl:(NSString *)detailUrl
                                downloadType:(MNetworkDownloadType)type
                            downloadPriority:(MNetworkRequestPriority)priority;

+ (instancetype)downloadRequestWithCustomUrl:(NSString *)customUrl
                                downloadType:(MNetworkDownloadType)type;

+ (instancetype)downloadRequestWithCustomUrl:(NSString *)customUrl
                                downloadType:(MNetworkDownloadType)type
                            downloadPriority:(MNetworkRequestPriority)priority;

- (void)startWithProgressBlock:(MNetworkDownloadProgressBlock)progressBlock
                       success:(MNetworkRequestSuccessBlock)successBlock
                       failure:(MNetworkRequestFailureBlock)failureBlock
                   immediately:(BOOL)immdiately;


@end
