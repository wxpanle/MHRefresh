//
//  QYSoft.m
//  MHRefresh
//
//  Created by panle on 2018/9/10.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYSoft.h"

@interface QYSoft () {
    CFAbsoluteTime _time;
}

@end

@implementation QYSoft

- (void)start {
    
}

- (NSArray *)qy_softArray {
    return @[@2, @1, @9, @8, @4, @7, @6, @5, @3];
}

- (void)qy_insertTime {
    _time = CFAbsoluteTimeGetCurrent();
}

- (void)qy_endTime {
    NSLog(@"%f", CFAbsoluteTimeGetCurrent() - _time);
}

- (void)qy_swap:(int *)nums left:(int)i right:(int)j {
    int temp = nums[i];
    nums[i] = nums[j];
    nums[j] = temp;
}

- (void)qy_printf:(int *)nums count:(int)count {
    NSLog(@"---------------------------");
    for (int i = 0; i < count; i++) {
        NSLog(@"%d", nums[i]);
    }
    NSLog(@"---------------------------");
}

@end
