//
//  MNetworkImageCache.m
//  MHRefresh
//
//  Created by developer on 2017/10/24.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MNetworkImageCache.h"
#import "SDWebImageDecoder.h"
#import "UIImage+MultiFormat.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"
#import "NSImage+WebCache.h"
#import "QYMemoryCache.h"

/** 内存允许缓存的最大的图片消耗 60M */
static NSUInteger kMaxMemoryCost = 1024 * 1024 * 60;

/** 图片活跃秒数 300s 之内没有被使用会被清除掉 */
static NSUInteger kActiveSeconds = 5 * 60;

static NSString *kDefaultCacheSubPath = @"MCache/image";

FOUNDATION_STATIC_INLINE NSUInteger SDCacheCostForImage(UIImage *image) {
    return image.size.height * image.size.width * image.scale * image.scale;
}

//SDWebImage
@interface MNetworkImageCache()

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSMutableSet *keySet;

@property (nonatomic, strong) QYMemoryCache *memoryCache;

@property (nonatomic, strong, nullable) dispatch_queue_t ioQueue;

@property (nonatomic, copy) NSString *basePath;

@property (nonatomic, copy) NSString *subPath;

@property (nonatomic, copy) NSString *diskPath;

@property (nonatomic, assign) NSUInteger kActiveSeconds;

@end

@implementation MNetworkImageCache

#pragma mark - ===== init =====

+ (instancetype)sharedImageCacheWithSubPath:(NSString *)subPath {
    
    static MNetworkImageCache *imageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (subPath.length) {
            imageCache = [[MNetworkImageCache alloc] initWithCacheSubPath:subPath];
        } else {
            imageCache = [[MNetworkImageCache alloc] init];
        }
        
        SDImageCacheConfig *imageCacheConfig = [[SDImageCacheConfig alloc] init];
        imageCache.cacheConfig = imageCacheConfig;
    });
    
    return imageCache;
}

- (instancetype)init {
    return [self initWithCacheSubPath:kDefaultCacheSubPath];
}

- (instancetype)initWithCacheSubPath:(NSString *)subPath {
    return [self initWithCahceSubPath:subPath diskCacheFirstDirectory:[self baseDiskFirstPath]];
}

- (instancetype)initWithCahceSubPath:(NSString *)subPath diskCacheFirstDirectory:(NSString *)directory {
    
    if (self = [super init]) {
        
        NSString *fullNamespace = directory;
        DLog(@"MNetworkImage base - %@, sub - %@", directory, subPath);
        
        //init queue
        _ioQueue = dispatch_queue_create("com.netImageCache", DISPATCH_QUEUE_SERIAL);
        
        _cacheConfig = [[SDImageCacheConfig alloc] init];
        
        //配置缓存
        _memoryCache = [[QYMemoryCache alloc] init];
        _memoryCache.costLimit = kMaxMemoryCost;
        _memoryCache.activeMemorySeconds = kActiveSeconds;
        _memoryCache.shouldClearUselessData = YES;
        _memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        _memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = NO;
        _memoryCache.name = fullNamespace;
        _memoryCache.queue = _ioQueue;

        
        //init base path
        if (directory.length) {
            _basePath = directory;
        } else {
            _basePath = [self baseDiskFirstPath];
        }
        
        //init sub path
        if (subPath.length) {
            _subPath = subPath;
        } else {
            _subPath = kDefaultCacheSubPath;
        }
        
        //disk path
        _diskPath = [_basePath stringByAppendingPathComponent:_subPath];
        
        //init file manager
        dispatch_async(_ioQueue, ^{
            _fileManager = [[NSFileManager alloc] init];
        });
    }
    
    return self;
}

#pragma mark - ===== public =====

- (void)storeImageAsynchronous:(nullable UIImage *)image
                    customPath:(NSString *)customPath
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self storeImageAsynchronous:image imageData:nil customPath:customPath completeBlock:block];
}

- (void)storeImageAsynchronous:(nullable UIImage *)image
                     imageData:(nullable NSData *)imageData
                    customPath:(NSString *)customPath
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    
    [self storeImageAsynchronous:image imageData:nil customPath:customPath saceDisk:YES completeBlock:block];
}

