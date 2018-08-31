//
//  iCarousel.m
//
//  Version 1.8.3
//
//  Created by Nick Lockwood on 01/04/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/iCarousel
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "iCarousel.h"
#import <objc/message.h>
#import <tgmath.h>


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


#if !defined(__has_warning) || __has_warning("-Wreceiver-is-weak")
# pragma GCC diagnostic ignored "-Wreceiver-is-weak"
#endif
//重复设置weak属性
#pragma clang diagnostic ignored "-Warc-repeated-use-of-weak"
//缺失属性合成
#pragma clang diagnostic ignored "-Wobjc-missing-property-synthesis"
//实例变量被直接访问
#pragma clang diagnostic ignored "-Wdirect-ivar-access"
//常量没有被使用
#pragma clang diagnostic ignored "-Wunused-macros"
#pragma clang diagnostic ignored "-Wconversion"
//格式内容不是一个字符串文字
#pragma clang diagnostic ignored "-Wformat-nonliteral"
//局部有用
#pragma clang diagnostic ignored "-Wpartial-availability"
//双精度密目
#pragma clang diagnostic ignored "-Wdouble-promotion"
#pragma clang diagnostic ignored "-Wselector"
#pragma clang diagnostic ignored "-Wgnu"

//最小触发时长
#define MIN_TOGGLE_DURATION 0.2
//最大触发时长
#define MAX_TOGGLE_DURATION 0.4
//滚动时长
#define SCROLL_DURATION 0.4
//插入时长
#define INSERT_DURATION 0.4
//减速临界值
#define DECELERATE_THRESHOLD 0.1
//滚动速度临界值
#define SCROLL_SPEED_THRESHOLD 2.0
//滚动减速临界值
#define SCROLL_DISTANCE_THRESHOLD 0.1
//减速因子
#define DECELERATION_MULTIPLIER 30.0
//浮动误差
#define FLOAT_ERROR_MARGIN 0.000001

//最大可用时长
#ifdef ICAROUSEL_MACOS
#define MAX_VISIBLE_ITEMS 50
#else
#define MAX_VISIBLE_ITEMS 30
#endif


@implementation NSObject (iCarousel)

- (NSUInteger)numberOfPlaceholdersInCarousel:(__unused iCarousel *)carousel { return 0; }
- (void)carouselWillBeginScrollingAnimation:(__unused iCarousel *)carousel {}
- (void)carouselDidEndScrollingAnimation:(__unused iCarousel *)carousel {}
- (void)carouselDidScroll:(__unused iCarousel *)carousel {}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel {}
- (void)carouselWillBeginDragging:(__unused iCarousel *)carousel {}
- (void)carouselDidEndDragging:(__unused iCarousel *)carousel willDecelerate:(__unused BOOL)decelerate {}
- (void)carouselWillBeginDecelerating:(__unused iCarousel *)carousel {}
- (void)carouselDidEndDecelerating:(__unused iCarousel *)carousel {}

- (BOOL)carousel:(__unused iCarousel *)carousel shouldSelectItemAtIndex:(__unused NSInteger)index { return YES; }
- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(__unused NSInteger)index {}

- (CGFloat)carouselItemWidth:(__unused iCarousel *)carousel { return 0; }
- (CATransform3D)carousel:(__unused iCarousel *)carousel
   itemTransformForOffset:(__unused CGFloat)offset
            baseTransform:(CATransform3D)transform { return transform; }
- (CGFloat)carousel:(__unused iCarousel *)carousel
     valueForOption:(__unused iCarouselOption)option
        withDefault:(CGFloat)value { return value; }

@end


@interface iCarousel ()

//内容承载view
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableDictionary *itemViews;
@property (nonatomic, strong) NSMutableSet *itemViewPool;
@property (nonatomic, strong) NSMutableSet *placeholderViewPool;
@property (nonatomic, assign) CGFloat previousScrollOffset;
@property (nonatomic, assign) NSInteger previousItemIndex;
@property (nonatomic, assign) NSInteger numberOfPlaceholdersToShow;
//可见item个数
@property (nonatomic, assign) NSInteger numberOfVisibleItems;
//内容宽度
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat offsetMultiplier;
@property (nonatomic, assign) CGFloat startOffset;
@property (nonatomic, assign) CGFloat endOffset;
//滚动时长
@property (nonatomic, assign) NSTimeInterval scrollDuration;
//滚动中
@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) CGFloat startVelocity;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//减速中
@property (nonatomic, assign, getter = isDecelerating) BOOL decelerating;
//以前的 早先的
@property (nonatomic, assign) CGFloat previousTranslation;
//轮播
@property (nonatomic, assign, getter = isWrapEnabled) BOOL wrapEnabled;
//拖动
@property (nonatomic, assign, getter = isDragging) BOOL dragging;
//结束拖动
@property (nonatomic, assign) BOOL didDrag;
//触发时间
@property (nonatomic, assign) NSTimeInterval toggleTime;

NSComparisonResult compareViewDepth(UIView *view1, UIView *view2, iCarousel *self);

@end


@implementation iCarousel

#pragma mark - init

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUp];
    }
    return self;
}

#pragma mark -
#pragma mark Initialisation

//初始化
- (void)setUp {
    //减速比例
    _decelerationRate = 0.95;
    //滚动可用
    _scrollEnabled = YES;
    //弹簧可用
    _bounces = YES;
    //偏移因子
    _offsetMultiplier = 1.0;
    //透视度
    _perspective = -1.0/500.0;
    //内容偏移
    _contentOffset = CGSizeZero;
    //位置偏移
    _viewpointOffset = CGSizeZero;
    //滚动速度
    _scrollSpeed = 1.0;
    //弹跳距离
    _bounceDistance = 1.0;
    //在item边界停止
    _stopAtItemBoundary = YES;
    //滚动去边界
    _scrollToItemBoundary = YES;
    //忽略垂直条
    _ignorePerpendicularSwipes = YES;
    _centerItemWhenSelected = YES;
    
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    
    //设置约束
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //add pan gesture recogniser  拖动手势
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    panGesture.delegate = (id <UIGestureRecognizerDelegate>)self;
    [_contentView addGestureRecognizer:panGesture];
    
    //add tap gesture recogniser  单击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapGesture.delegate = (id <UIGestureRecognizerDelegate>)self;
    [_contentView addGestureRecognizer:tapGesture];
    
    [self addSubview:_contentView];
    
    if (_dataSource) {
        //加载数据
        [self reloadData];
    }
}

//设置数据源代理
- (void)setDataSource:(id<iCarouselDataSource>)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        if (_dataSource) {
            [self reloadData];
        }
    }
}

//设置代理
- (void)setDelegate:(id<iCarouselDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        if (_delegate && _dataSource) {
            //设置当前需要更新数据
            [self setNeedsLayout];
        }
    }
}

- (void)setType:(iCarouselType)type {
    if (_type != type) {
        _type = type;
        [self layOutItemViews];
    }
}

- (void)setVertical:(BOOL)vertical {
    if (_vertical != vertical) {
        _vertical = vertical;
        [self layOutItemViews];
    }
}

