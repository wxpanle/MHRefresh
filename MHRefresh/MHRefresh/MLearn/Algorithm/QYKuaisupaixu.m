//
//  QYKuaisupaixu.m
//  MHRefresh
//
//  Created by panle on 2018/12/12.
//  Copyright © 2018 developer. All rights reserved.
//

#import "QYKuaisupaixu.h"
#import "QYStack.h"

@implementation QYKuaisupaixu

- (void)start {
    [self kuaisupaixudigui];
    [self p_search];
}

- (void)kuaisupaixudigui {
    
    int num[9] = {2,1,4,3,5,7,8,6,9};
    
    [self digui:num start:0 end:8];
    
    [self qy_printf:num count:9];
}

- (void)digui:(int [])num start:(int)start end:(int)end {
    
    if (start > end) {
        return;
    }
    
    int mid = [self partition:num start:start end:end];
    
    [self digui:num start:start end:mid - 1];
    [self digui:num start:mid + 1 end:end];
}

- (int)partition:(int [])num start:(int)start end:(int)end {
    
    if (start == end) {
        return start;
    }

    int index = num[start];
    
    while (start < end) {
        
        while (start < end && num[end] >= index) {
            end--;
        }
        
        if (start == end) {
            break;
        }
        
        [self qy_swap:num left:start right:end];
        
        while (start < end && num[start] <= index) {
            start++;
        }
        
        if (start == end) {
            break;
        }
        [self qy_swap:num left:start right:end];
    }
    
    return start;
}

- (void)p_search
{
    int num[9] = {2,1,4,3,5,7,8,6,9};
    
    QYStack *stack = [[QYStack alloc] init];
    [self p_searchWith:num start:0 stack:stack];
}

- (void)p_searchWith:(int [])nums start:(int)start stack:(QYStack *)stack
{
    static int sums = 0;
    static int T = 10;
    
    if (sums == T) { //递归终止条件
        [stack qy_printf];
        [stack printfNewLine];
        return;
    }
    
    if (sums > T) {  //递归终止条件
        return;
    }
    
    for (int i = start; i < 9; i++) {
        
        if (sums + nums[start] <= T) {
            [stack qy_push:@(nums[i])];
            sums += nums[i];
            
            [self p_searchWith:nums start:i + 1 stack:stack];
            sums -= [[stack qy_pop] intValue];
        }
    }
    
}

@end
