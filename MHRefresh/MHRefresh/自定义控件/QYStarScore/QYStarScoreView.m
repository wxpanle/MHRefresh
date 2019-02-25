//
//  QYStarScoreView.m
//  MHRefresh
//
//  Created by panle on 2019/1/23.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYStarScoreView.h"

static NSInteger kStarDefaultNumber = 5;

@interface QYStarScoreView ()

@property (nonatomic, assign, readwrite) NSInteger starNumber;

@property (nonatomic, strong) UIView *unselectedStarView;
@property (nonatomic, strong) UIView *selectedStarView;

@property (nonatomic, weak) UITapGestureRecognizer *tapGesture;
@property (nonatomic, weak) UIPanGestureRecognizer *panGesture;

@end

@implementation QYStarScoreView

#pragma mark - init

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame starCount:kStarDefaultNumber];
}

- (instancetype)initWithFrame:(CGRect)frame starCount:(NSInteger)starCount
{
    if (self = [super initWithFrame:frame]) {
        _starNumber = starCount;
        [self layoutOfUI];
    }
    return self;
}


#pragma mark - event

- (void)p_tapGestureEvent:(UITapGestureRecognizer *)tapgesture
{
    CGPoint point = [tapgesture locationInView:self];
    [self p_updateStarViewWithRatio:[self p_pointToRatio:point]];
}

- (void)p_panGestureEvent:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture locationInView:self];
    [self p_updateStarViewWithRatio:[self p_pointToRatio:point]];
}

- (void)p_updateStarViewWithRatio:(CGFloat)ratio {
    [self p_updateStarViewWithWidth:[self p_selectedViewWidthWithRatio:ratio]];
}

- (void)p_updateStarViewWithWidth:(CGFloat)width
{
    CGFloat rWidth = width;
    
    if (rWidth < CGFLOAT_MIN) {
        rWidth = CGFLOAT_MIN;
    } else if (rWidth > [self p_originWidth]) {
        rWidth = [self p_originWidth];
    }
    
    _selectedStarView.frame = CGRectMake(_selectedStarView.frame.origin.x, _selectedStarView.frame.origin.y, rWidth, _selectedStarView.frame.size.height);
    
    CGFloat currentScore = [self p_adjustScoreWithScore:(width / [self p_originWidth] * (_maximumScore - _minimumScore))];

    if (_currentScore != currentScore) {
        _currentScore = currentScore;
        [self p_callBackScore];
    }
}

- (CGFloat)p_originWidth
{
    return self.frame.size.width - _edgeInsets.left - _edgeInsets.right;
}

- (CGFloat)p_selectedViewWidthWithRatio:(CGFloat)ratio
{
    if (ratio < 0.f || ratio > 1.f) {
        return CGFLOAT_MIN;
    }
    
    CGFloat width = 0.0f;
    
    switch (_starScoreType) {
        case QYStarScoreTypeHalf: {
            
            CGFloat rRatio = _starNumber * ratio;
            CGFloat z = floorf(rRatio);
            CGFloat s = rRatio - z;
            
            if (s > 0.5f) {
                rRatio = z + 1.0f;
            } else if (s <= 0.5f && s >= CGFLOAT_MIN) {
                rRatio = z + 0.5f;
            }
            
            width = [self p_starSize].width * rRatio + (_starSpace * floor(rRatio));
        }
            break;
            
        case QYStarScoreTypeWhole:
            width = [self p_starSize].width * ceilf(_starNumber * ratio) + _starSpace * floor(_starNumber * ratio);
            break;
            
        case QYStarScoreTypeRandom:
            width = [self p_starSize].width * ratio * _starNumber + _starSpace * floor(_starNumber * ratio);
            break;
    }
    
    return width;
}


#pragma mark - private

- (CGFloat)p_pointToRatio:(CGPoint)point
{
    // 坐标 转 所选中的比例
    if (point.x < _edgeInsets.left) {
        return 0.f;
    } else if (point.x > _edgeInsets.left + [self p_originWidth]) {
        return 1.f;
    } else {
        return (point.x - _edgeInsets.left) / [self p_originWidth];
    }
}


#pragma mark - layout

- (void)layoutOfUI
{
    [self layoutUIOfSelf];
    [self layoutUIOfStarImageViews];
    [self layoutOfStarFrame];
}

- (void)layoutUIOfSelf
{
    _starScoreStyle = QYStarScoreStyleDefault;
    _edgeInsets = UIEdgeInsetsMake(2.f, 2.f, 2.f, 2.f);
    _starSpace = 5.0;
    _maximumScore = 10.f;
    _minimumScore = 0.f;
    _eventEnable = YES;
}