//设置滚动偏移
- (void)setScrollOffset:(CGFloat)scrollOffset {
    _scrolling = NO;
    _decelerating = NO;
    _startOffset = scrollOffset;
    _endOffset = scrollOffset;
    
    //fabs  求浮点数x的绝对值
    if (fabs(_scrollOffset - scrollOffset) > 0.0) {
        _scrollOffset = scrollOffset;
        //深度排序
        [self depthSortViews];
        [self didScroll];
    }
}

//滚动到某一个下标
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex {
    [self setScrollOffset:currentItemIndex];
}

//设置透明度
- (void)setPerspective:(CGFloat)perspective {
    _perspective = perspective;
    [self transformItemViews];
}

- (void)setViewpointOffset:(CGSize)viewpointOffset {
    if (!CGSizeEqualToSize(_viewpointOffset, viewpointOffset)) {
        _viewpointOffset = viewpointOffset;
        [self transformItemViews];
    }
}

//设置当前内容的偏移
- (void)setContentOffset:(CGSize)contentOffset {
    if (!CGSizeEqualToSize(_contentOffset, contentOffset)) {
        _contentOffset = contentOffset;
        [self layOutItemViews];
    }
}

//设置自动滚动
- (void)setAutoscroll:(CGFloat)autoscroll {
    _autoscroll = autoscroll;
    if (autoscroll != 0.0) [self startAnimation];
}

//push动画
- (void)pushAnimationState:(BOOL)enabled {
    [CATransaction begin];
    [CATransaction setDisableActions:!enabled];
}

//pop动画
- (void)popAnimationState {
    [CATransaction commit];
}


#pragma mark -
#pragma mark View management

//屏幕范围内可见视图
- (NSArray *)indexesForVisibleItems {
    return [[_itemViews allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)visibleItemViews {
    NSArray *indexes = [self indexesForVisibleItems];
    //如果没有发现key值对应的键  则使用 [NSNull null] 对象  替代
    return [_itemViews objectsForKeys:indexes notFoundMarker:[NSNull null]];
}

- (UIView *)itemViewAtIndex:(NSInteger)index {
    return _itemViews[@(index)];
}

- (UIView *)currentItemView {
    return [self itemViewAtIndex:self.currentItemIndex];
}

- (NSInteger)indexOfItemView:(UIView *)view {
    //用isEqual方法作为一个对比  返回下标
    NSInteger index = [[_itemViews allValues] indexOfObject:view];
    if (index != NSNotFound) {
        return [[_itemViews allKeys][index] integerValue];
    }
    return NSNotFound;
}

- (NSInteger)indexOfItemViewOrSubview:(UIView *)view {
    NSInteger index = [self indexOfItemView:view];
    if (index == NSNotFound && view.superview && view != _contentView) {
        return [self indexOfItemViewOrSubview:(UIView *__nonnull)view.superview];
    }
    return index;
}

//获取某一点的view
- (UIView *)itemViewAtPoint:(CGPoint)point {
    for (UIView *view in [[[_itemViews allValues] sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))compareViewDepth context:(__bridge void *)self] reverseObjectEnumerator]) {
        if ([view.superview.layer hitTest:point]) {
            return view;
        }
    }
    return nil;
}

- (void)setItemView:(UIView *)view forIndex:(NSInteger)index {
    _itemViews[@(index)] = view;
}

- (void)removeViewAtIndex:(NSInteger)index {
    NSMutableDictionary *newItemViews = [NSMutableDictionary dictionaryWithCapacity:[_itemViews count] - 1];
    for (NSNumber *number in [self indexesForVisibleItems]) {
        NSInteger i = [number integerValue];
        if (i < index) {
            newItemViews[number] = _itemViews[number];
        } else if (i > index) {
            newItemViews[@(i - 1)] = _itemViews[number];
        }
    }
    self.itemViews = newItemViews;
}

- (void)insertView:(UIView *)view atIndex:(NSInteger)index {
    NSMutableDictionary *newItemViews = [NSMutableDictionary dictionaryWithCapacity:[_itemViews count] + 1];
    for (NSNumber *number in [self indexesForVisibleItems]) {
        NSInteger i = [number integerValue];
        if (i < index) {
            newItemViews[number] = _itemViews[number];
        } else {
            newItemViews[@(i + 1)] = _itemViews[number];
        }
    }
    if (view) {
        [self setItemView:view forIndex:index];
    }
    self.itemViews = newItemViews;
}


#pragma mark -
#pragma mark View layout

- (CGFloat)alphaForItemWithOffset:(CGFloat)offset {
    CGFloat fadeMin = (CGFloat)-INFINITY;
    CGFloat fadeMax = (CGFloat)INFINITY;
    CGFloat fadeRange = 1.0;
    CGFloat fadeMinAlpha = 0.0;
    switch (_type) {
        case iCarouselTypeTimeMachine: {
            fadeMax = 0.0;
            break;
        }
        case iCarouselTypeInvertedTimeMachine: {
            fadeMin = 0.0;
            break;
        }
        case iCarouselTypeCoverFlow:
        case iCarouselTypeCoverFlow2:
        case iCarouselTypeCustom:
        case iCarouselTypeCylinder:
        case iCarouselTypeInvertedCylinder:
        case iCarouselTypeRotary:
        case iCarouselTypeInvertedRotary:
        case iCarouselTypeWheel:
        case iCarouselTypeInvertedWheel:
        case iCarouselTypeLinear: {
            //do nothing
        }
    }
    fadeMin = [self valueForOption:iCarouselOptionFadeMin withDefault:fadeMin];
    fadeMax = [self valueForOption:iCarouselOptionFadeMax withDefault:fadeMax];
    fadeRange = [self valueForOption:iCarouselOptionFadeRange withDefault:fadeRange];
    fadeMinAlpha = [self valueForOption:iCarouselOptionFadeMinAlpha withDefault:fadeMinAlpha];

    CGFloat factor = 0.0;
    if (offset > fadeMax) {
        factor = offset - fadeMax;
    } else if (offset < fadeMin) {
        factor = fadeMin - offset;
    }
    return 1.0 - MIN(factor, fadeRange) / fadeRange * (1.0 - fadeMinAlpha);
}

- (CGFloat)valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    return _delegate? [_delegate carousel:self valueForOption:option withDefault:value]: value;
}

