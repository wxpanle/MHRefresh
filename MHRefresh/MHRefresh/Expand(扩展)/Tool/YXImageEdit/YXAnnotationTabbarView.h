//
//  YXAnnotationTabbarView.h
//  Annotation
//
//  Created by zyx on 2017/4/28.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXAnnotationTabbarItem) {
    YXAnnotationTabbarItemShape = 1,
    YXAnnotationTabbarItemColor,
    YXAnnotationTabbarItemRotate
};

// ---------

@class YXAnnotationTabbarView;

@protocol YXAnnotationTabbarViewDelegate <NSObject>

- (void)yxAnnotationTabbarView:(YXAnnotationTabbarView *) view
                didSelectItem:(YXAnnotationTabbarItem)item
                   originItem:(YXAnnotationTabbarItem)originItem;

- (void)yxAnnotationTabbarViewConfirmRotate:(YXAnnotationTabbarView *)view;

- (void)yxAnnotationTabbarViewCancelRotate:(YXAnnotationTabbarView *)view;

- (void)yxAnnotationTabbarViewDidTapRotateButton:(YXAnnotationTabbarView *)view;

@end

@interface YXAnnotationTabbarView : UIView

@property (nonatomic, weak) id <YXAnnotationTabbarViewDelegate>delegate;

@property (nonatomic, assign) YXAnnotationTabbarItem selectedItem;

- (void)showRotate;

- (void)setImage:(UIImage *)image atIndex:(NSInteger)index;

@end
