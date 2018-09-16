//
//  NSString+UPFileCenter.h
//  Up
//
//  Created by panle on 2018/4/9.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UPFileCenter)

- (NSString *)imagePath;
- (NSString *)audioPath;
- (NSString *)filePath;
- (NSString *)audioCachePath;
- (NSString *)urlGetCachePath;
- (NSString *)objectCachePath;

- (BOOL)audioDownloaded;

@end