- (CATransform3D)transformForItemViewWithOffset:(CGFloat)offset {
    //set up base transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _perspective;
    transform = CATransform3DTranslate(transform, -_viewpointOffset.width, -_viewpointOffset.height, 0.0);

    //perform transform
    switch (_type) {
        case iCarouselTypeCustom: {
            return [_delegate carousel:self itemTransformForOffset:offset baseTransform:transform];
        }
        case iCarouselTypeLinear: {
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:1.0];
            if (_vertical) {
                return CATransform3DTranslate(transform, 0.0, offset * _itemWidth * spacing, 0.0);
            } else {
                return CATransform3DTranslate(transform, offset * _itemWidth * spacing, 0.0, 0.0);
            }
        }
        case iCarouselTypeRotary:
        case iCarouselTypeInvertedRotary: {
            CGFloat count = [self circularCarouselItemCount];
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:1.0];
            CGFloat arc = [self valueForOption:iCarouselOptionArc withDefault:M_PI * 2.0];
            CGFloat radius = [self valueForOption:iCarouselOptionRadius withDefault:MAX(_itemWidth * spacing / 2.0, _itemWidth * spacing / 2.0 / tan(arc/2.0/count))];
            CGFloat angle = [self valueForOption:iCarouselOptionAngle withDefault:offset / count * arc];
            
            if (_type == iCarouselTypeInvertedRotary) {
                radius = -radius;
                angle = -angle;
            }
            
            if (_vertical) {
                return CATransform3DTranslate(transform, 0.0, radius * sin(angle), radius * cos(angle) - radius);
            } else {
                return CATransform3DTranslate(transform, radius * sin(angle), 0.0, radius * cos(angle) - radius);
            }
        }
        case iCarouselTypeCylinder:
        case iCarouselTypeInvertedCylinder: {
            CGFloat count = [self circularCarouselItemCount];
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:1.0];
            CGFloat arc = [self valueForOption:iCarouselOptionArc withDefault:M_PI * 2.0];
            CGFloat radius = [self valueForOption:iCarouselOptionRadius withDefault:MAX(0.01, _itemWidth * spacing / 2.0 / tan(arc/2.0/count))];
            CGFloat angle = [self valueForOption:iCarouselOptionAngle withDefault:offset / count * arc];
            
            if (_type == iCarouselTypeInvertedCylinder) {
                radius = -radius;
                angle = -angle;
            }
            
            if (_vertical) {
                transform = CATransform3DTranslate(transform, 0.0, 0.0, -radius);
                transform = CATransform3DRotate(transform, angle, -1.0, 0.0, 0.0);
                return CATransform3DTranslate(transform, 0.0, 0.0, radius + 0.01);
            } else {
                transform = CATransform3DTranslate(transform, 0.0, 0.0, -radius);
                transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
                return CATransform3DTranslate(transform, 0.0, 0.0, radius + 0.01);
            }
        }
        case iCarouselTypeWheel:
        case iCarouselTypeInvertedWheel: {
            CGFloat count = [self circularCarouselItemCount];
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:1.0];
            CGFloat arc = [self valueForOption:iCarouselOptionArc withDefault:M_PI * 2.0];
            CGFloat radius = [self valueForOption:iCarouselOptionRadius withDefault:_itemWidth * spacing * count / arc];
            CGFloat angle = [self valueForOption:iCarouselOptionAngle withDefault:arc / count];
            
            if (_type == iCarouselTypeInvertedWheel) {
                radius = -radius;
                angle = -angle;
            }
            
            if (_vertical) {
                transform = CATransform3DTranslate(transform, -radius, 0.0, 0.0);
                transform = CATransform3DRotate(transform, angle * offset, 0.0, 0.0, 1.0);
                return CATransform3DTranslate(transform, radius, 0.0, offset * 0.01);
            } else {
                transform = CATransform3DTranslate(transform, 0.0, radius, 0.0);
                transform = CATransform3DRotate(transform, angle * offset, 0.0, 0.0, 1.0);
                return CATransform3DTranslate(transform, 0.0, -radius, offset * 0.01);
            }
        }
        case iCarouselTypeCoverFlow:
        case iCarouselTypeCoverFlow2: {
            CGFloat tilt = [self valueForOption:iCarouselOptionTilt withDefault:0.9];
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:0.25];
            CGFloat clampedOffset = MAX(-1.0, MIN(1.0, offset));

            if (_type == iCarouselTypeCoverFlow2) {
                if (_toggle > 0.0) {
                    if (offset <= -0.5) {
                        clampedOffset = -1.0;
                    } else if (offset <= 0.5) {
                        clampedOffset = -_toggle;
                    } else if (offset <= 1.5) {
                        clampedOffset = 1.0 - _toggle;
                    }
                } else {
                    if (offset > 0.5) {
                        clampedOffset = 1.0;
                    } else if (offset > -0.5) {
                        clampedOffset = -_toggle;
                    } else if (offset > -1.5) {
                        clampedOffset = - 1.0 - _toggle;
                    }
                }
            }
            
            CGFloat x = (clampedOffset * 0.5 * tilt + offset * spacing) * _itemWidth;
            CGFloat z = fabs(clampedOffset) * -_itemWidth * 0.5;
            
            if (_vertical) {
                transform = CATransform3DTranslate(transform, 0.0, x, z);
                return CATransform3DRotate(transform, -clampedOffset * M_PI_2 * tilt, -1.0, 0.0, 0.0);
            } else {
                transform = CATransform3DTranslate(transform, x, 0.0, z);
                return CATransform3DRotate(transform, -clampedOffset * M_PI_2 * tilt, 0.0, 1.0, 0.0);
            }
        }
        case iCarouselTypeTimeMachine:
        case iCarouselTypeInvertedTimeMachine: {
            CGFloat tilt = [self valueForOption:iCarouselOptionTilt withDefault:0.3];
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:1.0];
            
            if (_type == iCarouselTypeInvertedTimeMachine) {
                tilt = -tilt;
                offset = -offset;
            }
            
            if (_vertical) {
                return CATransform3DTranslate(transform, 0.0, offset * _itemWidth * tilt, offset * _itemWidth * spacing);
            } else {
                return CATransform3DTranslate(transform, offset * _itemWidth * tilt, 0.0, offset * _itemWidth * spacing);
            }
        }
    }
}

NSComparisonResult compareViewDepth(UIView *view1, UIView *view2, iCarousel *self) {
    //compare depths
    CATransform3D t1 = view1.superview.layer.transform;
    CATransform3D t2 = view2.superview.layer.transform;
    CGFloat z1 = t1.m13 + t1.m23 + t1.m33 + t1.m43;
    CGFloat z2 = t2.m13 + t2.m23 + t2.m33 + t2.m43;
    CGFloat difference = z1 - z2;
    
    //if depths are equal, compare distance from current view
    if (difference == 0.0) {
        CATransform3D t3 = [self currentItemView].superview.layer.transform;
        if (self.vertical) {
            CGFloat y1 = t1.m12 + t1.m22 + t1.m32 + t1.m42;
            CGFloat y2 = t2.m12 + t2.m22 + t2.m32 + t2.m42;
            CGFloat y3 = t3.m12 + t3.m22 + t3.m32 + t3.m42;
            difference = fabs(y2 - y3) - fabs(y1 - y3);
        }  else {
            CGFloat x1 = t1.m11 + t1.m21 + t1.m31 + t1.m41;
            CGFloat x2 = t2.m11 + t2.m21 + t2.m31 + t2.m41;
            CGFloat x3 = t3.m11 + t3.m21 + t3.m31 + t3.m41;
            difference = fabs(x2 - x3) - fabs(x1 - x3);
        }
    }
    return (difference < 0.0)? NSOrderedAscending: NSOrderedDescending;
}

- (void)depthSortViews {
    for (UIView *view in [[_itemViews allValues] sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))compareViewDepth context:(__bridge void *)self]) {
        [_contentView bringSubviewToFront:(UIView *__nonnull)view.superview];
    }
}

- (CGFloat)offsetForItemAtIndex:(NSInteger)index {
    //calculate relative position
    CGFloat offset = index - _scrollOffset;
    if (_wrapEnabled) {
        if (offset > _numberOfItems/2.0) {
            offset -= _numberOfItems;
        } else if (offset < -_numberOfItems/2.0) {
            offset += _numberOfItems;
        }
    }
    
    return offset;
}

