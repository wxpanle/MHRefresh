//
//  QYGuiBingSoft.m
//  MHRefresh
//
//  Created by panle on 2018/12/6.
//  Copyright © 2018 developer. All rights reserved.
//

#import "QYGuiBingSoft.h"

@implementation QYGuiBingSoft

- (void)start {
    [self guibingpaixudigui];
    [self guibingpaixunodigui];
}

#pragma mark - 归并排序非递归

- (void)guibingpaixunodigui {
    
    //              0  1  2  3  4  5  6  7  8
    int nums1[8] = {9, 1, 5, 8, 3, 7, 4, 6};
    int nums2[8] = {0};
    
    int space = 1;
    while (space < 9) {
        
        //利用两个数组循环替换保持原始值顺序错乱 但总值不变
        
        //开始归并
        for (int i = 0; i < 8; i += 2 * space) {
            
            int end = (i + 2 * space - 1) > 7 ? 7 : (i + 2 * space - 1);
            [self mergeLeft:nums1 right:nums2 startl:i startr:i + space end:end];
        }
        space *= 2;
        
        for (int i = 0; i < 8; i += 2 * space) {

            int end = (i + 2 * space - 1) > 7 ? 7 : (i + 2 * space - 1);
            [self mergeLeft:nums2 right:nums1 startl:i startr:i + space end:end];
        }
        space *= 2;
    }
    [self qy_printf:nums1 count:8];
}

#pragma mark - 归并排序递归

- (void)guibingpaixudigui {
    
    //              0  1  2  3  4  5  6  7  8
    int nums1[9] = {9, 1, 5, 8, 3, 7, 4, 6, 2};
    int nums2[9] = {0};
    
    [self msorftLeft:nums1 right:nums2 start:0 end:8];
    [self qy_printf:nums2 count:9];
}

- (void)msorftLeft:(int [])left right:(int [])right start:(int)start end:(int)end {
    
    if (start == end) { //递归结束条件
        //如果相等 等同于只有一个数值  把原始数组值拷贝到右边
        right[start] = left[start];
        return;
    }
    
    int m = (start + end) / 2; //下一次递归中间值
    int result[9] = {}; //要合并的数组
    [self msorftLeft:left right:result start:start end:m];  //左递归
    [self msorftLeft:left right:result start:m + 1 end:end]; //右递归
    [self mergeLeft:result right:right startl:start startr:m + 1 end:end]; //将左右递归结果合并到最终数组
}

- (void)mergeLeft:(int [])left right:(int [])right startl:(int)startl startr:(int)startr end:(int)end {
    
    int i = startl;  //左边数组其实值
    int j = startr;  //右边数组其实值  qie j - 1 为左边数组停止值
    int k = startl;  //放置位置起始值
    while ( i < startr && j <= end) {
        if (left[i] < left[j]) {
            right[k++] = left[i++];
        } else {
            right[k++] = left[j++];
        }
    }
    
    while (i < startr) {
        right[k++] = left[i++];
    }
    
    while (j <= end) {
        right[k++] = left[j++];
    }
}



@end