- (void)storeImageDataAsynchronous:(nullable NSData *)imageData
                        customPath:(NSString *)customPath
                          saceDisk:(BOOL)saveDisk
                     completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self storeImageAsynchronous:nil imageData:imageData customPath:customPath saceDisk:saveDisk completeBlock:block];
}

- (void)storeImageAsynchronous:(nullable UIImage *)image
                     imageData:(nullable NSData *)imageData
                    customPath:(NSString *)customPath
                      saceDisk:(BOOL)saveDisk
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    
    if (!customPath.length) {
        if (block) {
            dispatch_async_main_safe(block);
        }
        return;
    }
    
    NSString *key = [self createStoreKeyWithCustomPath:customPath];
    
    [self storeImageAsynchronous:image imageData:imageData forKey:key path:customPath saveDisk:(BOOL)saveDisk completeBlock:block];
}

- (void)storeImageAsynchronous:(nullable UIImage *)image
                        forKey:(NSString *)key
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self storeImageAsynchronous:image imageData:nil forKey:key completeBlock:block];
}

- (void)storeImageAsynchronous:(nullable UIImage *)image
                     imageData:(nullable NSData *)imageData
                        forKey:(NSString *)key
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self storeImageAsynchronous:image imageData:imageData forKey:key saveDisk:YES completeBlock:block];
}

- (void)storeImageAsynchronous:(nullable UIImage *)image
                        forKey:(nullable NSString *)key
                      saveDisk:(BOOL)saveDisk
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self storeImageAsynchronous:image imageData:nil forKey:key saveDisk:saveDisk completeBlock:block];
}

- (void)storeImageDataAsynchronous:(nullable NSData *)imageData
                            forKey:(NSString *)key
                          saveDisk:(BOOL)saveDisk
                     completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self storeImageAsynchronous:nil imageData:imageData forKey:key saveDisk:saveDisk completeBlock:block];
}

- (void)storeImageAsynchronous:(nullable UIImage *)image
                     imageData:(nullable NSData *)imageData
                        forKey:(NSString *)key
                      saveDisk:(BOOL)saveDisk
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    
    if (!key.length) {
        if (block) {
            block();
        }
        return;
    }
    
    [self storeImageAsynchronous:image imageData:imageData forKey:key path:nil saveDisk:YES completeBlock:block];
}


- (void)storeImageAsynchronous:(nullable UIImage *)image
                     imageData:(nullable NSData *)imageData
                        forKey:(NSString *)key
                          path:(nullable NSString *)path
                      saveDisk:(BOOL)saveDisk
                 completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    //存储图片
    BOOL dataFlag = imageData.length > 0 || image != nil;
    
    if (!dataFlag) {
        if (block) {
            dispatch_async_main_safe(block);
        }
        return;
    }
    
    if (!key.length && !path.length) {
        if (block) {
            dispatch_async_main_safe(block);
        }
        return;
    }
    
    if (image && self.cacheConfig.shouldCacheImagesInMemory) {
        NSUInteger cost = SDCacheCostForImage(image);
        [_memoryCache setObject:image forKey:key withCost:cost];
    }
    
    //是否允许写入磁盘
    if (saveDisk) {
        dispatch_async(self.ioQueue, ^{
            @autoreleasepool {
                NSData *data = imageData;
                if (!data && image) {
                    SDImageFormat imageFormatFromData = [NSData sd_imageFormatForImageData:data];
                    data = [image sd_imageDataAsFormat:imageFormatFromData];
                }
                [self storeImageDataToDisk:data forKey:key diskPath:path];
            };
            
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
        });
    } else {
        if (block) {
            block();
        }
    }
}


#pragma mark - ===== search =====

- (void)imageIsExistAsynWithKey:(nullable NSString *)key completeBlock:(nullable MNetworkCacheCheckCacheBlock)block {
    
    if (!key.length) {
        return;
    }
    
    [self imageIsExistAsynWithCustomPath:[self cacheDiskPathWithKey:key] completeBlock:block];
}

