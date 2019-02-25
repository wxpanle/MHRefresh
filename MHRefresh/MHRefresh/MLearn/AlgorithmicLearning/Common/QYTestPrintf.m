//
//  QYTestPrintf.m
//  MHRefresh
//
//  Created by panle on 2019/2/21.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYTestPrintf.h"

#import "QYGetMinStack.h"
#import "QYTwoStackQueue.h"
#import "QYRecursionInvertedStack.h"

@interface QYTestPrintf ()

@end

@implementation QYTestPrintf

- (void)qy_test {
    [self qy_testGetMinStack];
    [self qy_testTwoStackQueue];
    [self qy_testRecursionInvertedStack];
}

#pragma mark - 栈和队列

- (void)qy_testGetMinStack {
    
    QYGetMinStack *minStack = [[QYGetMinStack alloc] init];
    
    [minStack qy_push:@(3)];
    [minStack qy_push:@(4)];
    [minStack qy_push:@(5)];
    [minStack qy_push:@(1)];
    [minStack qy_push:@(1)];
    [minStack qy_push:@(1)];
    [minStack qy_push:@(10)];
    
    [minStack qy_printf];
    
    while (![minStack qy_isEmpty]) {
        [minStack qy_prinftMin];
        [minStack qy_pop];
    }
}

- (void)qy_testTwoStackQueue {}

- (void)qy_testRecursionInvertedStack {
    QYRecursionInvertedStack *stack = [[QYRecursionInvertedStack alloc] init];
    [stack qy_push:@(1)];
    [stack qy_push:@(2)];
    [stack qy_push:@(3)];
//    [stack qy_push:@(4)];
//    [stack qy_push:@(5)];
//    [stack qy_push:@(6)];
    [stack qy_startRecursionInverted];
}

@end
