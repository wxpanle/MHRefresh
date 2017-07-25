//
//  MHRefreshScrollView.m
//  Memory
//
//  Created by developer on 2017/6/2.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "MHRefreshScrollView.h"

typedef NS_ENUM(NSInteger, PreviewScrollDirection) {
    PreviewScrollDirectionLeft,
    PreviewScrollDirectionRight
};

static CGFloat startCacheOffent = 0.0;
static CGFloat startDrawOffent = 0.0;

@interface MHRefreshScrollView() <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger contentViewCount;

@property (nonatomic, assign) CGSize contentViewSize;

@property (nonatomic, strong)  UIView *showMidView;    //正在显示的中间view

@property (nonatomic, strong)  UIView *showLeftView;  //正咋显示的左边view

@property (nonatomic, strong)  UIView *showRightView; //正在显示的右边view

@property (nonatomic, strong)  UIView *showCacheView; //预加载的view

@property (nonatomic, assign) NSInteger currentShowIndex;

@property (nonatomic, strong) NSMutableDictionary *cacheDictionary;

@property (nonatomic, assign) BOOL isStartCache;

@property (nonatomic, assign) PreviewScrollDirection cacheDirection;

@property (nonatomic, assign) BOOL isDirectionChange;

@property (nonatomic, assign) BOOL isAdd;

@property (nonatomic, assign) BOOL isAllowJudgeDirection;

@end

static inline CGFLOAT_TYPE CGFloat_fabs(CGFLOAT_TYPE cgfloat) {
#if CGFLOAT_IS_DOUBLE
    return fabs(cgfloat);
#else
    return fabsf(cgfloat);
#endif
}


@implementation MHRefreshScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _contentViewCount = 0;
        _contentViewSize = CGSizeZero;
        _currentShowIndex = 0;
        _isAllowJudgeDirection = NO;
        _isStartCache = NO;
        _isAdd = NO;
        _cacheDirection = PreviewScrollDirectionRight;
        
    }
    return self;
}

- (void)reloadDataWithIndex:(NSInteger)index {
    
    self.delegate = nil;
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(numberForContentViewCount:)]) {
        _contentViewCount = [self.refreshDelegate numberForContentViewCount:self];
    }
    
    if (CGSizeEqualToSize(_contentViewSize, CGSizeZero)) {
        if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(sizeForContentView:)]) {
            _contentViewSize = [self.refreshDelegate sizeForContentView:self];
            startCacheOffent = _contentViewSize.width * 0.3;
            startDrawOffent = _contentViewSize.width * 0.7;
        } else {
            startCacheOffent = WIDTH * 0.5;
            startDrawOffent = WIDTH * 0.8;
        }
    }
    
    self.currentShowIndex = index;
    
    self.contentSize = CGSizeMake(_contentViewCount * _contentViewSize.width, self.frame.size.height);
    
    if (index != NSIntegerMax) {
        self.contentOffset = [self contentOffsetWithIndex:index];
    } else {
        self.contentOffset = [self contentOffsetWithIndex:0];
    }
    
    if (self.showMidView == nil) {
        UIView *tempView = [self getPreviewLoadViewWithIndex:index];
        tempView.center = [self centerForCardWithIndex:index];
        [self addSubview:tempView];
        self.showMidView = tempView;
    }
    
    if (self.showLeftView == nil && index - 1 >= 0) {
        UIView *tempView = [self getPreviewLoadViewWithIndex:index - 1];
        tempView.center = [self centerForCardWithIndex:index - 1];
        [self addSubview:tempView];
        self.showLeftView = tempView;
    }
    
    if (self.showRightView == nil && index + 1 < _contentViewCount) {
        UIView *tempView = [self getPreviewLoadViewWithIndex:index + 1];
        tempView.center = [self centerForCardWithIndex:index + 1];
        [self addSubview:tempView];
        self.showRightView = tempView;
    }
    
    self.delegate = self;
    
}

#pragma mark - scrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat orginContentOffset = self.currentShowIndex * _contentViewSize.width;
    CGFloat diff = scrollView.contentOffset.x - orginContentOffset;
    PreviewScrollDirection direction = diff > 0 ? PreviewScrollDirectionRight : PreviewScrollDirectionLeft;
    
    if (_isStartCache) {
        _cacheDirection = direction;
        _isAllowJudgeDirection = YES;
    }
    
    if (_isAllowJudgeDirection && direction != _cacheDirection) {
        _isDirectionChange = YES;
        _cacheDirection = direction;
    }
    
    if (CGFloat_fabs(diff) >= _contentViewSize.width) {
        
        self.currentShowIndex = direction == PreviewScrollDirectionRight ? self.currentShowIndex + 1 : self.currentShowIndex - 1;
        [self endScrollPreviewSubViewAndCurrentCardPointerWithDirection:direction];
        _isStartCache = NO;
        _isAdd = NO;
        _isDirectionChange = NO;
        _isAllowJudgeDirection = NO;
        
    } else {
        //即将要缓存的view
        NSInteger index = direction == PreviewScrollDirectionRight ? self.currentShowIndex + 2 : self.currentShowIndex - 2;
        
        //到达缓存距离
        if (CGFloat_fabs(diff) >= startCacheOffent || _isStartCache) {
            
            _isStartCache = YES;   //回合开始
            
            if (_isDirectionChange && _isAdd) {  //方向改变并且已经添加
                _isDirectionChange = NO;
                if (CGFloat_fabs(diff) < startDrawOffent) {
                    //移除
                    [_showCacheView removeFromSuperview];
                    [self.cacheDictionary setObject:_showCacheView forKey:@(_showCacheView.tag)];
                    self.showCacheView = nil;
                    _isAdd = NO;
                    
                    if (index >= 0 && index < _contentViewCount) {
                        self.showCacheView = [self getPreviewLoadViewWithIndex:index];
                    }
                    
                } else {
                    //保持当前范围
                }
            } else if (_isDirectionChange && !_isAdd) {
                _isDirectionChange = NO;
                //保存即将要访问的view
                [self getCacheViewCommonUIWithIndex:index];
            } else if (!_isAdd) {
                //保存即将要访问的view
                [self getCacheViewCommonUIWithIndex:index];
            }
        }
        
        //开始添加
        if (CGFloat_fabs(diff) >= startDrawOffent) {
            if (self.showCacheView && !_isAdd ) {
                self.showCacheView.center = [self centerForCardWithIndex:self.showCacheView.tag];
                [self addSubview:self.showCacheView];
                _isAdd = YES;
            }
        }
    }
}

