//
//  MPreviewCardView.m
//  Memory
//
//  Created by zyx on 16/8/22.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import "MPreviewCardView.h"
#import "MHRefreshScrollView.h"

static CGFloat kCardAnimationScale = 0.3;
static CGFloat kCardViewWidth = 0.0;           //卡片宽度
static CGFloat kCardViewHeight = 0.0;          //卡片高度
static CGFloat kCardExtraWidth = 20.0; 

@interface MPreviewCardView() <MHRefreshScrollViewDelegate>
@property (nonatomic, assign) BOOL animationDone;
@property (nonatomic, strong) MHRefreshScrollView *scrollView;
@property (nonatomic, strong) UIView *coverView;

@end

@implementation MPreviewCardView

+ (void)load {
    [self setCardWidthAndHeight];
}

+ (void)setCardWidthAndHeight {
    kCardViewWidth = SCREEN_W * 0.8;
    kCardViewHeight = kCardViewWidth * 1.2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUIOfSelf];
        [self layoutUIOfHRefreshScrollView];
    }
    return self;
}

- (void)layoutUIOfSelf {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
}

- (void)layoutUIOfHRefreshScrollView {
    CGFloat offentY = (SCREEN_H - kCardViewHeight) / 2.0;
    self.scrollView = [[MHRefreshScrollView alloc] initWithFrame:CGRectMake((SCREEN_W - kCardViewWidth - kCardExtraWidth) / 2.0, offentY, kCardViewWidth + kCardExtraWidth, kCardViewHeight + kCardExtraWidth)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.refreshDelegate = self;
    [self addSubview:self.scrollView];
}


#pragma mark - relodata
- (void)reloadDataWithSuperView:(UIView *)view andCurrentIndex:(NSInteger)index {
    
    [view addSubview:self.coverView];
    
    [view addSubview:self];
    
    [self.scrollView reloadDataWithIndex:index];
    
    [self setPreviewCardStartAnimationCondition];
    
    [self cardViewAppearAnimation];
}

#pragma maek - MHRefreshScrollViewDelegate

- (CGSize)sizeForContentView:(MHRefreshScrollView *)scrollView {
    return CGSizeMake(kCardViewWidth + kCardExtraWidth, kCardViewHeight + kCardExtraWidth);
}

- (NSInteger)numberForContentViewCount:(MHRefreshScrollView *)scrollView {
    return 100;
}

- (void)contentViewEndDisplay:(UIView *)contentView {
    NSLog(@"卡片退出展示");
}

- (void)contentViewOnDisplay:(UIView *)contentView {
    NSLog(@"卡片正在展示 滑动至中央");
}

- (UIView *)viewForIndex:(NSInteger)index scrollView:(MHRefreshScrollView *)scrollView {
    
    UIView *view = [scrollView getReuseViewWithIndex:index];
    view.backgroundColor = [self randomColor];
    return view;
}

#pragma mark - cardAnimation
- (void)cardViewAppearAnimation {
    UIView *midView = [self.scrollView getShowingMidView];
    if (midView) {
        midView.transform = CGAffineTransformMakeScale(kCardAnimationScale, kCardAnimationScale);
    }
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         if (midView) {
                             midView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                             midView.hidden = NO;
                         }
                         
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.1
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              midView.transform = CGAffineTransformIdentity;
                                              
                                          } completion:^(BOOL finished){
                                              
                                              [UIView animateWithDuration:0.2 animations:^{
                                                  
                                                  [self setPreviewCardEndAnimationCondition];
                                                  
                                              } completion:^(BOOL finished) {
                                                  
                                                  self.animationDone = YES;
                                                  
                                                  if (midView) {
                                                      [self contentViewOnDisplay:midView];
                                                  }
                                                  
                                              }];
                                              
                                          }];
                     }];
    
}

/**
 卡片初始动画状态
 */
- (void)setPreviewCardStartAnimationCondition {

    UIView *leftView = [self.scrollView getShowingLeftView];
    UIView *rightView = [self.scrollView getShowingRightView];
    if (leftView) {
        leftView.alpha = 0.0;
    }
    
    if (rightView) {
        rightView.alpha = 0.0;
    }
    
}

/**
 卡片结束状态
 */
- (void)setPreviewCardEndAnimationCondition {
    
    UIView *leftView = [self.scrollView getShowingLeftView];
    UIView *rightView = [self.scrollView getShowingRightView];
    if (leftView) {
        leftView.alpha = 1.0;
    }
    
    if (rightView) {
        rightView.alpha = 1.0;
    }

}

#pragma mark - color
- (UIColor *)randomColor {
    int R = (arc4random() % 256) ;
    int G = (arc4random() % 256) ;
    int B = (arc4random() % 256) ;
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}

#pragma mark - lazy
- (NSMutableArray *)cardArray {
    if (_cardArray == nil) {
        _cardArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _cardArray;
}

- (UIView *)coverView {
    
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.50];
    }
    return _coverView;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}


@end

