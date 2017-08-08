//
//  MHRefreshScrollView.h
//  Memory
//
//  Created by developer on 2017/6/2.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHRefreshScrollView;

@protocol MHRefreshScrollViewDelegate <NSObject>

@optional
- (CGSize)sizeForContentView:(MHRefreshScrollView *)scrollView;

- (NSInteger)numberForContentViewCount:(MHRefreshScrollView *)scrollView;

- (UIView *)viewForIndex:(NSInteger)index scrollView:(MHRefreshScrollView *)scrollView;

- (void)contentViewEndDisplay:(UIView *)contentView;

- (void)contentViewOnDisplay:(UIView *)contentView;

@end

@interface MHRefreshScrollView : UIScrollView

@property (nonatomic, weak) id <MHRefreshScrollViewDelegate> refreshDelegate;

- (NSInteger)getCurrentPrevireIndex;

- (UIView *)getShowingMidView;

- (UIView *)getShowingLeftView;

- (UIView *)getShowingRightView;

- (UIView *)getReuseViewWithIndex:(NSInteger)index;

- (void)reloadDataWithIndex:(NSInteger)index;

@end
