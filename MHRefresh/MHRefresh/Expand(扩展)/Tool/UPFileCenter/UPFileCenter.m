//
//  UPFileCenter.m
//  Up
//
//  Created by panle on 2018/4/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPFileCenter.h"
#import "MGifDataCache.h"

@implementation UPFileCenter

+ (NSString *)imageDirectory {
    
    NSString *string = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"UPCache"] stringByAppendingPathComponent:@"Image"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:string]) {
            [manager createDirectoryAtPath:string withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return string;
}

+ (NSString *)audioDirectory {
    
    NSString *string = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"UPCache"] stringByAppendingPathComponent:@"Audio"];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:string]) {
            [manager createDirectoryAtPath:string withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    
    return string;
}

+ (NSString *)audioCacheDirectory {
    
    NSString *string = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"UPCache"] stringByAppendingPathComponent:@"AudioCache"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:string]) {
            [manager createDirectoryAtPath:string withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });

    return string;
}

+ (NSString *)fileDirectory {
    
    NSString *string = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"UPCache"] stringByAppendingPathComponent:@"File"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:string]) {
            [manager createDirectoryAtPath:string withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    
    return string;
}

+ (NSString *)videoDirectory {
    
    NSString *string = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"UPCache"] stringByAppendingPathComponent:@"Video"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:string]) {
            [manager createDirectoryAtPath:string withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return string;
}

+ (NSString *)urlGetCacheDirectory {
    
    NSString *string = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"UPCache"] stringByAppendingPathComponent:@"Url"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:string]) {
            [manager createDirectoryAtPath:string withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return string;
}

+ (NSString *)objectCacheDirectory {
    
    NSString *string = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"UPCache"] stringByAppendingPathComponent:@"Obj"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:string]) {
            [manager createDirectoryAtPath:string withIntermediateDirectories:YES attributes:nil error:nil];
        }
    });
    return string;
}


#pragma mark - ===== archive =====

+ (NSString *)archiveDirectory {
    
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Archiver"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
}

#pragma mark - ===== save image =====

+ (void)syncStoreImage:(UIImage *)image key:(NSString *)key callBackBlock:(UPDefDataBlock)callBack {
    NSData *data = [[MGifDataCache sharedGifDataCache] dataForImage:image];
    if (!data) {
//        data = [image dataWithMaxLength:UPPictureMaxLength];
    }
    [self syncStoreImageData:data key:key completeBlock:^(NSData *data) {
        [[MGifDataCache sharedGifDataCache] clearCacheForImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callBack) {
                callBack(data);
            }
        });
    }];
}

+ (void)syncStoreImageData:(NSData *)data
                       key:(NSString *)key
             completeBlock:(UPDefDataBlock)block {
    
    NSFileManager *manager = [NSFileManager defaultManager];
//    [manager createFileAtPath:[key imagePath] contents:data attributes:nil];
    if (block) {
        block(data);
    }
}

+ (void)storeImage:(UIImage *)image withKey:(NSString *)key completeBlock:(UPDefDataBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = UIImageJPEGRepresentation(image, 1);
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:[self imageDirectory]]) {
            [manager createDirectoryAtPath:[self imageDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
//        [manager createFileAtPath:[key imagePath] contents:data attributes:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(data);
            }
        });
        
    });
}


#pragma mark - ======== image ========

+ (void)deleteImageWithKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self deleteImagesWithKeySet:[NSSet setWithObject:key]];
}

+ (void)deleteImagesWithKeySet:(NSSet *)keys {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *key in keys) {
            if (!key) {
                continue;
            }
//            [[NSFileManager defaultManager] removeItemAtPath:[key imagePath] error:nil];
        }
    });
}

+ (NSArray *)getAllImageKey {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self imageDirectory] error:nil];
}


#pragma mark - ======== audio ========

+ (void)deleteAudioWithKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self deleteAudiosWithKeySet:[NSSet setWithObject:key]];
}

+ (void)deleteAudiosWithKeySet:(NSSet *)keys {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *key in keys) {
            if (!key) {
                continue;
            }
//            [[NSFileManager defaultManager] removeItemAtPath:[key audioPath] error:nil];
        }
    });
}

+ (NSArray *)getAllAudioKey {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self audioDirectory] error:nil];
}

#pragma mark - ======== file ========

+ (void)deleteFileWithKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self deleteFilesWithKeySet:[NSSet setWithObject:key]];
}

+ (void)deleteFilesWithKeySet:(NSSet *)keys {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSString *key in keys) {
            if (!key) {
                continue;
            }
//            [[NSFileManager defaultManager] removeItemAtPath:[key filePath] error:nil];
        }
    });
}

+ (NSArray *)getAllFileKey {
    return [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self fileDirectory] error:nil];
}

@end
