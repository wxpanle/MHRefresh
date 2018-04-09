//
//  PLAudioBuffer.m
//  MHRefresh
//
//  Created by panle on 2018/3/14.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "PLAudioBuffer.h"
#import "PLParsedAudioDataModel.h"

@interface PLAudioBuffer () {
    NSMutableArray *_bufferArray;
    UInt32 _bufferedSize;
}

@end

@implementation PLAudioBuffer

+ (instancetype)audioBuffer {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _bufferArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSData *)dequeueDataWithSize:(UInt32)requestSize
                    packetCount:(UInt32 *)packetCount
                   descriptions:(AudioStreamPacketDescription **)descriptions {
    
    if (requestSize == 0 ||
        _bufferArray.count == 0) {
        return nil;
    }
    
    SInt64 size = requestSize;
    
    int i = 0;
    for (i = 0; i < _bufferArray.count; i++) {
        PLParsedAudioDataModel *model = _bufferArray[i];
        SInt64 dataLength = [model.data length];
        
        if (size > dataLength) {
            size -= dataLength;
        } else {
            if (size < dataLength) {
                i--;
            }
            break;
        }
    }
    
    if (i < 0) {
        return nil;
    }
    
    UInt32 count = (i >= _bufferArray.count) ? (UInt32)_bufferArray.count : (i + 1);
    
    *packetCount = count;
    
    if (count == 0) {
        return nil;
    }
    
    if (descriptions != NULL) {
        *descriptions = *descriptions = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription) * count);
    }
    
    NSMutableData *resultData = [[NSMutableData alloc] init];
    for (int j = 0; j < count; j++) {
        
        PLParsedAudioDataModel *model = _bufferArray[j];
        
        if (descriptions != NULL) {
            AudioStreamPacketDescription desc = model.packetDescription;
            desc.mStartOffset = [resultData length];
            (*descriptions)[j] = desc;
        }
        [resultData appendData:model.data];
    }
    
    [_bufferArray removeObjectsInRange:NSMakeRange(0, count)];
    
    _bufferedSize -= resultData.length;
    
    return resultData;
}

- (void)enqueueDataModel:(PLParsedAudioDataModel *)dataModel {
    
    if ([dataModel isKindOfClass:[PLParsedAudioDataModel class]]) {
        [_bufferArray addObject:dataModel];
        _bufferedSize += dataModel.data.length;
    }
}

- (void)enqueueDataModelArray:(NSArray <PLParsedAudioDataModel *>*)dataModelArray {
    for (PLParsedAudioDataModel *dataModel in dataModelArray) {
        [self enqueueDataModel:dataModel];
    }
}

- (BOOL)hasData {
    return _bufferArray.count != 0;
}

- (UInt32)bufferedSize {
    return _bufferedSize;
}

- (void)reset {
    [_bufferArray removeAllObjects];
    _bufferedSize = 0;
    _end = NO;
}

- (void)dealloc {
    [_bufferArray removeAllObjects];
    _bufferArray = nil;
    DLOG_DEALLOC
}

@end
