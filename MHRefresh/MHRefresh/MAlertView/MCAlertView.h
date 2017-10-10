//
//  MCAlertView.h
//  test
//
//  Created by developer on 2017/5/25.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MCAlertViewType) {
    MCAlertViewTypeAlert = 0,
    MCAlertViewTypeSheet         //暂不支持
};

typedef NS_ENUM(NSInteger, MCAlertActionType) {
    MCAlertActionTypeCancelImgae = 0,
    MCAlertActionTypeCancelText = 1,          //文字和image类型的取消可以同时存在  但每个只能存在一个
    MCAlertActionTypeDownLoad = 2,
    MCAlertActionTypeDefault = 3,
    MCAlertActionTypeDelete = 4
};

typedef NS_ENUM(NSInteger, MCAlertImagePosition) {
    MCAlertImagePositionTop = 0,
    MCAlertImagePositionCenter,
    MCAlertImagePositionBottom
};

@class MCAlertAction;
typedef void (^MCAlertActionBlock)(MCAlertAction *  action);

@interface MCAlertAction : NSObject

- (instancetype)initWithTitle:(NSString *)title downLoadSize:(double)size actionType:(MCAlertActionType)actionType handle:(MCAlertActionBlock)handle;

- (instancetype)initWithTitle:(NSString *)title actionType:(MCAlertActionType)actionType handle:(MCAlertActionBlock)handle;

- (void)setTextFont:(UIFont *)font;

- (void)setTextColor:(UIColor *)color;

@end


@interface MCAlertView : UIView

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message MAlertViewType:(MCAlertViewType)viewType;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName imagePosition:(MCAlertImagePosition)position message:(NSString *)message MAlertViewType:(MCAlertViewType)viewType;

- (void)setTitleFont:(UIFont *)font;

- (void)setMessageFont:(UIFont *)font;

- (void)setTitleColor:(UIColor *)color;

- (void)setMessageColor:(UIColor *)color;

- (void)addAlertAction:(MCAlertAction *)action;

- (void)showAlertActionView;

@end
