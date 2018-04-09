//
//  YXAnnotationShapeView.h
//  Annotable
//
//  Created by zyx on 2017/4/20.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAnnotationConfig.h"


typedef NS_ENUM(NSInteger, EditType) {
    EditTypeOfMove = 0,
    EditTypeOfZoom,
    EditTypeOfDelete,
};


@interface YXAnnotationShapeView : UIView

@property (nonatomic, assign) AnnotationType type;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign, readonly) CGFloat lineWidth;

@property (nonatomic, assign) BOOL showEditBox;

@property (nonatomic, assign) BOOL highlight;

@property (nonatomic, assign) CGPoint tlPoint;

@property (nonatomic, assign) CGPoint trPoint;

@property (nonatomic, assign) CGPoint blPoint;

@property (nonatomic, assign) CGPoint brPoint;


- (instancetype)initWithType:(AnnotationType)type
                       color:(UIColor *)color;

- (BOOL)containPoint:(CGPoint)point;

- (EditType)editTypeAtPoint:(CGPoint)point;

- (void)resetPoint;

- (void)setColor:(UIColor *)color frame:(CGRect)frame annotationType:(AnnotationType)type;

- (CGRect)getPathRect;

@end
