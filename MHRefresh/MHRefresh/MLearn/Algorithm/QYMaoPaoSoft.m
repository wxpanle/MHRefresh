//
//  QYMaoPaoSoft.m
//  MHRefresh
//
//  Created by panle on 2018/11/28.
//  Copyright © 2018 developer. All rights reserved.
//

#import "QYMaoPaoSoft.h"

@implementation QYMaoPaoSoft

/*
 逐次比较交换数据顺序
 */

- (void)start {
    [self p_maopao1];
    [self p_maopao2];
    [self p_maopao3];
}

- (void)p_maopao1 {
    int nums[90] = {9, 1, 5, 8, 3};
    
    [self qy_insertTime];
    
    for (int i = 0; i < 5; i++) {
        for (int j = i + 1; j < 5; j++) {
            if (nums[i] > nums[j]) {
                [self qy_swap:nums left:i right:j];
            }
        }
    }
    
    [self qy_endTime];
    [self qy_printf:nums count:90];
}

- (void)p_maopao2 {
    int nums[90] = {9, 1, 5, 8, 3};
    
    [self qy_insertTime];
    
    for (int i = 0; i < 5; i++) {
        for (int j = 5 - 1 - 1; j >= i; j--) {
            if (nums[j] < nums[j + 1]) {
                [self qy_swap:nums left:j right:j + 1];
            }
        }
    }
    
    [self qy_endTime];
    [self qy_printf:nums count:90];
}

- (void)p_maopao3 {
    int nums[90] = {9, 1, 5, 8, 3};
    
    [self qy_insertTime];
    
    BOOL flag = YES;
    
    for (int i = 0; i < 5 && flag == YES; i++) {
        flag = NO;
        for (int j = 5 - 1 - 1; j >= i; j--) {
            if (nums[j] < nums[j + 1]) {
                [self qy_swap:nums left:j right:j + 1];
                flag = YES;
            }
        }
    }
    
    [self qy_endTime];
    [self qy_printf:nums count:90];
}

@end
