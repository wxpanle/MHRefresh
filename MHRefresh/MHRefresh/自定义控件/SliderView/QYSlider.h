//
//  QYSlider.h
//  MHRefresh
//
//  Created by panle on 2019/5/8.
//  Copyright © 2019 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class QYSlider;

/** 滑动中不响应事件 */

@protocol QYSliderDelegate <NSObject>

- (void)qy_sliderStartSlider:(QYSlider *)slider;
- (void)qy_sliderEndSlider:(QYSlider *)slider value:(CGFloat)value;

@end

@interface QYSlider : UIView

@property (nonatomic, weak) id <QYSliderDelegate> delegate;

/** 滑杆背景颜色 [UIColor lightGrayColor] */
@property (nonatomic, strong) UIColor *qy_maximumTrackTintColor;
/** 滑杆进度颜色 [UIColor whiteColor] */
@property (nonatomic, strong) UIColor *qy_minimumTrackTintColor;
/** 缓存进度颜色 [UIColor grayColor] */
@property (nonatomic, strong) UIColor *qy_cacheProgressTintColor;
/** 滑块进度颜色 [UIColor whiteColor] */
@property (nonatomic, strong) UIColor *qy_thumbTintColor;

/** 滑块进度 [0.f - 1.f] 如果在滑动中 不准确 */
@property (nonatomic, assign, readonly) CGFloat qy_sliderValue;
/** 缓冲进度 [0.f - 1.f]*/
@property (nonatomic, assign, readonly) CGFloat qy_cacheValue;

/** 滑杆高度 默认3.0 */
@property (nonatomic, assign) CGFloat qy_sliderHeight;
/** 滑块宽高 默认11.0 */
@property (nonatomic, assign) CGFloat qy_thumbWH;

- (void)qy_updateCacheValue:(CGFloat)value;
- (void)qy_updateSliderValue:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END
