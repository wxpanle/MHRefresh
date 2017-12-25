//
//  MNetworkImageCache.h
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDImageCacheConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MNetworkCacheNoParamsBlock) (void);

typedef void(^MNetworkCacheCheckCacheBlock)(BOOL isExist);

typedef BOOL(^MNetworkCacheFilterBlock) (NSString *fileName);

typedef void(^MNetworkCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

@interface MNetworkImageCache : NSObject

#pragma mark - Properties

/** image cache config */
@property (nonatomic, strong) SDImageCacheConfig *cacheConfig;

/** max memory cost  */
@property (nonatomic, assign) NSUInteger maxMemoryCost;

/** max memory limit */
@property (nonatomic, assign) NSUInteger maxMemoryCountLimit;

///-------------------------------
/// @name init shard
///-------------------------------

/**
 default basepath-NSCachesDirectory subpath-MCahce/image

 @param subPath path=NSCachesDirectory/subPath
 @return        manager
 */
+ (instancetype)sharedImageCacheWithSubPath:(NSString *)subPath;


///-------------------------------
/// @name store
///-------------------------------

/**
 异步存储一张图片

 @param image       image
 @param customPath  customPath
 @param block       call back
 */
- (void)storeImageAsynchronous:(nullable UIImage *)image
                    customPath:(NSString *)customPath
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 异步存储一张图片

 @param image       image
 @param imageData   imageData
 @param customPath  customPath
 @param block       block
 */
- (void)storeImageAsynchronous:(nullable UIImage *)image
                     imageData:(nullable NSData *)imageData
                    customPath:(NSString *)customPath
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 异步存储一张图片

 @param image       image
 @param imageData   imageData
 @param customPath  customPath
 @param saveDisk    save to disk
 @param block       block
 */
- (void)storeImageAsynchronous:(nullable UIImage *)image
                     imageData:(nullable NSData *)imageData
                    customPath:(NSString *)customPath
                      saceDisk:(BOOL)saveDisk
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 异步存储一张图片

 @param imageData   imageData
 @param customPath  customPath
 @param saveDisk    save disk
 @param block       block
 */
- (void)storeImageDataAsynchronous:(nullable NSData *)imageData
                        customPath:(NSString *)customPath
                          saceDisk:(BOOL)saveDisk
                     completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 asyn store

 @param image  image
 @param key    user self.basePath/key
 @param block  block
 */
- (void)storeImageAsynchronous:(nullable UIImage *)image
                        forKey:(NSString *)key
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 asyn store

 @param image     image
 @param imageData image data
 @param key       use self.basePath/keu=y
 @param block     block
 */
- (void)storeImageAsynchronous:(nullable UIImage *)image
                     imageData:(nullable NSData *)imageData
                        forKey:(NSString *)key
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 * Asynchronously store an image into memory and disk cache at the given key.
 *
 * @param image           The image to store
 * @param key             The unique image cache key, usually it's image absolute URL
 * @param saveDisk          Store the image to disk cache if YES
 * @param completeBlock A block executed after the operation is finished
 */
- (void)storeImageAsynchronous:(nullable UIImage *)image
                        forKey:(nullable NSString *)key
                      saveDisk:(BOOL)saveDisk
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 asyn store
 
 @param image     image
 @param imageData image data
 @param key       use self.basePath/keu=y
 @param saveDisk  save to disk
 @param block     block
 */
- (void)storeImageAsynchronous:(nullable UIImage *)image
                     imageData:(nullable NSData *)imageData
                        forKey:(NSString *)key
                      saveDisk:(BOOL)saveDisk
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 asyn store

 @param imageData image data
 @param key       use self.basePath/keu=y
 @param saveDisk  save to disk
 @param block     block
 */
- (void)storeImageDataAsynchronous:(nullable NSData *)imageData
                            forKey:(NSString *)key
                          saveDisk:(BOOL)saveDisk
                     completeBlock:(nullable MNetworkCacheNoParamsBlock)block;


///-------------------------------
/// @name  search
///-------------------------------


/**
 image is exist

 @param key   use self.basePath/key
 @param block block
 */
- (void)imageIsExistAsynWithKey:(nullable NSString *)key completeBlock:(nullable MNetworkCacheCheckCacheBlock)block;
- (void)imageIsExistAsynWithCustomPath:(NSString *)customPath completeBlock:(nullable MNetworkCacheCheckCacheBlock)block;

/**
 * Operation that queries the cache asynchronously and call the completion when done.
 *
 * @param key       The unique key used to store the wanted image
 * @param doneBlock The completion block. Will not get called if the operation is cancelled
 *
 * @return a NSOperation instance containing the cache op
 */
//- (nullable NSOperation *)queryCacheOperationForKey:(nullable NSString *)key done:(nullable SDCacheQueryCompletedBlock)doneBlock;

/**
 sync memory

 @param key self.basePath/key
 @return    nullable
 */
- (nullable UIImage *)imageFromMemoryCacheForKey:(nullable NSString *)key;

/**
 sync disk

 @param key self.basePath/key
 @return    nullable
 */
- (nullable UIImage *)imageFromDiskCacheForKey:(nullable NSString *)key;

/**
 sync memory disk

 @param key self.basePath/key
 @return    block
 */
- (nullable UIImage *)imageFromCacheForKey:(nullable NSString *)key;

/**
 sync memory disk

 @param customPath customPath
 @return           nullable
 */
- (nullable UIImage *)imageFromCacheForCustomPath:(NSString *)customPath;


///-------------------------------
/// @name remove
///-------------------------------

/**
 remove memory disk

 @param key   self.basePath/key
 @param block block
 */
- (void)removeImageForKey:(nullable NSString *)key completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 remove memory disk
 
 @param key      self.basePath/key
 @param withDisk BOOL
 @param block    block
 */
- (void)removeImageForKey:(nullable NSString *)key withDisk:(BOOL)withDisk completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 remove memory disk
 
 @param customPath customPath
 @param block      block
 */
- (void)removeImageForCustomPath:(NSString *)customPath completeBlock:(nullable MNetworkCacheNoParamsBlock)block;

/**
 remove memory disk
 
 @param customPath customPath
 @param withDisk   BOOL
 @param block      block
 */
- (void)removeImageForCustomPath:(NSString *)customPath withDisk:(BOOL)withDisk completeBlock:(nullable MNetworkCacheNoParamsBlock)block;


///-------------------------------
/// @name clear
///-------------------------------

/**
 clear memory all
 */
- (void)clearMemory;

/**
 clear disk all
 */
- (void)clearDiskCache;

/**
 filter need delete file

 @param block YES -> delete NO - save
 */
- (void)deleteImageWithFilter:(MNetworkCacheFilterBlock)block;

@end

NS_ASSUME_NONNULL_END
