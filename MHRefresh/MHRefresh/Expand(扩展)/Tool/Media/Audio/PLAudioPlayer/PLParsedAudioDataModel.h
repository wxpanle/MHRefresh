//
//  PLParsedAudioDataModel.h
//  MHRefresh
//
//  Created by panle on 2018/3/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreAudio/CoreAudioTypes.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLParsedAudioDataModel : NSObject

@property (nonatomic, readonly) NSData *data;

@property (nonatomic, readonly) AudioStreamPacketDescription packetDescription;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (nullable instancetype)initWithParsedAudioDataWithBytes:(const void *)bytes
                               packetDescription:(AudioStreamPacketDescription)packetDescription;

@end

NS_ASSUME_NONNULL_END
