//
//  QYAudioBuffer.m
//  MHRefresh
//
//  Created by panle on 2018/3/1.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYAudioBuffer.h"
#import "QYParsedAudioData.h"

@interface QYAudioBuffer ()

@property (nonatomic, strong) NSMutableArray *bufferBlockArray;

@property (nonatomic, assign) UInt32 bufferedSize;

@end

@implementation QYAudioBuffer

+ (instancetype)buffer {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _bufferBlockArray = [[NSMutableArray alloc] init];
        _bufferedSize = 0;
    }
    return self;
}

- (BOOL)hasData {
    return _bufferBlockArray.count > 0;
}

- (UInt32)bufferedSize {
    return _bufferedSize;
}

- (void)enqueueData:(QYParsedAudioData *)data {
    if ([data isKindOfClass:[QYParsedAudioData class]]) {
        [_bufferBlockArray addObject:data];
        _bufferedSize += data.data.length;
    }
}

- (void)enqueueFromDataArray:(NSArray *)dataArray {
    for (QYParsedAudioData *data in dataArray) {
        [self enqueueData:data];
    }
}

- (NSData *)dequeueDataWithSize:(UInt32)requestSize packetCount:(UInt32 *)packetCount descriptions:(AudioStreamPacketDescription **)descriptions {
    
    if (requestSize == 0 && _bufferBlockArray.count == 0) {
        return nil;
    }
    
    SInt64 size = requestSize;
    
    int i = 0;
    for (i = 0; i < _bufferBlockArray.count; i++) {
        QYParsedAudioData *data = _bufferBlockArray[i];
        SInt64 dataLength = [data.data length];  //有符号64位整形变量
        if (size > dataLength) {
            size -= dataLength;
        } else {
            if (size < dataLength) {
                i--;
                break;
            }
        }
    }
    
    if (i < 0) {
        return nil;
    }
    
    UInt32 count = (i > _bufferBlockArray.count) ? (UInt32)_bufferBlockArray.count : (i + 1);
    *packetCount = count;
    if (count == 0) {
        return nil;
    }
    
    if (descriptions != NULL) { //开辟字节变量
        *descriptions = (AudioStreamPacketDescription *)malloc(sizeof(AudioStreamPacketDescription) * count);
    }
    
    NSMutableData *retData = [[NSMutableData alloc] init];
    
    for (int j = 0; j < count; j++) {
        QYParsedAudioData *data = _bufferBlockArray[j];
        if (descriptions != NULL) {
            AudioStreamPacketDescription desc = data.packetDescription;
            desc.mStartOffset = [retData length];
            (*descriptions)[j] = desc;
        }
        [retData appendData:data.data];
    }
    
    NSRange removeRange = NSMakeRange(0, count);
    [_bufferBlockArray removeObjectsInRange:removeRange];
    
    _bufferedSize -= retData.length;
    
    return retData;
}

- (void)clean {
    _bufferedSize = 0;
    [_bufferBlockArray removeAllObjects];
}

#pragma mark - ======== dealloc ========

- (void)dealloc {
    [_bufferBlockArray removeAllObjects];
    DLOG_DEALLOC
}

@end
