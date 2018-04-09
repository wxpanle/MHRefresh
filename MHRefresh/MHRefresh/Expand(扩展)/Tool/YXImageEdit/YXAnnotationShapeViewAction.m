//
//  YXAnnotationShapeViewAction.m
//  Annotable
//
//  Created by zyx on 2017/4/25.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import "YXAnnotationShapeViewAction.h"

@implementation YXAnnotationShapeViewAction

- (instancetype)initWithColor:(UIColor *)color action:(Action)action rect:(CGRect)rect type:(AnnotationType)type shapeView:(YXAnnotationShapeView *)shapeView {
    
    self = [super init];
    
    self.color = color;
    self.action = action;
    self.rect = rect;
    self.shapeView = shapeView;
    self.type = type;
    
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
