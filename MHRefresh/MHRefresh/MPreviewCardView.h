//
//  MPreviewCardView.h
//  Memory
//
//  Created by zyx on 16/8/22.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlockWithBool)(BOOL flag);

typedef NS_ENUM(NSInteger, CardMoveDirection) {
    CardMoveDirectionNone,
    CardMoveDirectionLeft,
    CardMoveDirectionRight
};

typedef NS_ENUM(NSInteger, PreviewScrollDirection) {
    PreviewScrollDirectionLeft,
    PreviewScrollDirectionRight
};

@protocol MPreviewCardViewDelegate <NSObject>

@required
/**
 *   返回数据源个数
 */
- (NSInteger)numberOfPreviewCardViewNumbersWithScrollView:(UIScrollView *)scrollView;

/**
 *   切换数据源 重新布局卡片view
 */
- (void)scrollViewChangeWithPreviewCardView:(UIView *)cardView andIndex:(NSInteger)index;

@optional
/**
 加载更多数据
 */
- (void)loadMoreDataWithCallBack:(CompleteBlockWithBool)block;

@optional
/**
 如果在退出预览界面的时候 需要滚动到最后预览的位置 实现此协议即可
 
 @param index 最后位置对应的下标
 */
- (void)closePreviewCardViewToScrollLastPreviewPositionWithIndex:(NSInteger)index;

@end

@interface MPreviewCardView : UIView

@property (nonatomic, strong) NSMutableArray *cardArray;

- (void)reloadDataWithSuperView:(UIView *)view andCurrentIndex:(NSInteger)index;

@end
