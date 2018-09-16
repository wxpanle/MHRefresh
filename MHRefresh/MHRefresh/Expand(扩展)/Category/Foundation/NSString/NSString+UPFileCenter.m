//
//  NSString+UPFileCenter.m
//  Up
//
//  Created by panle on 2018/4/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "NSString+UPFileCenter.h"
#import "UPFileCenter.h"

@implementation NSString (UPFileCenter)

- (NSString *)imagePath {
    return [[UPFileCenter imageDirectory] stringByAppendingPathComponent:self];
}

- (NSString *)audioPath {
    return [[UPFileCenter audioDirectory] stringByAppendingPathComponent:self];
}

- (NSString *)filePath {
    return [[UPFileCenter fileDirectory] stringByAppendingPathComponent:self];
}

- (NSString *)audioCachePath {
    return [[UPFileCenter audioCacheDirectory] stringByAppendingPathComponent:self];
}

- (NSString *)urlGetCachePath {
    return [[UPFileCenter urlGetCacheDirectory] stringByAppendingPathComponent:self];
}

- (NSString *)objectCachePath {
    return [[UPFileCenter objectCacheDirectory] stringByAppendingPathComponent:self];
}

- (BOOL)audioDownloaded {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self audioPath]]) {
        return NO;
    }
    return YES;
}

@end
