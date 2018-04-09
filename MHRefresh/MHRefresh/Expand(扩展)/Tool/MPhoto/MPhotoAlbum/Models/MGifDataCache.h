//
//  MGifDataCache.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGifDataCache : NSObject

+ (instancetype)sharedGifDataCache;

- (void)cacheData:(NSData *)data image:(UIImage *)image;

- (NSData *)dataForImage:(UIImage *)image;

- (void)clearCacheForImage:(UIImage *)image;

@end
