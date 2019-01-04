//
//  QYKuaisupaixu.m
//  MHRefresh
//
//  Created by panle on 2018/12/12.
//  Copyright © 2018 developer. All rights reserved.
//

#import "QYKuaisupaixu.h"

@implementation QYKuaisupaixu

- (void)start {
    [self kuaisupaixudigui];
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
        
        while (start < end && num[end] <= index) {
            end--;
        }
        
        [self qy_swap:num left:start right:end];
        
        while (start < end && num[start] >= index) {
            start++;
        }
        
        if (start == end) {
            break;
        }
        [self qy_swap:num left:start right:end];
    }
    
    return start;
}

@end
