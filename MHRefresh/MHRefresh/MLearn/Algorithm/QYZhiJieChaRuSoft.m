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
    
    int nums[5] = {5,3,4,6,2};
    int index = 0;
    for (int i = 1; i < 5; i++) {
        
        if (nums[i] < nums[i - 1]) {
            //需要向前插入排序
            index = nums[i];
            int j;
            for (j = i - 1; index < nums[j] && j >= 0; j--) {
                nums[j + 1] = nums[j];  //空间内进行交换 减少空间使用’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’‘’
            }
            nums[++j] = index;
        }
    }
    
    [self qy_printf:nums count:5];
}

- (void)p_xierpaixu {
    //             0  1  2  3  4  5  6  7  8
    int nums[9] = {9, 1, 5, 8, 3, 7, 4, 6, 2};
    
    int space = 9;
    int index = 0;
    while (space >= 1) {
        //取间距
        space = space / 3 + 1;
        for (int i = space; i < 9; i++) {
            if (nums[i] < nums[i - space]) {
                //交换
                index = nums[i];
                int j = 0;
                for (j = i - space; j >= 0 && index < nums[j]; j -= space) {
                    nums[j+space] = nums[j];
                }
                j += space;
                nums[j] = index;
            }
        }
        
        if (space == 1) {
            break;
        }
    }
    
    [self qy_printf:nums count:9];
}

@end