- (UIView *)containView:(UIView *)view {
    //set item width
    if (!_itemWidth) {
        _itemWidth = _vertical? view.bounds.size.height: view.bounds.size.width;
    }
    
    //set container frame
    CGRect frame = view.bounds;
    frame.size.width = _vertical? frame.size.width: _itemWidth;
    frame.size.height = _vertical? _itemWidth: frame.size.height;
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    
    //set view frame
    frame = view.frame;
    frame.origin.x = (containerView.bounds.size.width - frame.size.width) / 2.0;
    frame.origin.y = (containerView.bounds.size.height - frame.size.height) / 2.0;
    view.frame = frame;
    [containerView addSubview:view];
    containerView.layer.opacity = 0;
    
    return containerView;
}

- (void)transformItemView:(UIView *)view atIndex:(NSInteger)index {
    //calculate offset
    CGFloat offset = [self offsetForItemAtIndex:index];
    
    //update alpha
    view.superview.layer.opacity = [self alphaForItemWithOffset:offset];

    //center view
    view.superview.center = CGPointMake(self.bounds.size.width/2.0 + _contentOffset.width,
                                        self.bounds.size.height/2.0 + _contentOffset.height);
    
    //enable/disable interaction
    view.superview.userInteractionEnabled = (!_centerItemWhenSelected || index == self.currentItemIndex);
  
    //account for retina
    view.superview.layer.rasterizationScale = [UIScreen mainScreen].scale;

    [view layoutIfNeeded];

    //special-case logic for iCarouselTypeCoverFlow2
    CGFloat clampedOffset = MAX(-1.0, MIN(1.0, offset));
    if (_decelerating || (_scrolling && !_dragging && !_didDrag) || (_autoscroll && !_dragging) ||
       (!_wrapEnabled && (_scrollOffset < 0 || _scrollOffset >= _numberOfItems - 1))) {
        if (offset > 0) {
            _toggle = (offset <= 0.5)? -clampedOffset: (1.0 - clampedOffset);
        } else {
            _toggle = (offset > -0.5)? -clampedOffset: (- 1.0 - clampedOffset);
        }
    }
    
    //calculate transform
    CATransform3D transform = [self transformForItemViewWithOffset:offset];
  
    //transform view
    view.superview.layer.transform = transform;
    
    //backface culling
    BOOL showBackfaces = view.layer.doubleSided;
    if (showBackfaces) {
        switch (_type) {
            case iCarouselTypeInvertedCylinder: {
                showBackfaces = NO;
                break;
            }
            case iCarouselTypeCoverFlow:
            case iCarouselTypeCoverFlow2:
            case iCarouselTypeCustom:
            case iCarouselTypeCylinder:
            case iCarouselTypeRotary:
            case iCarouselTypeInvertedRotary:
            case iCarouselTypeWheel:
            case iCarouselTypeInvertedWheel:
            case iCarouselTypeLinear:
            case iCarouselTypeTimeMachine:
            case iCarouselTypeInvertedTimeMachine: {
                showBackfaces = YES;
                break;
            }
        }
    }
    showBackfaces = !![self valueForOption:iCarouselOptionShowBackfaces withDefault:showBackfaces];
    
    //we can't just set the layer.doubleSided property because it doesn't block interaction
    //instead we'll calculate if the view is front-facing based on the transform
    view.superview.hidden = !(showBackfaces ?: (transform.m33 > 0.0));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.frame = self.bounds;
    [self layOutItemViews];
}

- (void)transformItemViews {
    for (NSNumber *number in _itemViews) {
        NSInteger index = [number integerValue];
        UIView *view = _itemViews[number];
        [self transformItemView:view atIndex:index];
    }
}

- (void)updateItemWidth {
    _itemWidth = [_delegate carouselItemWidth:self] ?: _itemWidth;
    if (_numberOfItems > 0) {
        if ([_itemViews count] == 0) {
            [self loadViewAtIndex:0];
        }
    } else if (_numberOfPlaceholders > 0) {
        if ([_itemViews count] == 0) {
            [self loadViewAtIndex:-1];
        }
    }
}

- (void)updateNumberOfVisibleItems {
    //get number of visible items
    switch (_type) {
        case iCarouselTypeLinear: {
            //exact number required to fill screen
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:1.0];
            CGFloat width = _vertical ? self.bounds.size.height: self.bounds.size.width;
            CGFloat itemWidth = _itemWidth * spacing;
            _numberOfVisibleItems = ceil(width / itemWidth) + 2;
            break;
        }
        case iCarouselTypeCoverFlow:
        case iCarouselTypeCoverFlow2: {
            //exact number required to fill screen
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:0.25];
            CGFloat width = _vertical ? self.bounds.size.height: self.bounds.size.width;
            CGFloat itemWidth = _itemWidth * spacing;
            _numberOfVisibleItems = ceil(width / itemWidth) + 2;
            break;
        }
        case iCarouselTypeRotary:
        case iCarouselTypeCylinder: {
            //based on count value
            _numberOfVisibleItems = [self circularCarouselItemCount];
            break;
        }
        case iCarouselTypeInvertedRotary:
        case iCarouselTypeInvertedCylinder: {
            //TODO: improve this
            _numberOfVisibleItems = ceil([self circularCarouselItemCount] / 2.0);
            break;
        }
        case iCarouselTypeWheel:
        case iCarouselTypeInvertedWheel: {
            //TODO: improve this
            CGFloat count = [self circularCarouselItemCount];
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:1.0];
            CGFloat arc = [self valueForOption:iCarouselOptionArc withDefault:M_PI * 2.0];
            CGFloat radius = [self valueForOption:iCarouselOptionRadius withDefault:_itemWidth * spacing * count / arc];
            if (radius - _itemWidth / 2.0 < MIN(self.bounds.size.width, self.bounds.size.height) / 2.0) {
                _numberOfVisibleItems = count;
            } else {
                _numberOfVisibleItems = ceil(count / 2.0) + 1;
            }
            break;
        }
        case iCarouselTypeTimeMachine:
        case iCarouselTypeInvertedTimeMachine:
        case iCarouselTypeCustom: {
            //slightly arbitrary number, chosen for performance reasons
            _numberOfVisibleItems = MAX_VISIBLE_ITEMS;
            break;
        }
    }
    _numberOfVisibleItems = MIN(MAX_VISIBLE_ITEMS, _numberOfVisibleItems);
    _numberOfVisibleItems = [self valueForOption:iCarouselOptionVisibleItems withDefault:_numberOfVisibleItems];
    _numberOfVisibleItems = MAX(0, MIN(_numberOfVisibleItems, _numberOfItems + _numberOfPlaceholdersToShow));

}

- (NSInteger)circularCarouselItemCount {
    NSInteger count = 0;
    switch (_type) {
        case iCarouselTypeRotary:
        case iCarouselTypeInvertedRotary:
        case iCarouselTypeCylinder:
        case iCarouselTypeInvertedCylinder:
        case iCarouselTypeWheel:
        case iCarouselTypeInvertedWheel: {
            //slightly arbitrary number, chosen for aesthetic reasons
            CGFloat spacing = [self valueForOption:iCarouselOptionSpacing withDefault:1.0];
            CGFloat width = _vertical ? self.bounds.size.height: self.bounds.size.width;
            count = MIN(MAX_VISIBLE_ITEMS, MAX(12, ceil(width / (spacing * _itemWidth)) * M_PI));
            count = MIN(_numberOfItems + _numberOfPlaceholdersToShow, count);
            break;
        }
        case iCarouselTypeCoverFlow:
        case iCarouselTypeCoverFlow2:
        case iCarouselTypeTimeMachine:
        case iCarouselTypeInvertedTimeMachine:
        case iCarouselTypeLinear:
        case iCarouselTypeCustom: {
            //not used for non-circular carousels
            return _numberOfItems + _numberOfPlaceholdersToShow;
        }
    }
    return [self valueForOption:iCarouselOptionCount withDefault:count];
}

