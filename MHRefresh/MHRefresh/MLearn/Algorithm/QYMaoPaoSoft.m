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
    [self p_outputSuShu];
}

- (void)p_maopao1 {
    
    int nums[9] = {9, 1, 5, 8, 3, 7, 4, 6, 2};
    
    for (NSInteger i = 0; i < 9; i++) {
        
        for (NSInteger j = i + 1; j < 9; j++) {
            
            if (nums[i] > nums[j]) {
                [self qy_swap:nums left:i right:j];
            }
        }
    }
    
    [self qy_printf:nums count:9];
}

- (void)p_maopao2 {
    int nums[9] = {9, 1, 5, 8, 3, 7, 4, 6, 2};
    
    for (NSInteger i = 0; i < 9; i++) {
        for (NSInteger j = 9 - 1 - 1; j >= i; j--) {
            if (nums[j] > nums[j + 1]) {
                [self qy_swap:nums left:j right:j + 1];
            }
        }
    }
    [self qy_printf:nums count:9];
}

- (void)p_maopao3 {
    int nums[9] = {9, 1, 5, 8, 3, 7, 4, 6, 2};
    
    
    BOOL flag = YES;
    
    for (NSInteger i = 0; i < 9 && flag; i++) {
        flag = NO;
        for (NSInteger j = 9 - 1 - 1; j >= i; j--) {
            if (nums[j] > nums[j + 1]) {
                [self qy_swap:nums left:j right:j + 1];
                flag = YES;
            }
        }
    }
    
    [self qy_printf:nums count:9];
}

- (void)p_outputSuShu
{
    for (int i = 2; i <= 100; i++) {
        if ([self p_isSuShu:i]) {
            NSLog(@"%ld", (long)i);
        }
    }
}

- (BOOL)p_isSuShu:(int)number
{
    for (NSInteger i = 2; i < sqrtf(number); i++) {
        if (number % i == 0) {
            return NO;
        }
    }
    return YES;
}

@end
