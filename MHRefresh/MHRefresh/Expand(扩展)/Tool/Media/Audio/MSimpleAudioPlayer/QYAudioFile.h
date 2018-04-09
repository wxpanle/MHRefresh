//
//  QYAudioFile.h
//  MHRefresh
//
//  Created by panle on 2018/3/1.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioFile.h>

@interface QYAudioFile : NSObject

@property (nonatomic, copy, readonly) NSString *filePath;
@property (nonatomic, assign, readonly) AudioFileTypeID fileType;

@property (nonatomic, assign, readonly) BOOL available;

@property (nonatomic, assign, readonly) AudioStreamBasicDescription format;
@property (nonatomic, assign, readonly) UInt64 fileSize;
@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign, readonly) UInt32 bitRate;
@property (nonatomic, assign, readonly) UInt32 maxPacketSize;
@property (nonatomic, assign, readonly) UInt64 audioDataByteCount;

- (instancetype)initWithFilePath:(NSString *)filePath fileType:(AudioFileTypeID)fileType;
- (NSArray *)parseData:(BOOL *)isEof;
- (NSData *)fetchMagicCookie;
- (void)seekToTime:(NSTimeInterval)time;
- (void)close;

@end
