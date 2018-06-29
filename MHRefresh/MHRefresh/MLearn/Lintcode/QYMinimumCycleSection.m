//
//  QYMinimumCycleSection.m
//  MHRefresh
//
//  Created by panle on 2018/5/10.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYMinimumCycleSection.h"

/**
 给出一个int的数组 array, 求这个数组的最小循环节的长度。
 
 思路点拨
 可以考虑使用双指针(L,R)，并开一个变量记录len当前的循环节，由于循环节肯定是从第一位开始，所以用L记录当前匹配到的位置，R一直往后移动，如果当前位不匹配，那么L就重置，len就加1。整体复杂度O(n)
 
 考点分析
 这题是双指针类型的变形，如果发现了循环节每次都是从第一个数开始这一个性质，那么就可以根据这个性质设计出对应的双指针做法，不过在细节上还需要仔细的斟酌一下。
 

 */

@implementation QYMinimumCycleSection

- (void)qy_lintcodeSolution {
    
    [self minimunCycleSection:@[@1, @2, @1, @3, @4, @5, @1]];
    [self minimunCycleSection:@[@1, @2, @6, @3, @4, @5, @1]];
    [self minimunCycleSection:@[@1, @2, @6, @3, @6, @5, @1]];
}

- (void)minimunCycleSection:(NSArray *)array {
    
    NSInteger ans = 1;
    
    NSInteger left = 0, right = 1;
    
    while (right < array.count) {
        
        if (array[left] == array[right]) {
            left ++;
            right++;
        } else {
            left = 0;
            ans = right;
            
            if (array[left] != array[right]) {
                right++;
                ans = right;
            }
        }
    }
    
    DLog(@"ans %ld", ans);
}

@end