- (void)layOutItemViews {
    //bail out if not set up yet
    if (!_dataSource || !_contentView) {
        return;
    }

    //update wrap
    switch (_type) {
        case iCarouselTypeRotary:
        case iCarouselTypeInvertedRotary:
        case iCarouselTypeCylinder:
        case iCarouselTypeInvertedCylinder:
        case iCarouselTypeWheel:
        case iCarouselTypeInvertedWheel: {
            _wrapEnabled = YES;
            break;
        }
        case iCarouselTypeCoverFlow:
        case iCarouselTypeCoverFlow2:
        case iCarouselTypeTimeMachine:
        case iCarouselTypeInvertedTimeMachine:
        case iCarouselTypeLinear:
        case iCarouselTypeCustom: {
            _wrapEnabled = NO;
            break;
        }
    }
    _wrapEnabled = !![self valueForOption:iCarouselOptionWrap withDefault:_wrapEnabled];
    
    //no placeholders on wrapped carousels
    _numberOfPlaceholdersToShow = _wrapEnabled? 0: _numberOfPlaceholders;
    
    //set item width
    [self updateItemWidth];
    
    //update number of visible items
    [self updateNumberOfVisibleItems];
    
    //prevent false index changed event
    _previousScrollOffset = self.scrollOffset;
    
    //update offset multiplier
    switch (_type) {
        case iCarouselTypeCoverFlow:
        case iCarouselTypeCoverFlow2: {
            _offsetMultiplier = 2.0;
            break;
        }
        case iCarouselTypeCylinder:
        case iCarouselTypeInvertedCylinder:
        case iCarouselTypeWheel:
        case iCarouselTypeInvertedWheel:
        case iCarouselTypeRotary:
        case iCarouselTypeInvertedRotary:
        case iCarouselTypeTimeMachine:
        case iCarouselTypeInvertedTimeMachine:
        case iCarouselTypeLinear:
        case iCarouselTypeCustom: {
            _offsetMultiplier = 1.0;
            break;
        }
    }
    _offsetMultiplier = [self valueForOption:iCarouselOptionOffsetMultiplier withDefault:_offsetMultiplier];

    //align
    if (!_scrolling && !_decelerating && !_autoscroll) {
        if (_scrollToItemBoundary && self.currentItemIndex != -1) {
            [self scrollToItemAtIndex:self.currentItemIndex animated:YES];
        } else {
            _scrollOffset = [self clampedOffset:_scrollOffset];
        }
    }
    
    //update views
    [self didScroll];
}


#pragma mark -
#pragma mark View queing

- (void)queueItemView:(UIView *)view {
    if (view) {
        [_itemViewPool addObject:view];
    }
}

- (void)queuePlaceholderView:(UIView *)view {
    if (view) {
        [_placeholderViewPool addObject:view];
    }
}

- (UIView *)dequeueItemView {
    UIView *view = [_itemViewPool anyObject];
    if (view) {
        [_itemViewPool removeObject:view];
    }
    return view;
}

- (UIView *)dequeuePlaceholderView {
    UIView *view = [_placeholderViewPool anyObject];
    if (view) {
        [_placeholderViewPool removeObject:view];
    }
    return view;
}


#pragma mark -
#pragma mark View loading

- (UIView *)loadViewAtIndex:(NSInteger)index withContainerView:(UIView *)containerView {
    [self pushAnimationState:NO];
    
    UIView *view = nil;
    if (index < 0) {
        view = [_dataSource carousel:self placeholderViewAtIndex:(NSInteger)(ceil((CGFloat)_numberOfPlaceholdersToShow/2.0)) + index reusingView:[self dequeuePlaceholderView]];
    } else if (index >= _numberOfItems) {
        view = [_dataSource carousel:self placeholderViewAtIndex:_numberOfPlaceholdersToShow/2.0 + index - _numberOfItems reusingView:[self dequeuePlaceholderView]];
    } else {
        view = [_dataSource carousel:self viewForItemAtIndex:index reusingView:[self dequeueItemView]];
    }
    
    if (view == nil) {
        view = [[UIView alloc] init];
    }
    
    [self setItemView:view forIndex:index];
    if (containerView) {
        //get old item view
        UIView *oldItemView = [containerView.subviews lastObject];
        if (index < 0 || index >= _numberOfItems) {
            [self queuePlaceholderView:oldItemView];
        } else {
            [self queueItemView:oldItemView];
        }
        
        //set container frame
        CGRect frame = containerView.bounds;
        if(_vertical) {
            frame.size.width = view.frame.size.width;
            frame.size.height = MIN(_itemWidth, view.frame.size.height);
        } else {
            frame.size.width = MIN(_itemWidth, view.frame.size.width);
            frame.size.height = view.frame.size.height;
        }
        containerView.bounds = frame;
        
        //set view frame
        frame = view.frame;
        frame.origin.x = (containerView.bounds.size.width - frame.size.width) / 2.0;
        frame.origin.y = (containerView.bounds.size.height - frame.size.height) / 2.0;
        view.frame = frame;
        
        //switch views
        [oldItemView removeFromSuperview];
        [containerView addSubview:view];
    } else {
        [_contentView addSubview:[self containView:view]];
    }
    view.superview.layer.opacity = 0.0;
    [self transformItemView:view atIndex:index];
    
    [self popAnimationState];
    
    return view;
}

- (UIView *)loadViewAtIndex:(NSInteger)index {
    return [self loadViewAtIndex:index withContainerView:nil];
}

- (void)loadUnloadViews {
    //set item width
    [self updateItemWidth];
    
    //update number of visible items
    [self updateNumberOfVisibleItems];
    
    //calculate visible view indices
    NSMutableSet *visibleIndices = [NSMutableSet setWithCapacity:_numberOfVisibleItems];
    NSInteger min = -(NSInteger)(ceil((CGFloat)_numberOfPlaceholdersToShow/2.0));
    NSInteger max = _numberOfItems - 1 + _numberOfPlaceholdersToShow/2;
    NSInteger offset = self.currentItemIndex - _numberOfVisibleItems/2;
    if (!_wrapEnabled) {
        offset = MAX(min, MIN(max - _numberOfVisibleItems + 1, offset));
    }
    for (NSInteger i = 0; i < _numberOfVisibleItems; i++) {
        NSInteger index = i + offset;
        if (_wrapEnabled) {
            index = [self clampedIndex:index];
        }
        CGFloat alpha = [self alphaForItemWithOffset:[self offsetForItemAtIndex:index]];
        if (alpha) {
            //only add views with alpha > 0
            [visibleIndices addObject:@(index)];
        }
    }
    
    //remove offscreen views
    for (NSNumber *number in [_itemViews allKeys]) {
        if (![visibleIndices containsObject:number]) {
            UIView *view = _itemViews[number];
            if ([number integerValue] < 0 || [number integerValue] >= _numberOfItems) {
                [self queuePlaceholderView:view];
            } else {
                [self queueItemView:view];
            }
            [view.superview removeFromSuperview];
            [(NSMutableDictionary *)_itemViews removeObjectForKey:number];
        }
    }
    
    //add onscreen views
    for (NSNumber *number in visibleIndices) {
        UIView *view = _itemViews[number];
        if (view == nil) {
            [self loadViewAtIndex:[number integerValue]];
        }
    }
}

