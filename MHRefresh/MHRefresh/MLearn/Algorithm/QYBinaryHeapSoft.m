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

- (void)start {
    [self p_erchaduisoft];
}

- (void)p_erchaduisoft {
    //             0   1   2   3   4   5   6   7   8
    int nums[9] = {5, 1, 9, 3, 7, 4, 8, 6, 2};
    
    //构建最大二叉堆
    //从最后一个不是内部结点开始修改  使得每个节点都是最大值
    
    int count = 9 / 2 - 1;
    for (int i = count; i >= 0; i--) {
        [self p_upAdjust:nums parent:i count:9];
    }
    
    for (int i = 8; i > 1; i--) { //i = 1 时  没必要进行交换
        [self qy_swap:nums left:0 right:i];
        [self p_upAdjust:nums parent:0 count:i - 1];
    }
    
    [self qy_printf:nums count:9];
}

- (void)p_upAdjust:(int *)nums parent:(int)parent count:(int)count {
    
    //方法目的是使得内部节点对应的书值在该分支上最大
    
    //二叉堆性质  对于一颗完全二叉树，如果节点i为二叉树的根，则节点无双亲，如果节点i>1,则其双亲节点是总数/2
    // 该双亲对应的子节点为  l = parent * 2 + 1;   r = parent * 2 + 2
    
    //保存父节点的值
    int index = nums[parent];
    //保存父节点位置
    int result = parent;
    
    //初始指向左孩子
    for (int i = parent * 2 + 1; i < count; i = 2 * i + 1) {
        
        if (nums[i] < nums[i + 1]) {
            //左孩子小于右孩子  指向右孩子
            i++;
        }
        
        //用父节点和两者间的最大值做d对比
        if (i >= count || index > nums[i]) {
            //如果父节点同时大于左右孩子跳出循环
            break;
        }
        
        //父节点
        nums[result] = nums[i];
        
        //记录需要赋值的位置
        result = i;
    }
    
    if (result != parent) {
        //如果发生了排序  交换两者数值
        nums[result] = index;
    }
    
}

//- (void)p_erchaduisoft {
//    //             0   1   2   3   4   5   6   7   8
//    int nums[9] = {5, 1, 9, 3, 7, 4, 8, 6, 2};
//
//    //构建最大二叉堆
//    //从最后一个不是内部结点开始修改  使得每个节点都是最大值
//
//    int count = 9 / 2 - 1;
//    for (int i = count; i >= 0; i--) {
//        [self p_upAdjust:nums parent:i count:9];
//    }
//
//    for (int i = 8; i > 1; i--) { //i = 1 时  没必要进行交换
//        [self qy_swap:nums left:0 right:i];
//        [self p_upAdjust:nums parent:0 count:i - 1];
//    }
//
//    [self qy_printf:nums count:9];
//}
//
//- (void)p_upAdjust:(int *)nums parent:(int)parent count:(int)count {
//
//    //方法目的是使得内部节点对应的书值在该分支上最大
//
//    //二叉堆性质  对于一颗完全二叉树，如果节点i为二叉树的根，则节点无双亲，如果节点i>1,则其双亲节点是总数/2
//    // 该双亲对应的子节点为  l = parent * 2 + 1;   r = parent * 2 + 2
//
//    //保存父节点的值
//    int index = nums[parent];
//    //保存父节点位置
//    int result = parent;
//
//    //初始指向左孩子
//    for (int i = parent * 2 + 1; i < count; i = 2 * i + 1) {
//
//        if (nums[i] < nums[i + 1]) {
//            //左孩子小于右孩子  指向右孩子
//            i++;
//        }
//
//        //用父节点和两者间的最大值做d对比
//        if (i >= count || index > nums[i]) {
//            //如果父节点同时大于左右孩子跳出循环
//            break;
//        }
//
//        //父节点
//        nums[result] = nums[i];
//
//        //记录需要赋值的位置
//        result = i;
//    }
//
//    if (result != parent) {
//        //如果发生了排序  交换两者数值
//        nums[result] = index;
//    }
//
//}



//
//- (void)start {
//
////    NSMutableArray *array = [@[@1, @3, @2, @6, @5, @7, @8, @9, @10, @0] mutableCopy];
////    [self upAdjust:array];
////
////    NSLog(@"%@", array);
////
////    array = [@[@7, @1, @3, @10, @5, @2, @8, @9, @6] mutableCopy];
////    [self buildHeap:array];
////    NSLog(@"%@", array);
//
//    NSMutableArray *array = [@[@1, @3, @2, @6, @5, @7, @8, @9, @10, @0] mutableCopy];
//    [self heapSoft:array];
//    NSLog(@"%@", array);
//}
//
///**
// 上浮调整
//
// @param array array description
// */
//- (void)upAdjust:(NSMutableArray *)array {
//
//    NSInteger childIndex = array.count - 1;
//    NSInteger parentIndex = (childIndex - 1) / 2;
//
//    //保存叶子节点值 用于最后的赋值
//    NSInteger temp = [[array objectAtIndex:childIndex] integerValue];
//
//    while (childIndex > 0 &&
//           temp < [[array objectAtIndex:parentIndex] integerValue]) {
//
//        //调换父节点和子节点
//        array[childIndex] = array[parentIndex];
//        //将当前父节点作为子节点
//        childIndex = parentIndex;
//        //寻找当前父节点的父节点
//        parentIndex = (childIndex - 1) / 2;
//    }
//    array[childIndex] = @(temp);
//}
//
///**
// 下沉跳帧
//
// @param array array description
// @param parentIndex parentIndex description
// @param length length description
// */
//- (void)downAdjust:(NSMutableArray *)array parentIndex:(NSInteger)parentIndex length:(NSInteger)length {
//
//    NSInteger temp = [[array objectAtIndex:parentIndex] integerValue];
//
//    NSInteger childIndex = 2 * parentIndex + 1;
//
//    while (childIndex < length) {
//        //childIndex + 1 右节点
//        if (childIndex + 1 < length && [array[childIndex + 1] integerValue] < [array[childIndex] integerValue]) {
//            childIndex++;
//        }
//
//        if (temp <= [array[childIndex] integerValue]) {
//            break;
//        }
//
//        array[parentIndex] = array[childIndex];
//        parentIndex = childIndex;
//        childIndex = 2 * childIndex + 1;
//    }
//
//    array[parentIndex] = @(temp);
//}
//
///**
// 构建二叉堆
//
// @param array array description
// */
//- (void)buildHeap:(NSMutableArray *)array {
//    for (NSInteger i = (array.count - 2) / 2; i >= 0; i--) {
//        [self downAdjust:array parentIndex:i length:array.count];
//    }
//}
//
//- (void)heapSoft:(NSMutableArray *)array {
//
//    [self buildHeap:array];
//
//    NSLog(@"%@", array);
//
//    for (NSInteger i = array.count - 1; i > 0; i --) {
//        NSInteger tamp = [array[i] integerValue];
//        //交换元素
//        array[i] = array[0];
//        array[0] = @(tamp);
//        [self downAdjust:array parentIndex:0 length:i];
//    }
//}

@end
