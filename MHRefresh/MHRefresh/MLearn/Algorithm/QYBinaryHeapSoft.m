//
//  QYBinaryHeapSoft.m
//  MHRefresh
//
//  Created by panle on 2018/9/10.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYBinaryHeapSoft.h"

@implementation QYBinaryHeapSoft

/**
 
 二叉堆：二叉堆本质上是一种完全二叉树
 
 1.最大堆  最大堆任何的一个父节点的值，都大于等于它左右孩子节点的值。
 2.最小堆  最小堆任何一个父节点的值，都小于等于它左右孩子节点的值。
 
 二叉堆的根节点叫做堆顶。
 
 最大堆的堆顶是整个堆中的最大元素。
 最小堆的堆顶是整个堆中的最小元素。
 
 堆的自我调整
 插入节点
 删除节点
 构建二叉堆
 
 */

//代码以最小二叉堆为例

- (void)start {
    
//    NSMutableArray *array = [@[@1, @3, @2, @6, @5, @7, @8, @9, @10, @0] mutableCopy];
//    [self upAdjust:array];
//
//    NSLog(@"%@", array);
//
//    array = [@[@7, @1, @3, @10, @5, @2, @8, @9, @6] mutableCopy];
//    [self buildHeap:array];
//    NSLog(@"%@", array);
    
    NSMutableArray *array = [@[@1, @3, @2, @6, @5, @7, @8, @9, @10, @0] mutableCopy];
    [self heapSoft:array];
    NSLog(@"%@", array);
}

/**
 上浮调整

 @param array array description
 */
- (void)upAdjust:(NSMutableArray *)array {
    
    NSInteger childIndex = array.count - 1;
    NSInteger parentIndex = (childIndex - 1) / 2;
    
    //保存叶子节点值 用于最后的赋值
    NSInteger temp = [[array objectAtIndex:childIndex] integerValue];
    
    while (childIndex > 0 &&
           temp < [[array objectAtIndex:parentIndex] integerValue]) {
        
        //调换父节点和子节点
        array[childIndex] = array[parentIndex];
        //将当前父节点作为子节点
        childIndex = parentIndex;
        //寻找当前父节点的父节点
        parentIndex = (childIndex - 1) / 2;
    }
    array[childIndex] = @(temp);
}

/**
 下沉跳帧

 @param array array description
 @param parentIndex parentIndex description
 @param length length description
 */
- (void)downAdjust:(NSMutableArray *)array parentIndex:(NSInteger)parentIndex length:(NSInteger)length {
    
    NSInteger temp = [[array objectAtIndex:parentIndex] integerValue];
    
    NSInteger childIndex = 2 * parentIndex + 1;
    
    while (childIndex < length) {
        //childIndex + 1 右节点
        if (childIndex + 1 < length && [array[childIndex + 1] integerValue] < [array[childIndex] integerValue]) {
            childIndex++;
        }
        
        if (temp <= [array[childIndex] integerValue]) {
            break;
        }
        
        array[parentIndex] = array[childIndex];
        parentIndex = childIndex;
        childIndex = 2 * childIndex + 1;
    }
    
    array[parentIndex] = @(temp);
}

/**
 构建二叉堆

 @param array array description
 */
- (void)buildHeap:(NSMutableArray *)array {
    for (NSInteger i = (array.count - 2) / 2; i >= 0; i--) {
        [self downAdjust:array parentIndex:i length:array.count];
    }
}

- (void)heapSoft:(NSMutableArray *)array {
    
    [self buildHeap:array];
    
    NSLog(@"%@", array);
    
    for (NSInteger i = array.count - 1; i > 0; i --) {
        NSInteger tamp = [array[i] integerValue];
        //交换元素
        array[i] = array[0];
        array[0] = @(tamp);
        [self downAdjust:array parentIndex:0 length:i];
    }
}

@end