- (void)imageIsExistAsynWithCustomPath:(NSString *)customPath completeBlock:(nullable MNetworkCacheCheckCacheBlock)block {
    
    if (!customPath.length) {
        return ;
    }
    
    dispatch_async(self.ioQueue, ^{
        
        BOOL exists = [self.fileManager fileExistsAtPath:customPath];
        
        if (!exists) {
            [self.fileManager fileExistsAtPath:customPath.stringByDeletingLastPathComponent];
        }
        
        if (block) {
            dispatch_async_main_safe(^{
                block(exists);
            });
        }
        
    });
}

- (nullable UIImage *)imageFromMemoryCacheForKey:(nullable NSString *)key {
    
    return [_memoryCache objectForKey:key];
}

- (nullable UIImage *)imageFromDiskCacheForKey:(nullable NSString *)key {
    
    NSData *data = [self diskImageDataBySearchingAllPathsForKey:key];
    
    if (data) {
        UIImage *image = [UIImage sd_imageWithData:data];
        image = [self scaledImageForKey:key image:image];
        
#ifdef SD_WEBP
        SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
        if (imageFormat == SDImageFormatWebP) {
            return image;
        }
#endif
        
        if (self.cacheConfig.shouldDecompressImages) {
            image = [UIImage decodedImageWithImage:image];
        }
        
//        NSUInteger cost = SDCacheCostForImage(image);
//        [_memoryCache setObject:image forKey:key withCost:cost];

        return image;
    } else {
        return nil;
    }
}

- (nullable UIImage *)imageFromCacheForKey:(nullable NSString *)key {

    UIImage *image = [self imageFromMemoryCacheForKey:key];
    if (image) {
        return image;
    }
    
    image = [self imageFromDiskCacheForKey:key];
    return image;
}

- (nullable UIImage *)imageFromCacheForCustomPath:(NSString *)customPath {
    
    NSString *key = [self createStoreKeyWithCustomPath:customPath];
    return [self imageFromMemoryCacheForKey:key];
}

- (nullable UIImage *)imageFromDiskForCustomPath:(NSString *)customPath {
    
    NSData *data = [self diskImageDataBySearchingPath:customPath];
    
    if (data) {
        NSString *key = [self createStoreKeyWithCustomPath:customPath];
        UIImage *image = [UIImage sd_imageWithData:data];
        image = [self scaledImageForKey:key image:image];
        
#ifdef SD_WEBP
        SDImageFormat imageFormat = [NSData sd_imageFormatForImageData:data];
        if (imageFormat == SDImageFormatWebP) {
            return image;
        }
#endif
        
        if (self.cacheConfig.shouldDecompressImages) {
            image = [UIImage decodedImageWithImage:image];
        }
        
//        NSUInteger cost = SDCacheCostForImage(image);
//        [_memoryCache setObject:image forKey:key withCost:cost];
        
        return image;
    } else {
        return nil;
    }
}

- (nullable NSData *)diskImageDataBySearchingAllPathsForKey:(NSString *)key {
    
    NSString *path = [self cacheDiskPathWithKey:key];
    return [self diskImageDataBySearchingPath:path];
}

- (nullable NSData *)diskImageDataBySearchingPath:(nullable NSString *)path {
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if (data) {
        return data;
    }
    
    // fallback because of https://github.com/rs/SDWebImage/pull/976 that added the extension to the disk file name
    // checking the key with and without the extension
    data = [NSData dataWithContentsOfFile:path.stringByDeletingPathExtension];
    if (data) {
        return data;
    }
    
    return nil;
}


#pragma mark - ===== remove =====

- (void)removeImageForKey:(nullable NSString *)key completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self removeImageForKey:key withDisk:YES completeBlock:block];
}

- (void)removeImageForKey:(nullable NSString *)key withDisk:(BOOL)withDisk completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self removeImageKey:key path:nil withDisk:withDisk completeBlock:block];
}

- (void)removeImageForCustomPath:(NSString *)customPath completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self removeImageForCustomPath:customPath withDisk:YES completeBlock:block];
}

- (void)removeImageForCustomPath:(NSString *)customPath withDisk:(BOOL)withDisk completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    [self removeImageKey:nil path:customPath withDisk:withDisk completeBlock:block];
}

