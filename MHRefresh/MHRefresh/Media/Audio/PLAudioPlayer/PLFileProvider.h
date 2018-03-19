//
//  PLFileProvider.h
//  MHRefresh
//
//  Created by panle on 2018/3/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLAudioFileSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface PLFileProvider : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)fileProviderWithAudioFileSource:(id <PLAudioFileSource>)aduioFileSource;

@property (nullable, nonatomic, readonly) id <PLAudioFileSource> audioFileSource;

/** local filePath or downloadPath */
@property (nullable, nonatomic, readonly) NSString *cachePath;
@property (nullable, nonatomic, readonly) NSURL *cachedURL;

@property (nonatomic, assign, readonly) unsigned long long expectedLength;
@property (nonatomic, assign, readonly) unsigned long long receivedLength;

@property (nullable, nonatomic, readonly) NSString *mimeType;
@property (nullable, nonatomic, readonly) NSString *fileExtension;
@property (nonatomic, readonly) UInt32 fileType;

@property (nonatomic, readonly) CGFloat downloadProgress;

@property (nonatomic, readonly, assign, getter=isFailed) BOOL failed;
@property (nonatomic, readonly, assign, getter=isFinished) BOOL finished;
@property (nonatomic, readonly, assign, getter=isReady) BOOL ready;

- (nullable NSData *)readDataAtOffset:(SInt64)inPosition length:(UInt32)length;

@end

NS_ASSUME_NONNULL_END
