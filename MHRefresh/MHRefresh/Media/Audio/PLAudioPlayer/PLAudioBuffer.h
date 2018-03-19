//
//  PLAudioBuffer.h
//  MHRefresh
//
//  Created by panle on 2018/3/14.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@class PLParsedAudioDataModel;

@interface PLAudioBuffer : NSObject

@property (nonatomic, assign, getter=isEnd) BOOL end;

+ (instancetype)audioBuffer;

- (NSData *)dequeueDataWithSize:(UInt32)requestSize
                    packetCount:(UInt32 *)packetCount
                   descriptions:(AudioStreamPacketDescription **)descriptions;

- (void)enqueueDataModel:(PLParsedAudioDataModel *)dataModel;
- (void)enqueueDataModelArray:(NSArray <PLParsedAudioDataModel *>*)dataModelArray;

- (BOOL)hasData;
- (UInt32)bufferedSize;

- (void)reset;

@end