- (void)removeImageKey:(nullable NSString *)key path:(nullable NSString *)path withDisk:(BOOL)withDisk completeBlock:(nullable MNetworkCacheNoParamsBlock)block {
    
    if (!key.length && !path.length) {
        return;
    }
    
    NSString *saveKey = key;
    NSString *savePath = path;
    
    if (!saveKey.length) {
        saveKey = [self createStoreKeyWithCustomPath:savePath];
    } else {
        savePath = [self cacheDiskPathWithKey:saveKey];
    }
    
    [_memoryCache removeObjectForKey:saveKey];
    
    if (withDisk) {
        
        dispatch_async(self.ioQueue, ^{
            [self.fileManager removeItemAtPath:path error:nil];
            
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
        });
    } else if (block) {
        block();
    }
}


#pragma mark - ===== clear =====

- (void)clearMemory {
    [_memoryCache removeAllObjects];
}

- (void)clearDiskCache {
    dispatch_async(self.ioQueue, ^{
        [self.fileManager removeItemAtPath:self.diskPath error:nil];
        [self.fileManager createDirectoryAtPath:self.diskPath withIntermediateDirectories:YES attributes:nil error:nil];
    });
}

- (void)deleteImageWithFilter:(MNetworkCacheFilterBlock)block {
    
    dispatch_async(self.ioQueue, ^{
        NSURL *diskCacheUrl = [NSURL fileURLWithPath:self.diskPath isDirectory:YES];
        
        NSArray <NSString *> * resourceKeys = @[NSURLIsDirectoryKey, NSURLTotalFileAllocatedSizeKey];
        
        NSDirectoryEnumerator *fileEnumerator = [self.fileManager enumeratorAtURL:diskCacheUrl includingPropertiesForKeys:resourceKeys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
        
        NSMutableArray <NSURL *> *urlToDelete = [[NSMutableArray alloc] init];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSError *error;
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:&error];
            
            if (error || !resourceValues || [resourceValues[NSURLIsDirectoryKey] boolValue]) {
                continue;
            }
            
            BOOL canDelete = YES;
            
            if (block) {
                canDelete = block([self createStoreKeyWithCustomPath:fileURL.absoluteString]);
            }
            
            if (canDelete) {
                [urlToDelete addObject:fileURL];
            }
        }
        
        for (NSURL *fileUrl in urlToDelete) {
            [self.fileManager removeItemAtURL:fileUrl error:nil];
        }
        
    });
}

#pragma mark - Cache paths

- (NSString *)baseDiskFirstPath {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
}

- (NSString *)makeDiskPathWithSubPath:(NSString *)subPath {
    return [[self baseDiskFirstPath] stringByAppendingPathComponent:subPath];
}

- (NSString *)cacheDiskPathWithKey:(NSString *)key {
    
    if (!self.diskPath.length) {
        self.diskPath = [self.basePath stringByAppendingPathComponent:self.subPath];
    }
    
    return [self.diskPath stringByAppendingPathComponent:key];
}

#pragma mark - Store Ops

