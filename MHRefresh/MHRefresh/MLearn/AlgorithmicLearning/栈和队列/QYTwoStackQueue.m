//
//  QYTwoStackQueue.m
//  MHRefresh
//
//  Created by panle on 2019/2/21.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYTwoStackQueue.h"

#import "QYStack.h"

@interface QYTwoStackQueue ()

@property (nonatomic, strong) QYStack *pushStack;
@property (nonatomic, strong) QYStack *popStack;

@end

@implementation QYTwoStackQueue

- (instancetype)init {
    if (self = [super init]) {
        _pushStack = [[QYStack alloc] init];
        _popStack = [[QYStack alloc] init];
    }
    return self;
}

- (void)qy_add:(id)obj {
    [_pushStack qy_push:obj];
}

- (id)qy_poll {
    
    if (_popStack.qy_isEmpty) {
        while (![_pushStack qy_isEmpty]) {
            [_popStack qy_push:[_pushStack qy_pop]];
        }
    }
    
    return _popStack.qy_pop;
}

- (void)qy_peek {
    
}

@end
