//
//  QYRecursionInvertedStack.m
//  MHRefresh
//
//  Created by panle on 2019/2/21.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYRecursionInvertedStack.h"

#import "QYStack.h"

@interface QYRecursionInvertedStack ()

@property (nonatomic, strong) QYStack *stack;

@end

@implementation QYRecursionInvertedStack

- (instancetype)init {
    if (self = [super init]) {
        _stack = [[QYStack alloc] init];
    }
    return self;
}

- (void)qy_startRecursionInverted {
    [_stack qy_printf];
    [self inveredWithStack:_stack];
    [_stack qy_printf];
}

//递归获取一个栈最底层的数据，但并不改变栈
- (id)getStackBottomObj:(QYStack *)stack {
    
    id obj = stack.qy_pop;
    
    if (stack.qy_isEmpty) {
        return obj;
    } else {
        id next = [self getStackBottomObj:stack];
        [stack qy_push:obj];
        return next;
    }
}

- (void)inveredWithStack:(QYStack *)stack {
    if (stack.qy_isEmpty) {
        return;
    }
    
    id obj = [self getStackBottomObj:stack];
    [self inveredWithStack:stack];
    [stack qy_push:obj];
}

#pragma mark - QYStackDelegate

- (void)qy_push:(id)obj {
    [_stack qy_push:obj];
}

- (nullable id)qy_pop {
    return [_stack qy_pop];
}

- (nullable id)qy_top {
    return [_stack qy_top];
}

- (BOOL)qy_isEmpty {
    return [_stack qy_isEmpty];
}

- (void)qy_printf {
    [_stack qy_printf];
}

@end
