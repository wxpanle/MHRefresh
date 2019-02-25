//
//  QYStarScoreView.h
//  MHRefresh
//
//  Created by panle on 2019/1/23.
//  Copyright © 2019 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ QYStarScoreUpdateCallBackBlock)(CGFloat newScore);

/** ✨ ✨ ✨ ✨ ✨ */
typedef NS_ENUM(NSInteger, QYStarScoreStyle) {
    QYStarScoreStyleDefault,
};

typedef NS_ENUM(NSInteger, QYStarScoreType) {
    QYStarScoreTypeHalf,      //一半比例
    QYStarScoreTypeWhole,     //整颗星比例
    QYStarScoreTypeRandom,   //浮点比例
};

@interface QYStarScoreView : UIView

/** 评分控件类型 */
@property (nonatomic, assign) QYStarScoreStyle starScoreStyle;

/** ✨种类 */
@property (nonatomic, assign) QYStarScoreType starScoreType;

/** {top:2.0 left:2.0 right:2.0 bottom: 2.0} */
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/** ✨间距 默认5.0 */
@property (nonatomic, assign) CGFloat starSpace;

/** 选中的✨图片 */
@property (nonatomic, strong) UIImage *selectedStarImage;
/** 未选中的✨图片 */
@property (nonatomic, strong) UIImage *unselectedStarImage;

/** 星星个数 默认5 */
@property (nonatomic, assign, readonly) NSInteger starNumber;
/** 最大评分 默认10.0 */
@property (nonatomic, assign) CGFloat maximumScore;
/** 最小评分 默认0.0 */
@property (nonatomic, assign) CGFloat minimumScore;

/** 可以交互 默认YES */
@property (nonatomic, assign) BOOL eventEnable;

/** 设置当前显示的评分 会调用更新机制 */
@property (nonatomic, assign) CGFloat currentScore;

/** 新的评分更新后会回调该block */
@property (nonatomic, copy, nullable) QYStarScoreUpdateCallBackBlock scoreUpdateCallBack;

- (instancetype)initWithFrame:(CGRect)frame starCount:(NSInteger)starCount;

@end

NS_ASSUME_NONNULL_END