- (void)reloadData {
    //remove old views
    for (UIView *view in [_itemViews allValues]) {
        [view.superview removeFromSuperview];
    }
    
    //bail out if not set up yet
    if (!_dataSource || !_contentView) {
        return;
    }
    
    //get number of items and placeholders
    _numberOfVisibleItems = 0;
    _numberOfItems = [_dataSource numberOfItemsInCarousel:self];
    _numberOfPlaceholders = [_dataSource numberOfPlaceholdersInCarousel:self];

    //reset view pools
    self.itemViews = [NSMutableDictionary dictionary];
    self.itemViewPool = [NSMutableSet set];
    self.placeholderViewPool = [NSMutableSet setWithCapacity:_numberOfPlaceholders];
    
    //layout views
    [self setNeedsLayout];
    
    //fix scroll offset
    if (_numberOfItems > 0 && _scrollOffset < 0.0) {
        [self scrollToItemAtIndex:0 animated:(_numberOfPlaceholders > 0)];
    }
}


#pragma mark -
#pragma mark Scrolling

- (NSInteger)clampedIndex:(NSInteger)index {
    if (_numberOfItems == 0) {
        return -1;
    } else if (_wrapEnabled) {
        return index - floor((CGFloat)index / (CGFloat)_numberOfItems) * _numberOfItems;
    } else {
        return MIN(MAX(0, index), MAX(0, _numberOfItems - 1));
    }
}

- (CGFloat)clampedOffset:(CGFloat)offset {
    if (_numberOfItems == 0) {
        return -1.0;
    } else if (_wrapEnabled) {
        return offset - floor(offset / (CGFloat)_numberOfItems) * _numberOfItems;
    } else {
        return MIN(MAX(0.0, offset), MAX(0.0, (CGFloat)_numberOfItems - 1.0));
    }
}

- (NSInteger)currentItemIndex {
    return [self clampedIndex:round(_scrollOffset)];
}

- (NSInteger)minScrollDistanceFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSInteger directDistance = toIndex - fromIndex;
    if (_wrapEnabled) {
        NSInteger wrappedDistance = MIN(toIndex, fromIndex) + _numberOfItems - MAX(toIndex, fromIndex);
        if (fromIndex < toIndex) {
            wrappedDistance = -wrappedDistance;
        }
        return (ABS(directDistance) <= ABS(wrappedDistance))? directDistance: wrappedDistance;
    }
    return directDistance;
}

- (CGFloat)minScrollDistanceFromOffset:(CGFloat)fromOffset toOffset:(CGFloat)toOffset {
    CGFloat directDistance = toOffset - fromOffset;
    if (_wrapEnabled) {
        CGFloat wrappedDistance = MIN(toOffset, fromOffset) + _numberOfItems - MAX(toOffset, fromOffset);
        if (fromOffset < toOffset) {
            wrappedDistance = -wrappedDistance;
        }
        return (fabs(directDistance) <= fabs(wrappedDistance))? directDistance: wrappedDistance;
    }
    return directDistance;
}

- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration {
    if (duration > 0.0) {
        _decelerating = NO;
        _scrolling = YES;
        _startTime = CACurrentMediaTime();
        _startOffset = _scrollOffset;
        _scrollDuration = duration;
        _endOffset = _startOffset + offset;
        if (!_wrapEnabled) {
            _endOffset = [self clampedOffset:_endOffset];
        }
        [_delegate carouselWillBeginScrollingAnimation:self];
        [self startAnimation];
    } else {
        self.scrollOffset += offset;
    }
}

- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration {
    [self scrollByOffset:[self minScrollDistanceFromOffset:_scrollOffset toOffset:offset] duration:duration];
}

- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration {
    if (duration > 0.0) {
        CGFloat offset = 0.0;
        if (itemCount > 0) {
            offset = (floor(_scrollOffset) + itemCount) - _scrollOffset;
        } else if (itemCount < 0) {
            offset = (ceil(_scrollOffset) + itemCount) - _scrollOffset;
        } else {
            offset = round(_scrollOffset) - _scrollOffset;
        }
        [self scrollByOffset:offset duration:duration];
    } else {
        self.scrollOffset = [self clampedIndex:_previousItemIndex + itemCount];
    }
}

- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration {
    [self scrollToOffset:index duration:duration];
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self scrollToItemAtIndex:index duration:animated? SCROLL_DURATION: 0];
}

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    index = [self clampedIndex:index];
    UIView *itemView = [self itemViewAtIndex:index];
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        [UIView setAnimationDelegate:itemView.superview];
        [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
        [self performSelector:@selector(queueItemView:) withObject:itemView afterDelay:0.1];
        itemView.superview.layer.opacity = 0.0;
        [UIView commitAnimations];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelay:0.1];
        [UIView setAnimationDuration:INSERT_DURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(depthSortViews)];
        [self removeViewAtIndex:index];
        _numberOfItems --;
        _wrapEnabled = !![self valueForOption:iCarouselOptionWrap withDefault:_wrapEnabled];
        [self updateNumberOfVisibleItems];
        _scrollOffset = self.currentItemIndex;
        [self didScroll];
        [UIView commitAnimations];

    } else {
        [self pushAnimationState:NO];
        [self queueItemView:itemView];
        [itemView.superview removeFromSuperview];
        [self removeViewAtIndex:index];
        _numberOfItems --;
        _wrapEnabled = !![self valueForOption:iCarouselOptionWrap withDefault:_wrapEnabled];
        _scrollOffset = self.currentItemIndex;
        [self didScroll];
        [self depthSortViews];
        [self popAnimationState];
    }
}

- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    _numberOfItems ++;
    _wrapEnabled = !![self valueForOption:iCarouselOptionWrap withDefault:_wrapEnabled];
    [self updateNumberOfVisibleItems];
    
    index = [self clampedIndex:index];
    [self insertView:nil atIndex:index];
    [self loadViewAtIndex:index];
    
    if (fabs(_itemWidth) < FLOAT_ERROR_MARGIN) {
        [self updateItemWidth];
    }
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:INSERT_DURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didScroll)];
        [self transformItemViews];
        [UIView commitAnimations];
        
    } else {
        [self pushAnimationState:NO];
        [self didScroll];
        [self popAnimationState];
    }
    
    if (_scrollOffset < 0.0) {
        [self scrollToItemAtIndex:0 animated:(animated && _numberOfPlaceholders)];
    }
}

- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated {
    //get container view
    UIView *containerView = [[self itemViewAtIndex:index] superview];
    if (containerView) {
        if (animated) {
            //fade transition
            CATransition *transition = [CATransition animation];
            transition.duration = INSERT_DURATION;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionFade;
            [containerView.layer addAnimation:transition forKey:nil];
        }
        
        //reload view
        [self loadViewAtIndex:index withContainerView:containerView];
    }
}

