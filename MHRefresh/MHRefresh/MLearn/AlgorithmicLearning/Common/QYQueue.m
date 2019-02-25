
//
//  QYQueue.m
//  MHRefresh
//
//  Created by panle on 2019/2/21.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYQueue.h"

@interface QYQueue ()

@property (nonatomic, strong) NSMutableArray <NSNumber *>*dataArray;

@end

@implementation QYQueue

- (void)qy_push:(NSNumber *)obj {
    [self.dataArray addObject:obj];
}

- (nullable NSNumber *)qy_pop {
    
    if ([self qy_isEmpty]) {
        return nil;;
    }
    
    id obj = [self.dataArray firstObject];
    [self.dataArray removeObjectAtIndex:0];
    return obj;
}

- (BOOL)qy_isEmpty {
    return [_dataArray count] == 0;
}

- (void)qy_printf {
    for (NSNumber *number in _dataArray) {
        NSLog(@"%@", number.stringValue);
    }
}

#pragma mark - getter

- (NSMutableArray <NSNumber *>*)dataArray {
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
