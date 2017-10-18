//
//  CakeSortModel.m
//  test
//
//  Created by developer on 2017/10/12.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "CakeSortModel.h"

@interface CakeSortModel()

/** 饼信息数组 */
@property (nonatomic, strong) NSArray *cakeInfoArray;
/** 饼个数 */
@property (nonatomic, assign) NSInteger cakeCount;
/** 交换个数 */
@property (nonatomic, assign) NSInteger maxSwap;
/** 交换结果数组 */
@property (nonatomic, strong) NSMutableArray *cakeSwapArray;
/** 当前反转信息数组 */
@property (nonatomic, strong) NSMutableArray *cakeReverseCakeArray;
/** 当前反转交换结果信息数组 */
@property (nonatomic, strong) NSMutableArray *cakeReverseCakeSwapArray;
/** 当前搜索次数 */
@property (nonatomic, assign) NSInteger searchCount;

@end

@implementation CakeSortModel

- (instancetype)initWithCakeArray:(NSArray *)cakeArray {
    
    if (self = [super init]) {
        
        if (!cakeArray.count) { //, @8, @1, @3, @7, @2, @9, @4
            self.cakeInfoArray = @[@3, @2, @1, @6, @5, @4, @9, @8, @8, @0];
        } else {
            self.cakeInfoArray = [NSArray arrayWithArray:cakeArray];
        }
        
        _cakeCount = self.cakeInfoArray.count;
        _maxSwap = [self upperBound:_cakeCount];
        
        _cakeSwapArray = [NSMutableArray array];
        _cakeReverseCakeArray = [NSMutableArray arrayWithArray:self.cakeInfoArray];
        _cakeReverseCakeSwapArray = [NSMutableArray array];
        
        _searchCount = 0;
    }
    return self;
}

- (void)sort {
    
    [self search:0];
    
    [self outPut];
}

#pragma mark - help

- (void)search:(NSInteger)setp {
    
    NSInteger i = 0, nEstimate = 0;
    _searchCount++;
    
    nEstimate = [self lowerBound:_cakeReverseCakeArray cakeCount:_cakeCount];
    
    if (setp + nEstimate > _maxSwap) {
        return;
    }
    
    if ([self isSorted:_cakeReverseCakeArray cakeCount:_cakeCount]) {
        
        if (setp < _maxSwap) {
            _maxSwap = setp;
            
            for (i = 0; i < _maxSwap; i++) {
                _cakeSwapArray[i] = _cakeReverseCakeSwapArray[i];
            }
        }
        return;
    }
    
    for (i = 1; i < _cakeCount; i++) {
        [self reverse:0 end:i];
        _cakeReverseCakeSwapArray[setp] = @(i);
        [self search:setp + 1];
        [self reverse:0 end:i];
    }
}

/**
 反转的上界

 @param cakeCount
 @return NSInteger
 */
- (NSInteger)upperBound:(NSInteger)cakeCount {
    return cakeCount * 2;
}

/**
 反转的下界

 @param cakeArray 数组
 @param cakeCount 数量
 @return          个数
 */
- (NSInteger)lowerBound:(NSArray *)cakeArray cakeCount:(NSInteger)cakeCount {
    
    NSInteger ret = 0;
    
    for (int i = 1; i < cakeCount; i++) {
        NSInteger t = [cakeArray integerWithIndex:i] - [cakeArray integerWithIndex:i - 1];
        if (t == 1 || t == -1 ) {
            
        } else {
            ret++;
        }
    }
    
//    DLog(@"当前寻找最小下界 值为  %ld", (long)ret);
    
    return ret;
}


/**
 输出结果
 */
- (void)outPut {
    
    for (int i = 0; i < _maxSwap; i++) {
        DLog(@"%ld", (long)[_cakeSwapArray integerWithIndex:i]);
    }
    
    DLog(@"搜索总数 %ld", (long)_searchCount);
    DLog(@"最大交换次数 %ld", (long)_maxSwap);
}

/**
 反转数组

 @param begin 开始位置
 @param end   结束位置
 */
- (void)reverse:(NSInteger)begin end:(NSInteger)end {
    
    if (begin >= end) {
        return;
    }
    
    for (NSInteger i = begin, j = end; i < j; i++, j--) {
        NSNumber *number = [_cakeReverseCakeArray objectAtIndex:i];
        [_cakeReverseCakeArray replaceObjectAtIndex:i withObject:[_cakeReverseCakeArray objectAtIndex:j]];
        [_cakeReverseCakeArray replaceObjectAtIndex:j withObject:number];
    }
}

/**
 判断当前是否已经排好序

 @param swapArray 排序数组
 @param cakeCount 数量
 @return          返回结果  如果  相邻两者之间有 前一个  大于  后一个  则代表排序未完成
 */
- (BOOL)isSorted:(NSArray *)swapArray cakeCount:(NSInteger)cakeCount {
    
    BOOL isFlag = YES;
    
    for (int i = 1; i < cakeCount; i++) {
        
        if ([swapArray integerWithIndex:i - 1] > [swapArray integerWithIndex:i]) {
            isFlag = NO;
            break;
        }
    }
    
    return isFlag;
}

@end