#pragma mark -
#pragma mark Animation

- (void)startAnimation {
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:1.0/60.0
                                             target:self
                                           selector:@selector(step)
                                           userInfo:nil
                                            repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}

- (void)stopAnimation {
    [_timer invalidate];
    _timer = nil;
}

- (CGFloat)decelerationDistance {
    CGFloat acceleration = -_startVelocity * DECELERATION_MULTIPLIER * (1.0 - _decelerationRate);
    return -pow(_startVelocity, 2.0) / (2.0 * acceleration);
}

- (BOOL)shouldDecelerate {
    return (fabs(_startVelocity) > SCROLL_SPEED_THRESHOLD) &&
    (fabs([self decelerationDistance]) > DECELERATE_THRESHOLD);
}

- (BOOL)shouldScroll {
    return (fabs(_startVelocity) > SCROLL_SPEED_THRESHOLD) &&
    (fabs(_scrollOffset - self.currentItemIndex) > SCROLL_DISTANCE_THRESHOLD);
}

- (void)startDecelerating {
    CGFloat distance = [self decelerationDistance];
    _startOffset = _scrollOffset;
    _endOffset = _startOffset + distance;
    if (_pagingEnabled) {
        if (distance > 0.0) {
            _endOffset = ceil(_startOffset);
        } else {
            _endOffset = floor(_startOffset);
        }
    } else if (_stopAtItemBoundary) {
        if (distance > 0.0) {
            _endOffset = ceil(_endOffset);
        } else {
            _endOffset = floor(_endOffset);
        }
    }
    if (!_wrapEnabled) {
        if (_bounces) {
            _endOffset = MAX(-_bounceDistance, MIN(_numberOfItems - 1.0 + _bounceDistance, _endOffset));
        } else {
            _endOffset = [self clampedOffset:_endOffset];
        }
    }
    distance = _endOffset - _startOffset;
    
    _startTime = CACurrentMediaTime();
    _scrollDuration = fabs(distance) / fabs(0.5 * _startVelocity);   
    
    if (distance != 0.0) {
        _decelerating = YES;
        [self startAnimation];
    }
}

- (CGFloat)easeInOut:(CGFloat)time {
    return (time < 0.5)? 0.5 * pow(time * 2.0, 3.0): 0.5 * pow(time * 2.0 - 2.0, 3.0) + 1.0;
}

- (void)step {
    [self pushAnimationState:NO];
    NSTimeInterval currentTime = CACurrentMediaTime();
    double delta = currentTime - _lastTime;
    _lastTime = currentTime;
    
    if (_scrolling && !_dragging) {
        NSTimeInterval time = MIN(1.0, (currentTime - _startTime) / _scrollDuration);
        delta = [self easeInOut:time];
        _scrollOffset = _startOffset + (_endOffset - _startOffset) * delta;
        [self didScroll];
        if (time >= 1.0) {
            _scrolling = NO;
            [self depthSortViews];
            [self pushAnimationState:YES];
            [_delegate carouselDidEndScrollingAnimation:self];
            [self popAnimationState];
        }
    } else if (_decelerating) {
        CGFloat time = MIN(_scrollDuration, currentTime - _startTime);
        CGFloat acceleration = -_startVelocity/_scrollDuration;
        CGFloat distance = _startVelocity * time + 0.5 * acceleration * pow(time, 2.0);
        _scrollOffset = _startOffset + distance;
        [self didScroll];
        if (fabs(time - _scrollDuration) < FLOAT_ERROR_MARGIN) {
            _decelerating = NO;
            [self pushAnimationState:YES];
            [_delegate carouselDidEndDecelerating:self];
            [self popAnimationState];
            if ((_scrollToItemBoundary || fabs(_scrollOffset - [self clampedOffset:_scrollOffset]) > FLOAT_ERROR_MARGIN) && !_autoscroll) {
                if (fabs(_scrollOffset - self.currentItemIndex) < FLOAT_ERROR_MARGIN) {
                    //call scroll to trigger events for legacy support reasons
                    //even though technically we don't need to scroll at all
                    [self scrollToItemAtIndex:self.currentItemIndex duration:0.01];
                } else {
                    [self scrollToItemAtIndex:self.currentItemIndex animated:YES];
                }
            } else {
                CGFloat difference = round(_scrollOffset) - _scrollOffset;
                if (difference > 0.5) {
                    difference = difference - 1.0;
                } else if (difference < -0.5) {
                    difference = 1.0 + difference;
                }
                _toggleTime = currentTime - MAX_TOGGLE_DURATION * fabs(difference);
                _toggle = MAX(-1.0, MIN(1.0, -difference));
            }
        }
    } else if (_autoscroll && !_dragging) {
        //autoscroll goes backwards from what you'd expect, for historical reasons
        self.scrollOffset = [self clampedOffset:_scrollOffset - delta * _autoscroll];
    } else if (fabs(_toggle) > FLOAT_ERROR_MARGIN) {
        NSTimeInterval toggleDuration = _startVelocity? MIN(1.0, MAX(0.0, 1.0 / fabs(_startVelocity))): 1.0;
        toggleDuration = MIN_TOGGLE_DURATION + (MAX_TOGGLE_DURATION - MIN_TOGGLE_DURATION) * toggleDuration;
        NSTimeInterval time = MIN(1.0, (currentTime - _toggleTime) / toggleDuration);
        delta = [self easeInOut:time];
        _toggle = (_toggle < 0.0)? (delta - 1.0): (1.0 - delta);
        [self didScroll];
    } else if (!_autoscroll) {
        [self stopAnimation];
    }
    
    [self popAnimationState];
}

- (void)didMoveToSuperview {
    if (self.superview) {
        [self startAnimation];
    } else {
        [self stopAnimation];
    }
}

- (void)didScroll {
    if (_wrapEnabled || !_bounces) {
        _scrollOffset = [self clampedOffset:_scrollOffset];
    } else {
        CGFloat min = -_bounceDistance;
        CGFloat max = MAX(_numberOfItems - 1, 0.0) + _bounceDistance;
        if (_scrollOffset < min) {
            _scrollOffset = min;
            _startVelocity = 0.0;
        } else if (_scrollOffset > max) {
            _scrollOffset = max;
            _startVelocity = 0.0;
        }
    }
    
    //check if index has changed
    NSInteger difference = [self minScrollDistanceFromIndex:self.currentItemIndex toIndex:self.previousItemIndex];
    if (difference) {
        _toggleTime = CACurrentMediaTime();
        _toggle = MAX(-1, MIN(1, difference));
        [self startAnimation];
    }
    
    [self loadUnloadViews];    
    [self transformItemViews];
    
    //notify delegate of offset change
    if (fabs(_scrollOffset - _previousScrollOffset) > FLOAT_ERROR_MARGIN) {
        [self pushAnimationState:YES];
        [_delegate carouselDidScroll:self];
        [self popAnimationState];
    }
    
    //notify delegate of index change
    if (_previousItemIndex != self.currentItemIndex) {
        [self pushAnimationState:YES];
        [_delegate carouselCurrentItemIndexDidChange:self];
        [self popAnimationState];
    }

    //update previous index
    _previousScrollOffset = _scrollOffset;
    _previousItemIndex = self.currentItemIndex;
} 


