//
//  UPBaseSliderTableViewCell.h
//  Up
//
//  Created by panle on 2018/4/4.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPBaseTableViewCell.h"

#pragma mark - UPSliderRowAction

typedef NS_ENUM(NSInteger, UPSliderRowActionType) {
    UPSRATypeText = 0,
    UPSRATypeImage,
    UPSRATypeMix   //文字在上  图片在下  未实现
};

@interface UPSliderRowAction : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *bgColor;

@property (nonatomic, strong) UIColor *imageBgColor;

/** UPSRATypeText UPSRATypeMix use */
@property (nonatomic, assign) CGFloat contentMaxWidth;

/** UPSRATypeImage use */
@property (nonatomic, assign) CGFloat onlyImageLRSpace;

+ (instancetype)sliderRowActionWithType:(UPSliderRowActionType)type
                            handleBlock:(UPDefNilBlock)handleBlock;

@end

#pragma mark - UPBaseSliderTableViewCell

@class UPBaseSliderTableViewCell;

@protocol UPBaseSliderCellDelegate <NSObject>

@optional

/**
 SliderRowAction  必须为同一类型 只能同时为文字或者图片
 
 @param cell      cell
 @param indexPath indexPath
 @return          NSarray
 */
- (NSArray <UPSliderRowAction *> *)up_sliderRowActionArrayWithTableViewCell:(UPBaseSliderTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (BOOL)up_isAllowSliderTableViewCell:(UPBaseSliderTableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

@end

@interface UPBaseSliderTableViewCell : UPBaseTableViewCell

@property (nonatomic, weak) id <UPBaseSliderCellDelegate> sliderDelegate;

/** default NO */
@property (nonatomic, assign, getter=isAllowSlider) BOOL allowSlider;

@property (nonatomic, assign, readonly, getter=isSliding) BOOL sliding;

/** content view replace system contentView */
@property (nonatomic, strong, readonly) UIView *upContentView;

@property (nonatomic, strong) UIColor *upContentViewBgColor;

- (void)endSliderAnimation;

@end
