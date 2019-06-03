//
//  QYSlider.m
//  MHRefresh
//
//  Created by panle on 2019/5/8.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYSlider.h"

static inline CGFloat kAdjustValue(CGFloat value) {
    if (value > 1.0) {
        return 1.f;
    } else if (value < 0.0) {
        return 0.0;
    } else {
        return value;
    }
}


@interface UIControl (QYPoint)

@end

@implementation UIControl (QYPoint)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end


@interface QYSlider ()

/** 滑块进度 [0.f - 1.f] */
@property (nonatomic, assign, readwrite) CGFloat qy_sliderValue;
/** 缓冲进度 [0.f - 1.f]*/
@property (nonatomic, assign, readwrite) CGFloat qy_cacheValue;

@property (nonatomic, strong) UIView *sliderBgView;
@property (nonatomic, strong) UIView *sliderRealView;
@property (nonatomic, strong) UIView *sliderProgressView;
@property (nonatomic, strong) UIControl *thumbControl;

@property (nonatomic, assign) BOOL slidering;

@end

@implementation QYSlider

@synthesize qy_maximumTrackTintColor = _qy_maximumTrackTintColor;
@synthesize qy_minimumTrackTintColor = _qy_minimumTrackTintColor;
@synthesize qy_cacheProgressTintColor = _qy_cacheProgressTintColor;
@synthesize qy_thumbTintColor = _qy_thumbTintColor;

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layoutOfUI];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self layoutOfUI];
    }
    return self;
}

- (CGRect)p_viewOriginFrame
{
    CGFloat offsetX = 0.0;
    CGFloat offsetY = (self.frame.size.height - _qy_sliderHeight) / 2.0;
    CGFloat width = self.frame.size.width;
    CGFloat height = _qy_sliderHeight;
    return CGRectMake(offsetX, offsetY, width, height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self p_updateFrame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self p_updateFrame];
}

- (void)p_updateFrame
{
    CGRect frame = [self p_viewOriginFrame];
    _sliderBgView.frame = frame;
    _sliderProgressView.frame = frame;
    _sliderRealView.frame = frame;
    _thumbControl.frame = CGRectMake(0, 0, _qy_thumbWH, _qy_thumbWH);
    
    self.qy_sliderValue = _qy_sliderValue;
    self.qy_cacheValue = _qy_cacheValue;
}


#pragma mark - public

- (void)qy_updateCacheValue:(CGFloat)value
{
    self.qy_cacheValue = value;
}

- (void)qy_updateSliderValue:(CGFloat)value
{
    if (_slidering) {
        return;
    }
    [self p_updateSliderValue:value];
}

- (void)p_updateSliderValue:(CGFloat)value
{
    self.qy_sliderValue = value;
}


#pragma mark - event

- (void)p_tapGesture:(UITapGestureRecognizer *)tapGesture
{
    
    CGPoint point = [tapGesture locationInView:self];
    
    //计算进度
    CGFloat value = (point.x - _sliderBgView.frame.origin.x) * 1.0 / _sliderBgView.frame.size.width;
    value = kAdjustValue(value);
    
    //更新进度
    self.qy_sliderValue = value;
    
    if ([_delegate respondsToSelector:@selector(qy_sliderEndSlider:value:)]) {
        [_delegate qy_sliderEndSlider:self value:value];
    }
    
    DLog(@"tap value = %f", value);
}

- (void)p_controlTouchBegin
{
    if (_delegate && [_delegate respondsToSelector:@selector(qy_sliderStartSlider:)]) {
        [_delegate qy_sliderStartSlider:self];
    }
    _slidering = YES;
}

- (void)p_controlTouchEnded
{
    if ([_delegate respondsToSelector:@selector(qy_sliderEndSlider:value:)]) {
        [_delegate qy_sliderEndSlider:self value:_qy_sliderValue];
    }
    
    _slidering = NO;
    DLog(@"end value = %f", _qy_sliderValue);
}

- (void)p_controlDragMoving:(UIControl *)control event:(UIEvent *)event
{
    CGPoint point = [event.allTouches.anyObject locationInView:self];
    
    //计算进度
    CGFloat value = (point.x - _sliderBgView.frame.origin.x) * 1.0 / _sliderBgView.frame.size.width;
    value = kAdjustValue(value);
    
    //更新进度
    self.qy_sliderValue = value;
    
    if ([_delegate respondsToSelector:@selector(qy_sliderEndSlider:value:)]) {
        [_delegate qy_sliderEndSlider:self value:value];
    }
    
    DLog(@"value = %f", value);
}


#pragma mark - setter

- (void)setQy_sliderValue:(CGFloat)qy_sliderValue
{
    
    _qy_sliderValue = kAdjustValue(qy_sliderValue);
    
    /** 滑块进度 [0.f - 1.f] */
    _sliderProgressView.frame = CGRectMake(_sliderProgressView.frame.origin.x, _sliderProgressView.frame.origin.y, _sliderBgView.frame.size.width * _qy_sliderValue, _sliderProgressView.frame.size.height);
    
    _thumbControl.frame = CGRectMake((_sliderBgView.frame.size.width - _thumbControl.frame.size.width) * qy_sliderValue, _thumbControl.frame.origin.y, _thumbControl.frame.size.width, _thumbControl.frame.size.height);
}

- (void)setQy_cacheValue:(CGFloat)qy_cacheValue
{
    /** 缓冲进度 [0.f - 1.f]*/
    _qy_cacheValue = kAdjustValue(qy_cacheValue);
    
    _sliderRealView.frame = CGRectMake(_sliderRealView.frame.origin.x, _sliderRealView.frame.origin.y, _sliderBgView.frame.size.width * _qy_sliderValue, _sliderRealView.frame.size.height);
}

