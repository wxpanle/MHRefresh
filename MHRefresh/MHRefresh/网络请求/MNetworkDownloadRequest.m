//
//  MNetworkDownloadRequest.m
//  MHRefresh
//
//  Created by developer on 2017/8/4.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkDownloadRequest.h"

@interface MNetworkDownloadRequest()

@property (nonatomic, copy) NSString *basePath;

@end

@implementation MNetworkDownloadRequest

+ (instancetype)downloadRequestWithDetailUrl:(NSString *)detailUrl
                                downloadType:(MNetworkDownloadType)type {
    return [self downloadRequestWithDetailUrl:detailUrl downloadType:type downloadPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype)downloadRequestWithDetailUrl:(NSString *)detailUrl
                                downloadType:(MNetworkDownloadType)type
                            downloadPriority:(MNetworkRequestPriority)priority {
    
    MNetworkDownloadRequest *request = [self requestWithDeatilUrl:detailUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeDownload requestPriority:priority];
    request.downloadType = type;
    return request;
}

+ (instancetype)downloadRequestWithCustomUrl:(NSString *)customUrl
                                downloadType:(MNetworkDownloadType)type {
    return [self downloadRequestWithCustomUrl:customUrl downloadType:type downloadPriority:MNetworkRequestPriorityDefault];
}

+ (instancetype)downloadRequestWithCustomUrl:(NSString *)customUrl
                                downloadType:(MNetworkDownloadType)type
                            downloadPriority:(MNetworkRequestPriority)priority {
    MNetworkDownloadRequest *request = [self requestWithCustomUrl:customUrl requestMethod:MNetworkRequestMethodGET requestType:MNetworkRequestTypeDownload requestPriority:priority];
    request.downloadType = type;
    return request;
}

- (void)startWithProgressBlock:(MNetworkDownloadProgressBlock)progressBlock
                       success:(MNetworkRequestSuccessBlock)successBlock
                       failure:(MNetworkRequestFailureBlock)failureBlock
                   immediately:(BOOL)immdiately {
    
    self.progressBlock = progressBlock;
    [super startWithCompleteBlockSuccess:successBlock failure:failureBlock immediately:immdiately];
}

- (void)clearBlock {
    self.progressBlock = nil;
    [super clearBlock];
}

- (NSString *)storeKey {
    
    if (self.customUrl) {
        NSArray *array = [self.customUrl componentsSeparatedByString:@"/"];
        return array.lastObject;
    }

    return self.detailurl;
}


- (NSString *)basePath {
    if (_basePath == nil) {
        _basePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Mcache"];
        switch (self.downloadType) {
            case MNetworkDownloadTypeImage: {
                _basePath = [_basePath stringByAppendingPathComponent:@"image"];
                break;
            }
            case MNetworkDownloadTypeAudio: {
                _basePath = [_basePath stringByAppendingPathComponent:@"audio"];
                break;
            }
            case MNetworkDownloadTypeVideo: {
                _basePath = [_basePath stringByAppendingPathComponent:@"video"];
                break;
            }
            case MNetworkDownloadTypeFile: {
                _basePath = [_basePath stringByAppendingPathComponent:@"file"];
            }
        }
    }
    return _basePath;
}

- (NSString *)storagePath {
    return [self.basePath stringByAppendingPathComponent:self.storeKey];
}

@end