- (void)getCacheViewCommonUIWithIndex:(NSInteger)index {
    if (index >= 0 && index < _contentViewCount) {
        if (self.showCacheView.tag != index || index == 0) {
            if (index == 0) {
                if (self.showCacheView && self.showCacheView.tag == 0) {
                    return;
                }
            }
            if (self.showCacheView) {
                [self.cacheDictionary setObject:self.showCacheView forKey:@(self.showCacheView.tag)];
            }
            self.showCacheView = [self getPreviewLoadViewWithIndex:index];
        }
    }
}

- (void)getPreview:(NSInteger)index {
    
    if (index >= 0 && index < _contentViewCount) {
        UIView *tempView = [self getPreviewLoadViewWithIndex:index];
        [self.cacheDictionary setObject:tempView forKey:@(tempView.tag)];
    }
}

- (void)endScrollPreviewSubViewAndCurrentCardPointerWithDirection:(PreviewScrollDirection)direction {
    
    if (self.showMidView) {
        [self viewEndDisplay:self.showMidView];
    }

    [self updatePreviewSubViewAndCurrentCardPointerWithDirection:direction];
    
    if (self.showMidView) {
        [self viewOnDisplay:self.showMidView];
    }
    
}

- (void)updatePreviewSubViewAndCurrentCardPointerWithDirection:(PreviewScrollDirection)direction {
    switch (direction) {
        case PreviewScrollDirectionRight: {

            UIView *cacheView = self.showLeftView;
            
            self.showLeftView = self.showMidView;
            self.showMidView = self.showRightView;
            self.showRightView = self.showCacheView;
            self.showCacheView = cacheView;
        }
            break;
            
        case PreviewScrollDirectionLeft: {
            UIView *cacheView = self.showRightView;
            
            self.showRightView = self.showMidView;
            self.showMidView = self.showLeftView;
            self.showLeftView = self.showCacheView;
            self.showCacheView = cacheView;
        
        }
            break;
            
        default:
           
            break;
    }
    
    if (self.showCacheView) {
        [self.showCacheView removeFromSuperview];
        [self.cacheDictionary setObject:self.showCacheView forKey:@(self.showCacheView.tag)];
        _showCacheView = nil;
    }
}

- (UIView *)getReuseViewWithIndex:(NSInteger)index {
    
    UIView *view = nil;
    
    view = [self.cacheDictionary objectForKey:@(index)];
    
    if (view) {
        [self.cacheDictionary removeObjectForKey:@(index)];
        return view;
    }
    
    if (self.cacheDictionary.allKeys.count) {
        view = [self.cacheDictionary objectForKey:self.cacheDictionary.allKeys.firstObject];
        view.tag = index;
        [self.cacheDictionary removeObjectForKey:self.cacheDictionary.allKeys.firstObject];
        return view;
    }
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentViewSize.width, _contentViewSize.height)];
    view.tag = index;
    return view;
}

- (UIView *)getPreviewLoadViewWithIndex:(NSInteger)index {
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(viewForIndex:scrollView:)]) {
        return [self.refreshDelegate viewForIndex:index scrollView:self];
    }
    return nil;
}


- (void)viewEndDisplay:(UIView *)view {
    if (nil == view) {
        return;
    }
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(contentViewEndDisplay:)]) {
        [self.refreshDelegate contentViewEndDisplay:view];
    }
}

- (void)viewOnDisplay:(UIView *)view {
    if (nil == view) {
        return;
    }
    
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(contentViewOnDisplay:)]) {
        [self.refreshDelegate contentViewOnDisplay:view];
    }
}

- (NSInteger)getCurrentPrevireIndex {
    return self.currentShowIndex;
}

- (UIView *)getShowingMidView {
    return _showMidView;
}

- (UIView *)getShowingLeftView {
    return _showLeftView;
}

- (UIView *)getShowingRightView {
    return _showRightView;
}

#pragma mark - helper

- (void)setScrollViewOffentAndSice {
    self.contentSize = CGSizeMake(_contentViewSize.width * _contentViewCount, 0);
    self.contentOffset = [self contentOffsetWithIndex:self.currentShowIndex];
}

- (CGPoint)centerForCardWithIndex:(NSInteger)index {
    return CGPointMake(_contentViewSize.width * (index + 0.5), _contentViewSize.height / 2.0);
}

- (CGPoint)contentOffsetWithIndex:(NSInteger)index {
    return CGPointMake(_contentViewSize.width * index, 0);
}

#pragma mark - getter
- (NSMutableDictionary *)cacheDictionary {
    if (nil == _cacheDictionary) {
        _cacheDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _cacheDictionary;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

@end