- (void)setQy_sliderHeight:(CGFloat)qy_sliderHeight
{
    /** 滑杆高度 默认3.0 */
    _qy_sliderHeight = qy_sliderHeight;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setQy_thumbWH:(CGFloat)qy_thumbWH
{
    /** 滑块宽高 默认11.0 */
    _qy_thumbWH = qy_thumbWH;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


#pragma mark - layoutOfUI

- (void)layoutOfUI
{
    [self layoutUIOfSelf];
    [self layoutUIOfSliderBgView];
    [self layoutUIOfSliderRealView];
    [self layoutUIOfSliderProgressView];
    [self layoutUIOfThumbControl];
}

- (void)layoutUIOfSelf
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    _qy_sliderValue = 0.0;
    _qy_cacheValue = 0.0;
    
    _qy_sliderHeight = 3.0;
    _qy_thumbWH = 11.0;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapGesture:)];
    [self addGestureRecognizer:gesture];
}

- (void)layoutUIOfSliderBgView
{
    _sliderBgView = [[UIView alloc] initWithFrame:[self p_viewOriginFrame]];
    _sliderBgView.backgroundColor = self.qy_maximumTrackTintColor;
    _sliderBgView.layer.cornerRadius = _qy_sliderHeight / 2.0;
    _sliderBgView.clipsToBounds = YES;
    [self addSubview:_sliderBgView];
}

- (void)layoutUIOfSliderRealView
{
    _sliderRealView = [[UIView alloc] initWithFrame:[self p_viewOriginFrame]];
    _sliderRealView.backgroundColor = self.qy_cacheProgressTintColor;
    _sliderRealView.layer.cornerRadius = _qy_sliderHeight / 2.0;
    _sliderRealView.clipsToBounds = YES;
    [self addSubview:_sliderRealView];
}

- (void)layoutUIOfSliderProgressView
{
    _sliderProgressView = [[UIView alloc] initWithFrame:[self p_viewOriginFrame]];
    _sliderProgressView.backgroundColor = self.qy_minimumTrackTintColor;
    _sliderProgressView.layer.cornerRadius = _qy_sliderHeight / 2.0;
    _sliderProgressView.clipsToBounds = YES;
    [self addSubview:_sliderProgressView];
}

- (void)layoutUIOfThumbControl
{
    _thumbControl = [[UIControl alloc] init];
    [_thumbControl addTarget:self action:@selector(p_controlTouchBegin) forControlEvents:UIControlEventTouchDown];
    [_thumbControl addTarget:self action:@selector(p_controlTouchEnded) forControlEvents:UIControlEventTouchCancel];
    [_thumbControl addTarget:self action:@selector(p_controlTouchEnded) forControlEvents:UIControlEventTouchUpInside];
    [_thumbControl addTarget:self action:@selector(p_controlTouchEnded) forControlEvents:UIControlEventTouchUpOutside];
    [_thumbControl addTarget:self action:@selector(p_controlDragMoving:event:) forControlEvents:UIControlEventTouchDragInside];
    _thumbControl.backgroundColor = self.qy_thumbTintColor;
    _thumbControl.frame = CGRectMake(0, 0, _qy_thumbWH, _qy_thumbWH);
    [self addSubview:_thumbControl];
    _thumbControl.layer.cornerRadius = _qy_thumbWH / 2.0;
    _thumbControl.clipsToBounds = YES;
    _thumbControl.userInteractionEnabled = YES;
}


#pragma mark - getter

- (UIColor *)qy_maximumTrackTintColor
{
    if (nil == _qy_maximumTrackTintColor) {
        _qy_maximumTrackTintColor = [UIColor lightGrayColor];
    }
    return _qy_maximumTrackTintColor;
}

- (void)setQy_maximumTrackTintColor:(UIColor *)qy_maximumTrackTintColor
{
    _qy_maximumTrackTintColor = qy_maximumTrackTintColor;
    _sliderBgView.backgroundColor = qy_maximumTrackTintColor;
}

- (UIColor *)qy_minimumTrackTintColor
{
    if (nil == _qy_minimumTrackTintColor) {
        _qy_minimumTrackTintColor = [UIColor whiteColor];
    }
    return _qy_minimumTrackTintColor;
}

- (void)setQy_minimumTrackTintColor:(UIColor *)qy_minimumTrackTintColor
{
    _qy_minimumTrackTintColor = qy_minimumTrackTintColor;
    _sliderProgressView.backgroundColor = qy_minimumTrackTintColor;
}

- (UIColor *)qy_cacheProgressTintColor
{
    if (nil == _qy_cacheProgressTintColor) {
        _qy_cacheProgressTintColor = [UIColor grayColor];
    }
    return _qy_cacheProgressTintColor;
}

- (void)setQy_cacheProgressTintColor:(UIColor *)qy_cacheProgressTintColor
{
    _qy_cacheProgressTintColor = qy_cacheProgressTintColor;
    _sliderRealView.backgroundColor = qy_cacheProgressTintColor;
}

- (UIColor *)qy_thumbTintColor
{
    if (nil == _qy_thumbTintColor) {
        _qy_thumbTintColor = [UIColor whiteColor];
    }
    return _qy_thumbTintColor;
}

- (void)setQy_thumbTintColor:(UIColor *)qy_thumbTintColor
{
    _qy_thumbTintColor = qy_thumbTintColor;
    _thumbControl.backgroundColor = qy_thumbTintColor;
}

@end
