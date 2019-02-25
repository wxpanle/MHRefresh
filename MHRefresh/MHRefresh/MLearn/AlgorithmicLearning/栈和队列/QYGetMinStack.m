//
//  QYGetMinStack.m
//  MHRefresh
//
//  Created by panle on 2019/2/21.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYGetMinStack.h"
#import "QYStack.h"

@interface QYGetMinStack ()

@property (nonatomic, strong) QYStack *pushStack;
@property (nonatomic, strong) QYStack *popStack;

@end

@implementation QYGetMinStack

- (instancetype)init {
    if (self = [super init]) {
        _pushStack = [[QYStack alloc] init];
        _popStack = [[QYStack alloc] init];
    }
    return self;
}

#pragma mark - QYStackDelegate

- (void)qy_push:(id)obj {
    [_pushStack qy_push:obj];
    
    if ([_popStack qy_isEmpty]) {
        [_popStack qy_push:obj];
    } else {
        if ([obj integerValue] <= [[_popStack qy_top] integerValue]) {
            [_popStack qy_push:obj];
        } else {
            [_popStack qy_push:@([[_popStack qy_top] integerValue])];
        }
    }
}

- (nullable id)qy_pop {
    [_popStack qy_pop];
    return [_pushStack qy_pop];
}

- (nullable id)qy_top {
    return [_pushStack qy_top];
}

- (BOOL)qy_isEmpty {
    return [_pushStack qy_isEmpty];
}

- (void)qy_printf {
    NSLog(@"------");
    [_pushStack qy_printf];
    NSLog(@"------");
    [_popStack qy_printf];
    NSLog(@"------");
}

- (void)qy_prinftMin {
    NSLog(@"%@", [_popStack qy_top].stringValue);
}

@end