#pragma mark -
#pragma mark Gestures and taps

- (NSInteger)viewOrSuperviewIndex:(UIView *)view {
    if (view == nil || view == _contentView) {
        return NSNotFound;
    }
    NSInteger index = [self indexOfItemView:view];
    if (index == NSNotFound) {
        return [self viewOrSuperviewIndex:view.superview];
    }
    return index;
}

- (BOOL)viewOrSuperview:(UIView *)view implementsSelector:(SEL)selector {
    if (!view || view == self.contentView) {
        return NO;
    }
    
    //thanks to @mattjgalloway and @shaps for idea
    //https://gist.github.com/mattjgalloway/6279363
    //https://gist.github.com/shaps80/6279008
    
    Class viewClass = [view class];
    while (viewClass && viewClass != [UIView class]) {
        unsigned int numberOfMethods;
        Method *methods = class_copyMethodList(viewClass, &numberOfMethods);
        for (unsigned int i = 0; i < numberOfMethods; i++) {
            if (method_getName(methods[i]) == selector) {
                free(methods);
                return YES;
            }
        }
        if (methods) free(methods);
        viewClass = [viewClass superclass];
    }
    
    return [self viewOrSuperview:view.superview implementsSelector:selector];
}

- (id)viewOrSuperview:(UIView *)view ofClass:(Class)class {
    if (!view || view == self.contentView) {
        return nil;
    } else if ([view isKindOfClass:class]) {
        return view;
    }
    return [self viewOrSuperview:view.superview ofClass:class];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch {
    if (_scrollEnabled) {
        _dragging = NO;
        _scrolling = NO;
        _decelerating = NO;
    }
    
    if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        //handle tap
        NSInteger index = [self viewOrSuperviewIndex:touch.view];
        if (index == NSNotFound && _centerItemWhenSelected) {
            //view is a container view
            index = [self viewOrSuperviewIndex:[touch.view.subviews lastObject]];
        }
        if (index != NSNotFound) {
            if ([self viewOrSuperview:touch.view implementsSelector:@selector(touchesBegan:withEvent:)])
            {
                return NO;
            }
        }
    } else if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (!_scrollEnabled) {
            return NO;
        } else if ([self viewOrSuperview:touch.view implementsSelector:@selector(touchesMoved:withEvent:)]) {
            UIScrollView *scrollView = [self viewOrSuperview:touch.view ofClass:[UIScrollView class]];
            if (scrollView) {
                return !scrollView.scrollEnabled ||
                (self.vertical && scrollView.contentSize.height <= scrollView.frame.size.height) ||
                (!self.vertical && scrollView.contentSize.width <= scrollView.frame.size.width);
            }
            if ([self viewOrSuperview:touch.view ofClass:[UIButton class]] ||
                [self viewOrSuperview:touch.view ofClass:[UIBarButtonItem class]]) {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gesture {
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        //ignore vertical swipes
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gesture;
        CGPoint translation = [panGesture translationInView:self];
        if (_ignorePerpendicularSwipes) {
            if (_vertical) {
                return fabs(translation.x) <= fabs(translation.y);
            } else {
                return fabs(translation.x) >= fabs(translation.y);
            }
        }
    }
    return YES;
}

- (void)didTap:(UITapGestureRecognizer *)tapGesture {
    //check for tapped view
    UIView *itemView = [self itemViewAtPoint:[tapGesture locationInView:_contentView]];
    NSInteger index = itemView? [self indexOfItemView:itemView]: NSNotFound;
    if (index != NSNotFound) {
        if (!_delegate || [_delegate carousel:self shouldSelectItemAtIndex:index]) {
            if ((index != self.currentItemIndex && _centerItemWhenSelected) ||
                (index == self.currentItemIndex && _scrollToItemBoundary)) {
                [self scrollToItemAtIndex:index animated:YES];
            }
            [_delegate carousel:self didSelectItemAtIndex:index];
        } else if (_scrollEnabled && _scrollToItemBoundary && _autoscroll) {
            [self scrollToItemAtIndex:self.currentItemIndex animated:YES];
        }
    } else {
    	[self scrollToItemAtIndex:self.currentItemIndex animated:YES];
    }
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture {
    if (_scrollEnabled && _numberOfItems) {
        switch (panGesture.state) {
            case UIGestureRecognizerStateBegan: {
                _dragging = YES;
                _scrolling = NO;
                _decelerating = NO;
                _previousTranslation = _vertical? [panGesture translationInView:self].y: [panGesture translationInView:self].x;

#if defined(USING_CHAMELEON) && USING_CHAMELEON

                _previousTranslation = -_previousTranslation;
#endif

                [_delegate carouselWillBeginDragging:self];
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed: {
                _dragging = NO;
                _didDrag = YES;
                if ([self shouldDecelerate]) {
                    _didDrag = NO;
                    [self startDecelerating];
                }
                
                [self pushAnimationState:YES];
                [_delegate carouselDidEndDragging:self willDecelerate:_decelerating];
                [self popAnimationState];
                
                if (!_decelerating) {
                    if ((_scrollToItemBoundary || fabs(_scrollOffset - [self clampedOffset:_scrollOffset]) > FLOAT_ERROR_MARGIN) && !_autoscroll) {
                        if (fabs(_scrollOffset - self.currentItemIndex) < FLOAT_ERROR_MARGIN) {
                            //call scroll to trigger events for legacy support reasons
                            //even though technically we don't need to scroll at all
                            [self scrollToItemAtIndex:self.currentItemIndex duration:0.01];
                        } else if ([self shouldScroll]) {
                            NSInteger direction = (int)(_startVelocity / fabs(_startVelocity));
                            [self scrollToItemAtIndex:self.currentItemIndex + direction animated:YES];
                        } else {
                            [self scrollToItemAtIndex:self.currentItemIndex animated:YES];
                        }
                    } else {
                        [self depthSortViews];
                    }
                } else {
                    [self pushAnimationState:YES];
                    [_delegate carouselWillBeginDecelerating:self];
                    [self popAnimationState];
                }
                break;
            }
            case UIGestureRecognizerStateChanged: {
                CGFloat translation = _vertical? [panGesture translationInView:self].y: [panGesture translationInView:self].x;
                CGFloat velocity = _vertical? [panGesture velocityInView:self].y: [panGesture velocityInView:self].x;

#if defined(USING_CHAMELEON) && USING_CHAMELEON

                translation = -translation;
                velocity = -velocity;
#endif

                CGFloat factor = 1.0;
                if (!_wrapEnabled && _bounces) {
                    factor = 1.0 - MIN(fabs(_scrollOffset - [self clampedOffset:_scrollOffset]),
                                       _bounceDistance) / _bounceDistance;
                }
                
                _startVelocity = -velocity * factor * _scrollSpeed / _itemWidth;
                _scrollOffset -= (translation - _previousTranslation) * factor * _offsetMultiplier / _itemWidth;
                _previousTranslation = translation;
                [self didScroll];
                break;
            }
            case UIGestureRecognizerStatePossible: {
                //do nothing
                break;
            }
        }
    }
}

#pragma mark - dealloc

- (void)dealloc {
    [self stopAnimation];
}

@end
