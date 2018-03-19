//
//  PLParsedAudioDataModel.m
//  MHRefresh
//
//  Created by panle on 2018/3/8.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLParsedAudioDataModel.h"

@interface PLParsedAudioDataModel ()

@property (nonatomic, readwrite, strong) NSData *data;

@property (nonatomic, readwrite, assign) AudioStreamPacketDescription packetDescription;

@end

@implementation PLParsedAudioDataModel

+ (instancetype)initWithParsedAudioDataWithBytes:(const void *)bytes
                               packetDescription:(AudioStreamPacketDescription)packetDescription {
    if (bytes == NULL || packetDescription.mDataByteSize == 0) {
        return nil;
    }
    
    return [[self alloc] initWithBytes:bytes packetDescription:packetDescription];
}

- (instancetype)initWithBytes:(const void *)bytes
            packetDescription:(AudioStreamPacketDescription)packetDescription {
    
    if (self = [super init]) {
        _data = [NSData dataWithBytes:bytes length:packetDescription.mDataByteSize];
        _packetDescription = packetDescription;
    }
    
    return self;
}


@end
