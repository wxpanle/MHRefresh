//
//  PLAudioStream.h
//  MHRefresh
//
//  Created by panle on 2018/3/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLAudioFileSource.h"
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioFile.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PLAudioStreamReadFileStatus) {
    PLASRFStatusSuccess,
    PLASRFStatusFail,
    PLASRFStatusFinished,
    PLASRFStatusWaiting
};

@class PLAudioStream, PLParsedAudioDataModel;

@protocol PLAudioStreamDataDelegate <NSObject>

@required
- (void)pl_audioFileStream:(PLAudioStream *)audioStream audioDataArray:(NSArray <PLParsedAudioDataModel *>*)audioDataArray;

@optional
- (void)pl_audioFileStreamReadyToProducePackets:(PLAudioStream *)audioStream;

@end

@class PLFileProvider;

@interface PLAudioStream : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (nullable instancetype)initWithAudioFileSource:(nonnull id <PLAudioFileSource>)audioFileSource;
- (nullable instancetype)initWithAudioFileProvider:(nonnull PLFileProvider *)fileProvider NS_DESIGNATED_INITIALIZER;

@property (nonatomic, weak) id <PLAudioStreamDataDelegate> delegate;

@property (nonatomic, readonly) PLFileProvider *fileProvider;
@property (nonatomic, assign, readonly) AudioFileTypeID fileType;

///------------------------------
/// @name subclass overwrite
///------------------------------
@property (nonatomic, assign, readonly) AudioStreamBasicDescription audioFormat;

@property (nonatomic, assign, readonly, getter=isAvaiable) BOOL available;

@property (nonatomic, assign, readonly) UInt32 bitRate;
@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign, readonly) UInt32 maxPacketSize;
@property (nonatomic, assign, readonly) UInt64 audioDataByteCount;

@property (nonatomic, assign, readonly, getter=isReadyToProducePackets) BOOL readyToProducePackets;

- (PLAudioStreamReadFileStatus)readData;
- (nullable NSData *)fetchMagicCookie;
- (SInt64)seekTime:(NSTimeInterval)time;
- (BOOL)open;
- (void)close;

@end

NS_ASSUME_NONNULL_END
