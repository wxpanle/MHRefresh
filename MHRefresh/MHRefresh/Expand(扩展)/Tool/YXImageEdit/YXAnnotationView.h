//
//  MAnnotationImageView.h
//  Annotable
//
//  Created by zyx on 2017/4/18.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAnnotationShapeView.h"

@class YXAnnotationView;

@protocol YXAnnotationViewDelegate <NSObject>

- (void)yxAnnotationView:(YXAnnotationView *)view didSelectShapeView:(YXAnnotationShapeView *)shapeView;

- (void)yxAnnotationView:(YXAnnotationView *)view didChangeShapeView:(YXAnnotationShapeView *)shapeView;

- (void)yxAnnotationView:(YXAnnotationView *)view didCreateShapeView:(YXAnnotationShapeView *)shapeView;

- (void)yxAnnotationView:(YXAnnotationView *)view didDeleteShapeView:(YXAnnotationShapeView *)shapeView;

- (void)yxAnnotationViewTapBlankArea:(YXAnnotationView *)view;

@end


@interface YXAnnotationView : UIView

@property (nonatomic, weak) id<YXAnnotationViewDelegate> delegate;

@property (nonatomic, assign) AnnotationType type;

@property (nonatomic, strong) UIColor *color;


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image zoom:(CGFloat)zoom;

- (YXAnnotationShapeView *)selectedShapeView;

- (void)rotatedMPI2AdjustScreen;

- (UIImage *)getAnnotatedImage;

- (void)removeAllAnnotatedView;

- (void)setImage:(UIImage *)image;

- (UIImage *)getRotateImage;

- (BOOL)containShapeView;

@end
