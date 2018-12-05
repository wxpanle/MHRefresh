//
//  QYXuanZeSoft.m
//  MHRefresh
//
//  Created by panle on 2018/11/28.
//  Copyright © 2018 developer. All rights reserved.
//

#import "QYXuanZeSoft.h"

@implementation QYXuanZeSoft

- (void)start {
    [self xuanze1];
}

- (void)xuanze1 {
    int nums[9] = {9, 1, 5, 8, 3, 7, 4, 6, 2};
    
    [self qy_insertTime];
    
    int min = 0;
    for (int i = 0; i < 9; i++) {
        min = i;
        for (int j = i; j < 9; j++) {
            if (nums[min] < nums[j]) {
                min = j;
            }
        }
        if (i != min) {
            [self qy_swap:nums left:i right:min];
        }
    }
    
    [self qy_endTime];
    [self qy_printf:nums count:9];
}

@end