- (void)storeImageDataToDisk:(nullable NSData *)imageData forKey:(nullable NSString *)key diskPath:(nullable NSString *)diskPath {
    
    if (!imageData.length || !key.length) {
        return;
    }
    
    [self checkIfQueueIsIOQueue];
    
    NSString *path = diskPath;
    
    if (!path.length) {
        path = [self cacheDiskPathWithKey:key];
    }
    
    if (![path containsString:key]) {
        [path stringByAppendingPathComponent:key];
    }
    
    if (![self.fileManager fileExistsAtPath:self.diskPath]) {
        [self.fileManager createDirectoryAtPath:self.diskPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [self.fileManager createFileAtPath:path contents:imageData attributes:nil];
    
    if (!self.cacheConfig.shouldDisableiCloud) {
        return;
    }
    
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    //禁止云备份
    [fileUrl setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
}


#pragma mark - Query and Retrieve Ops

- (nullable UIImage *)scaledImageForKey:(nullable NSString *)key image:(nullable UIImage *)image {
    return SDScaledImageForKey(key, image);
}

//- (nullable NSOperation *)queryCacheOperationForKey:(nullable NSString *)key done:(nullable SDCacheQueryCompletedBlock)doneBlock {
//    if (!key) {
//        if (doneBlock) {
//            doneBlock(nil, nil, SDImageCacheTypeNone);
//        }
//        return nil;
//    }
//
//    // First check the in-memory cache...
//    UIImage *image = [self imageFromMemoryCacheForKey:key];
//    if (image) {
//        NSData *diskData = nil;
//        if ([image isGIF]) {
//            diskData = [self diskImageDataBySearchingAllPathsForKey:key];
//        }
//        if (doneBlock) {
//            doneBlock(image, diskData, SDImageCacheTypeMemory);
//        }
//        return nil;
//    }

//    NSOperation *operation = [NSOperation new];
//    dispatch_async(self.ioQueue, ^{
//        if (operation.isCancelled) {
//            // do not call the completion if cancelled
//            return;
//        }
//
//        @autoreleasepool {
//            NSData *diskData = [self diskImageDataBySearchingAllPathsForKey:key];
//            UIImage *diskImage = [self diskImageForKey:key];
//            if (diskImage && self.config.shouldCacheImagesInMemory) {
//                NSUInteger cost = SDCacheCostForImage(diskImage);
//                [self.memoryCache setObject:diskImage forKey:key cost:cost];
//            }
//
//            if (doneBlock) {
//                dispatch_async_main_safe(^{
//                    doneBlock(diskImage, diskData, SDImageCacheTypeDisk);
//                });
//            }
//        }
//    });

//    return operation;
//}

#pragma mark - ===== setter getter =====

- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost {
    _maxMemoryCost = maxMemoryCost;
    _memoryCache.costLimit = maxMemoryCost;
}

- (void)setMaxMemoryCount:(NSUInteger)maxMemoryCount {
    _maxMemoryCount = maxMemoryCount;
    _memoryCache.countLimit = maxMemoryCount;
}

- (NSUInteger)currentCost {
    return _memoryCache.totalCost;
}

- (NSUInteger)currentCount {
    return _memoryCache.totalCount;
}


#pragma mark - ===== size =====

- (NSUInteger)getSize {
    __block NSUInteger size = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [self.fileManager enumeratorAtPath:self.diskPath];
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [self.diskPath stringByAppendingPathComponent:fileName];
            NSDictionary<NSString *, id> *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
            size += [attrs fileSize];
        }
    });
    return size;
}

- (NSUInteger)getDiskCount {
    __block NSUInteger count = 0;
    dispatch_sync(self.ioQueue, ^{
        NSDirectoryEnumerator *fileEnumerator = [self.fileManager enumeratorAtPath:self.diskPath];
        count = fileEnumerator.allObjects.count;
    });
    return count;
}

- (void)calculateSizeWithCompletionBlock:(nullable MNetworkCalculateSizeBlock)block {
    
    NSURL *diskCacheURL = [NSURL fileURLWithPath:self.diskPath isDirectory:YES];
    
    dispatch_async(self.ioQueue, ^{
        NSUInteger fileCount = 0;
        NSUInteger totalSize = 0;
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtURL:diskCacheURL
                                                   includingPropertiesForKeys:@[NSFileSize] options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                 errorHandler:NULL];
        
        for (NSURL *fileURL in fileEnumerator) {
            NSNumber *fileSize;
            [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
            totalSize += fileSize.unsignedIntegerValue;
            fileCount += 1;
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(fileCount, totalSize);
            });
        }
    });
}


#pragma mark - ===== private =====

- (NSString *)createStoreKeyWithCustomPath:(NSString *)path {
    return [path componentsSeparatedByString:@"/"].lastObject;
}

- (void)checkIfQueueIsIOQueue {
    const char *currentQueueLabel = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
    const char *ioQueueLabel = dispatch_queue_get_label(self.ioQueue);
    if (strcmp(currentQueueLabel, ioQueueLabel) != 0) {
        NSAssert(false, @"This method should be called from the ioQueue");
    }
}


#pragma mark - ===== dealloc =====

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLOG_DEALLOC
}

@end
