//
//  YXAnnotationShapeViewAction.h
//  Annotable
//
//  Created by zyx on 2017/4/25.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAnnotationShapeView.h"
#import "YXAnnotationConfig.h"
typedef NS_ENUM(NSInteger, Action) {
    Create,
    Change,
    Delete,
};

@interface YXAnnotationShapeViewAction : NSObject

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) Action action;

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, strong) YXAnnotationShapeView *shapeView;

@property (nonatomic, assign) AnnotationType type;

- (instancetype)initWithColor:(UIColor *)color
                       action:(Action)action
                         rect:(CGRect)rect
                         type:(AnnotationType)type
                    shapeView:(YXAnnotationShapeView *)shapeView;


@end
