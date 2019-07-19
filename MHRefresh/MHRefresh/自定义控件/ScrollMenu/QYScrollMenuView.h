//
//  QYScrollMenuView.h
//  MHRefresh
//
//  Created by panle on 2019/7/19.
//  Copyright © 2019 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QYScrollMenuView;

@protocol UPScrollMenuViewDelegate <NSObject>

- (void)up_scrollMenuViewSelectEvent:(QYScrollMenuView *)menuView
                               index:(NSInteger)index;
@end

typedef NS_ENUM(NSInteger, UPLineWidthType) {
    UPLineWidthTypeFixed = 0,
    UPLineWidthTypeEqualText = 1,
};

typedef NS_ENUM(NSInteger, QYMenuItemLayoutType) {
    /** 线性布局下，需指定 itemLRSapce */
    QYMenuItemLayoutTypeeLinear = 0,
    /** 以view宽等间距适配 */
    QYMenuItemLayoutTypeEqualSpace = 1,
    /** 计算item之间的距离，占满整个屏幕 */
    QYMenuItemLayoutTypeDynamicSpace = 2,
};

typedef NS_ENUM(NSInteger, QYLineLayoutType) {
    /** 线条宽度固定 */
    QYLineLayoutTypeFixed = 0,
    /** 线条宽度跟随文字变化 */
    QYLineLayoutTypeEqualText = 1,
};

@interface QYScrollMenuItem : NSObject

+ (QYScrollMenuItem *)qy_scrollMenuItemWithTitle:(NSString *)title;

@end


@interface QYScrollMenuView : UIView

@property (nonatomic, assign) QYMenuItemLayoutType itemLayoutType;
@property (nonatomic, assign) QYLineLayoutType lineLayoutType;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;

@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *selectedFont;

/** 布局的边距 {0, 20, 0, 20} */
@property (nonatomic, assign) UIEdgeInsets itemInsets;
/** 滑动线条size UPLineWidthTypeEqualText 仅高度有效 {26, 3} */
@property (nonatomic, assign) CGSize lineSize;
/** item的左右距离 30.0 */
@property (nonatomic, assign) CGFloat itemLRSapce;

@property (nonatomic, weak) id <UPScrollMenuViewDelegate> delegate;

- (void)qy_updateToIndex:(NSInteger)index;
- (void)qy_configItems:(NSArray <QYScrollMenuItem *>*)items;

@end

NS_ASSUME_NONNULL_END
