//
//  QYZhiJieChaRuSoft.m
//  MHRefresh
//
//  Created by panle on 2018/12/4.
//  Copyright © 2018 developer. All rights reserved.
//

#import "QYZhiJieChaRuSoft.h"

@implementation QYZhiJieChaRuSoft

- (void)start {
    [self p_zhijiepaixu1];
    [self p_xierpaixu];
}

- (void)p_zhijiepaixu1 {
    
    int nums[15] = {9, 1, 5, 8, 3, 7, 4, 6, 2, 4, 6, 2, 0, 0 , 0};
    
    NSInteger n = 0;
    
    for (NSInteger i = 1; i < 15; i++) {
        if (nums[i - 1] > nums[i]) {
            
            int temp = nums[i];
            NSInteger j = i - 1;
            for (; temp < nums[j] && j >= 0; j--) {
                nums[j + 1] = nums[j];
            }
            nums[++j] = temp;
        }
    }
    
    [self qy_printf:nums count:15];
    NSLog(@"n = %ld", n);
}

- (void)p_xierpaixu
{
    int nums[15] = {9, 1, 5, 8, 3, 7, 4, 6, 2, 4, 6, 2, 0, 0, 0};
    
    int space = 15;
    NSInteger n = 0;
    while (space > 1) {
        
        //设定间隔值
        space /= 3;
        n++;
        
        for (NSInteger i = space; i < 15; i++) {
            //主循环 从头开始
            n++;
            if (nums[i] < nums[i - space]) {  //判断是否需要进行交换
                n++;
                //进行交换
                int index = nums[i];
                NSInteger j = i - space;
                for (; j >= 0 && index < nums[j]; j -= space) {
                    nums[j + space] = nums[j];
                    n++;
                }
                
                nums[j + space] = index;
            }
            
        }
        
    }
    
    [self qy_printf:nums count:15];
    NSLog(@"n = %ld", n);
}

@end
