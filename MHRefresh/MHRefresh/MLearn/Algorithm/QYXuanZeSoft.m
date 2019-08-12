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
    
    for (NSInteger i = 0; i < 9; i++) {
        
        NSInteger min = i;
        
        for (NSInteger j = i + 1; j < 9; j++) {
            
            if (nums[j] < nums[min]) {
                min = j;
            }
        }
        
        if (min != i) {
            [self qy_swap:nums left:i right:min];
        }
    }
    
    [self qy_printf:nums count:9];
}


@end
