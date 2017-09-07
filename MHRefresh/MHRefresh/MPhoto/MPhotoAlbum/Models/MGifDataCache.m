//
//  MGifDataCache.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MGifDataCache.h"

@interface MGifDataCache()

@property (nonatomic, strong) NSMutableDictionary <UIImage *, NSData *> *dictionary;

@end

@implementation MGifDataCache

+ (instancetype)sharedGifDataCache {
    
    static dispatch_once_t onceToken;
    static MGifDataCache *dataCache = nil;
    dispatch_once(&onceToken, ^{
        dataCache = [[MGifDataCache alloc] init];
    });
    return dataCache;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)cacheData:(NSData *)data image:(UIImage *)image {
    [self.dictionary setObject:data forKey:image];
}

- (NSData *)dataForImage:(UIImage *)image {
    return [self.dictionary objectForKey:image];
}

- (void)clearCacheForImage:(UIImage *)image {
    [self.dictionary setObject:nil forKey:image];
}

#pragma mark - getter
- (NSMutableDictionary *)dictionary {
    if (nil == _dictionary) {
        _dictionary = [NSMutableDictionary dictionary];
    }
    return _dictionary;
}

@end