- (void)layoutUIOfStarImageViews
{

    _unselectedStarView = [[UIView alloc] init];
    [self addSubview:_unselectedStarView];
    
    _selectedStarView = [[UIView alloc] init];
    _selectedStarView.clipsToBounds = YES;
    [self addSubview:_selectedStarView];

    for (NSInteger i = 0; i < _starNumber; i++) {
        
        UIImageView *unselectedImageView = [[UIImageView alloc] initWithImage:self.unselectedStarImage];
        [_unselectedStarView addSubview:unselectedImageView];
        
        UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:self.selectedStarImage];
        [_selectedStarView addSubview:selectedImageView];
    }
}

- (void)layoutOfStarFrame
{
    if (CGRectGetWidth(_unselectedStarView.frame) == self.frame.size.width &&
        CGRectGetHeight(_unselectedStarView.frame) == self.frame.size.height) {
        return;
    }
    
    _unselectedStarView.frame = _selectedStarView.frame = CGRectMake(_edgeInsets.left, _edgeInsets.top, self.frame.size.width - _edgeInsets.left - _edgeInsets.right, self.frame.size.height - _edgeInsets.top - _edgeInsets.bottom);
    
    CGSize starSize = [self p_starSize];
    
    for (NSInteger i = 0; i < _starNumber; i++) {
        
        if (_unselectedStarView.subviews.count < i || _selectedStarView.subviews.count < i) {
            break;
        }
        
        UIImageView *unselecetdImageView = self.unselectedStarView.subviews[i];
        UIImageView *selectedImageView = self.selectedStarView.subviews[i];

        CGRect imageFrame = CGRectMake(i * starSize.width + i * _starSpace, _selectedStarView.frame.size.height / 2.0 - starSize.height / 2.0, starSize.width, starSize.height);
        
        unselecetdImageView.frame = imageFrame;
        selectedImageView.frame = imageFrame;
    }
}

- (CGSize)p_starSize
{
    NSAssert((_edgeInsets.left + _edgeInsets.right + (_starNumber - 1) * _starSpace) < self.frame.size.width, @"视图间距不够");
    
    CGFloat w = (self.frame.size.width - _edgeInsets.left - _edgeInsets.right - (_starNumber - 1) * _starSpace) / _starNumber;
    CGFloat h = self.frame.size.height - _edgeInsets.top - _edgeInsets.bottom;
    return CGSizeMake(w, h);
}

- (CGFloat)p_adjustScoreWithScore:(CGFloat)score {
    
    if (score < _minimumScore) {
        return _minimumScore;
    } else if (score > _maximumScore) {
        return _maximumScore;
    } else {
        return score;
    }
}

- (void)p_callBackScore {
    if (_scoreUpdateCallBack) {
        _scoreUpdateCallBack(_currentScore);
    }
}

#pragma mark - setter

- (void)setStarSpace:(CGFloat)starSpace
{
    _starSpace = starSpace > 0.0f ? starSpace : 0.01f;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setEventEnable:(BOOL)eventEnable
{
    
    _eventEnable = eventEnable;
    
    if (_eventEnable == YES) {
        
        if (nil == _tapGesture) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapGestureEvent:)];
            [self addGestureRecognizer:tapGesture];
            _tapGesture = tapGesture;
        }
        
        if (nil == _panGesture) {
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_panGestureEvent:)];
            [self addGestureRecognizer:panGesture];
            _panGesture = panGesture;
        }
    }
    
    self.userInteractionEnabled = _eventEnable;
    _tapGesture.enabled = _eventEnable;
    _panGesture.enabled = _eventEnable;
}

- (void)setUnselectedStarImage:(UIImage *)unselectedStarImage
{
    _unselectedStarImage = unselectedStarImage;
    [_unselectedStarView.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.image = unselectedStarImage;
    }];
}

- (void)setSelectedStarImage:(UIImage *)selectedStarImage
{
    _selectedStarImage = selectedStarImage;
    [_selectedStarView.subviews enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.image = selectedStarImage;
    }];
}

- (void)setMaximumScore:(CGFloat)maximumScore
{
    _maximumScore = maximumScore;
    
    if (_maximumScore < 0.f) {
        _maximumScore = 0.f;
    } else if(_maximumScore < _minimumScore) {
        _maximumScore = _minimumScore + 1.f;
    }
}

- (void)setMinimumScore:(CGFloat)minimumScore
{
    _minimumScore = minimumScore;
    
    if (_minimumScore < 0.f) {
        _minimumScore = 0.f;
    }
}

- (void)setCurrentScore:(CGFloat)currentScore
{
    _currentScore = [self p_adjustScoreWithScore:currentScore];
    [self p_updateStarViewWithRatio:(_currentScore - _minimumScore) / (_maximumScore - _minimumScore)];
    [self p_callBackScore];
}

- (void)dealloc
{
    _scoreUpdateCallBack = nil;
}

@end
