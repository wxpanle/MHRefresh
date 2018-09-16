//
//  UPFileCenter.h
//  Up
//
//  Created by panle on 2018/4/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPFileCenter : NSObject

/**
 图片的目录

 @return NSString
 */
+ (NSString *)imageDirectory;

/**
 音频的目录
 
 @return NSString
 */
+ (NSString *)audioDirectory;

/**
 音频缓存目录

 @return NSString
 */
+ (NSString *)audioCacheDirectory;

/**
 离线卡包文件下载目录
 
 @return NSString
 */
+ (NSString *)fileDirectory;

/**
 视频路径

 @return NSString
 */
+ (NSString *)videoDirectory;

/**
 get 请求缓存目录

 @return NSString
 */
+ (NSString *)urlGetCacheDirectory;

/**
 oc对象缓存目录

 @return NSString
 */
+ (NSString *)objectCacheDirectory;


#pragma mark - ===== archive =====

/**
 打包文件路径

 @return NSString
 */
+ (NSString *)archiveDirectory;

#pragma mark - ===== save image =====

/**
 在当前线程同步存储图片

 @param image image
 @param key   key
 @param callBack callBack
 */
+ (void)syncStoreImage:(UIImage *)image
                   key:(NSString *)key
         callBackBlock:(UPDefDataBlock)callBack;

/**
 在当前线程存储图片二进制数据

 @param data data
 @param key  key
 @param block block
 */
+ (void)syncStoreImageData:(NSData *)data
                       key:(NSString *)key
             completeBlock:(UPDefDataBlock)block;

/**
 *  存储图片
 *
 *  @param image image
 *  @param key   key
 */
+ (void)storeImage:(UIImage *)image
           withKey:(NSString *)key
     completeBlock:(UPDefDataBlock)block;


#pragma mark - image
/**
 *  删除一组图片
 *
 *  @param keys key
 */
+ (void)deleteImagesWithKeySet:(NSSet *)keys;

/**
 *  删除图片
 *
 *  @param key key
 */
+ (void)deleteImageWithKey:(NSString *)key;

/**
 *  获得全部的图片的key
 *
 */
+ (NSArray *)getAllImageKey;


#pragma mark audio

/**
 *  删除一组音频
 *
 *  @param keys keys
 */
+ (void)deleteAudiosWithKeySet:(NSSet *)keys;

/**
 *  删除音频
 *
 *  @param key key
 */
+ (void)deleteAudioWithKey:(NSString *)key;

/**
 *  获得全部的图片的key
 *
 */
+ (NSArray *)getAllAudioKey;

#pragma mark - file

/**
 *  删除一组离线包
 *
 *  @param keys keys
 */
+ (void)deleteFilesWithKeySet:(NSSet *)keys;

/**
 *  删除离线包
 *
 *  @param key key
 */
+ (void)deleteFileWithKey:(NSString *)key;


/**
 *  获得全部的离线包的key
 *
 */
+ (NSArray *)getAllFileKey;


@end
