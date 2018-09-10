//
//  iCarousel.h
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


//#pragma 本质就是声明  常用的功能就是注释   尤其是给code分段注释  还有一个功能时处理编译器的警告

#pragma clang diagnostic push //开始处理编译警告消除
#pragma clang diagnostic ignored "-Wunknown-pragmas"  //忽略掉未知的pragma
#pragma clang diagnostic ignored "-Wreserved-id-macro"
#pragma clang diagnostic ignored "-Wobjc-missing-property-synthesis" //自动属性合成没有合成的属性

/*
 以#开头的都是预编译指令
 __has_feature  是否定义了某个特性
 #undef   用于取消在此之前定义的宏标识符
 define   用来定义一个常量 常量也是全局范围的
 defined  用来检测常量有没有被定义  若常量存在 返回 true  否则 false
 #if      编译预处理中的条件命令  相当于C语法中的if语句
 #ifdef   判断某个宏是否被定义过
 #ifndef  判断某个宏是否未被定义过
 #else    与#if #ifdef #ifndef 对应的  其它条件执行分支
 #elif    与#if #ifdef #ifndef #elif 对应的  其它条件执行分支  等同于  else if
 #endif   与#if #ifndef #ifdef 这些命令的结束标志
 */
#import <Availability.h>
#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


#import <QuartzCore/QuartzCore.h>
#if defined USING_CHAMELEON || defined __IPHONE_OS_VERSION_MAX_ALLOWED
#define ICAROUSEL_IOS
#else
#define ICAROUSEL_MACOS
#endif


#ifdef ICAROUSEL_IOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
typedef NSView UIView;
#endif


typedef NS_ENUM(NSInteger, iCarouselType) {
    //线性
    iCarouselTypeLinear = 0,
    //可旋转的
    iCarouselTypeRotary,
    //反向旋转
    iCarouselTypeInvertedRotary,
    //圆柱式
    iCarouselTypeCylinder,
    //反向旋转
    iCarouselTypeInvertedCylinder,
    //车轮式
    iCarouselTypeWheel,
    //反向车轮式
    iCarouselTypeInvertedWheel,
    //封面流
    iCarouselTypeCoverFlow,
    //封面流
    iCarouselTypeCoverFlow2,
    //时光机
    iCarouselTypeTimeMachine,
    //反向时光机
    iCarouselTypeInvertedTimeMachine,
    //自定义
    iCarouselTypeCustom
};


typedef NS_ENUM(NSInteger, iCarouselOption) {
    iCarouselOptionWrap = 0,
    iCarouselOptionShowBackfaces,
    iCarouselOptionOffsetMultiplier,
    iCarouselOptionVisibleItems,
    iCarouselOptionCount,
    iCarouselOptionArc,
    iCarouselOptionAngle,
    iCarouselOptionRadius,
    iCarouselOptionTilt,
    iCarouselOptionSpacing,
    iCarouselOptionFadeMin,
    iCarouselOptionFadeMax,
    iCarouselOptionFadeRange,
    iCarouselOptionFadeMinAlpha
};


NS_ASSUME_NONNULL_BEGIN

@protocol iCarouselDataSource, iCarouselDelegate;

@interface iCarousel : UIView

//数据源代理
@property (nonatomic, weak_delegate) IBOutlet __nullable id<iCarouselDataSource> dataSource;
//数据代理
@property (nonatomic, weak_delegate) IBOutlet __nullable id<iCarouselDelegate> delegate;
//类型
@property (nonatomic, assign) iCarouselType type;
//透视
@property (nonatomic, assign) CGFloat perspective;
//减速比例
@property (nonatomic, assign) CGFloat decelerationRate;
//滚动速度
@property (nonatomic, assign) CGFloat scrollSpeed;
//弹跳距离
@property (nonatomic, assign) CGFloat bounceDistance;
//允许滚动
@property (nonatomic, assign, getter = isScrollEnabled) BOOL scrollEnabled;
//页码滚动
@property (nonatomic, assign, getter = isPagingEnabled) BOOL pagingEnabled;
//横竖屏
@property (nonatomic, assign, getter = isVertical) BOOL vertical;
//轮播是否可用
@property (nonatomic, readonly, getter = isWrapEnabled) BOOL wrapEnabled;
//弹簧效果
@property (nonatomic, assign) BOOL bounces;
//偏移量
@property (nonatomic, assign) CGFloat scrollOffset;
//偏移
@property (nonatomic, readonly) CGFloat offsetMultiplier;
@property (nonatomic, assign) CGSize contentOffset;
@property (nonatomic, assign) CGSize viewpointOffset;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger numberOfPlaceholders;
//当前预览下标
@property (nonatomic, assign) NSInteger currentItemIndex;
//当前itemview
@property (nonatomic, strong, readonly) UIView * __nullable currentItemView;

@property (nonatomic, strong, readonly) NSArray *indexesForVisibleItems;
@property (nonatomic, readonly) NSInteger numberOfVisibleItems;
@property (nonatomic, strong, readonly) NSArray *visibleItemViews;
@property (nonatomic, readonly) CGFloat itemWidth;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, readonly) CGFloat toggle;
//自动滚动
@property (nonatomic, assign) CGFloat autoscroll;
@property (nonatomic, assign) BOOL stopAtItemBoundary;
@property (nonatomic, assign) BOOL scrollToItemBoundary;
@property (nonatomic, assign) BOOL ignorePerpendicularSwipes;
@property (nonatomic, assign) BOOL centerItemWhenSelected;
//拖动中
@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
//减速中
@property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;
//滚动中
@property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;

- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (nullable UIView *)itemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfItemView:(UIView *)view;
- (NSInteger)indexOfItemViewOrSubview:(UIView *)view;
- (CGFloat)offsetForItemAtIndex:(NSInteger)index;
- (nullable UIView *)itemViewAtPoint:(CGPoint)point;

- (void)removeItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertItemAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadItemAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)reloadData;

@end


@protocol iCarouselDataSource <NSObject>

//数据源个数
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel;
//即将展示view
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;

@optional

- (NSInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel;
- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(nullable UIView *)view;

@end


@protocol iCarouselDelegate <NSObject>
@optional

//开始滚动动画
- (void)carouselWillBeginScrollingAnimation:(iCarousel *)carousel;
//结束滚动动画
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel;
//正在滚动
- (void)carouselDidScroll:(iCarousel *)carousel;
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel;
//开始拖动
- (void)carouselWillBeginDragging:(iCarousel *)carousel;
//结束拖动
- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate;
//开始减速
- (void)carouselWillBeginDecelerating:(iCarousel *)carousel;
//结束减速
- (void)carouselDidEndDecelerating:(iCarousel *)carousel;

//是否允许选中下标
- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index;
//已经选中下标
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;

//当前下标宽度
- (CGFloat)carouselItemWidth:(iCarousel *)carousel;
//3D旋转
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform;
//
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop  //编译警告处理完成

