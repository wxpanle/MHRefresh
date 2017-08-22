//
//  YXAnnotationShapeView.m
//  Annotable
//
//  Created by zyx on 2017/4/20.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import "YXAnnotationShapeView.h"

static const CGFloat kEditPointButtonWH = 7.0;
static const CGFloat kEditButtonWH = 22.0;
static const CGFloat kEditLayerLineWidth = 1.0;



@interface YXAnnotationShapeView()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) CAShapeLayer *editLayer;

@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIButton *scaleButton;

@property (nonatomic, strong) UIButton *tButton;

@property (nonatomic, strong) UIButton *trButton;

@property (nonatomic, strong) UIButton *lButton;

@property (nonatomic, strong) UIButton *rButton;

@property (nonatomic, strong) UIButton *blButton;

@property (nonatomic, strong) UIButton *bButton;


@end

@implementation YXAnnotationShapeView

- (instancetype)initWithType:(AnnotationType)type
                       color:(UIColor *)color {
    
    self = [super init];
    
    self.type = type;
    self.color = color;
    _lineWidth = kEditLayerLineWidth;

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = color.CGColor;
    layer.fillColor = color.CGColor;
    layer.lineWidth = _lineWidth;
    self.shapeLayer = layer;
    
    [self.layer addSublayer:layer];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    
    _deleteButton.frame = CGRectMake(-kEditButtonWH / 2, -kEditButtonWH / 2, kEditButtonWH, kEditButtonWH);
    
    _tButton.frame = CGRectMake((frame.size.width - kEditPointButtonWH) / 2, -kEditPointButtonWH / 2, kEditPointButtonWH, kEditPointButtonWH);
    _trButton.frame = CGRectMake(frame.size.width - kEditPointButtonWH / 2, -kEditPointButtonWH / 2, kEditPointButtonWH, kEditPointButtonWH);
    
    _lButton.frame = CGRectMake(-kEditPointButtonWH / 2, (frame.size.height - kEditPointButtonWH) / 2, kEditPointButtonWH, kEditPointButtonWH);
    _rButton.frame = CGRectMake(frame.size.width - kEditPointButtonWH / 2,(frame.size.height - kEditPointButtonWH) / 2, kEditPointButtonWH, kEditPointButtonWH);
    
    _blButton.frame = CGRectMake(-kEditPointButtonWH / 2, frame.size.height - kEditPointButtonWH / 2, kEditPointButtonWH, kEditPointButtonWH);
    _bButton.frame = CGRectMake((frame.size.width - kEditPointButtonWH) / 2, frame.size.height - kEditPointButtonWH / 2, kEditPointButtonWH, kEditPointButtonWH);
    
    _scaleButton.frame = CGRectMake(frame.size.width - kEditButtonWH / 2, frame.size.height - kEditButtonWH / 2, kEditButtonWH, kEditButtonWH);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    
    self.editLayer.path = path.CGPath;
    
    UIBezierPath *path1;
    
    switch (_type) {
        case AnnotationTypeRound:
            path1 = [UIBezierPath bezierPathWithOvalInRect:[self getPathRect]];
            break;
        case AnnotationTypeRectangle:{
            path1 = [UIBezierPath bezierPathWithRect:[self getPathRect]];
            break;
        }
    }
    
    _shapeLayer.path = path1.CGPath;
    
}

#pragma mark - public

- (BOOL)containPoint:(CGPoint)point {
    
    if (self.showEditBox) {
        if (CGRectContainsPoint(_deleteButton.frame, point) || CGRectContainsPoint(_scaleButton.frame, point)) {
            return YES;
        }
    }
    CGPathRef cgPath = _shapeLayer.path;
    return CGPathContainsPoint(cgPath, NULL, point, NO);;
}


- (EditType)editTypeAtPoint:(CGPoint)point {
    
    EditType type = EditTypeOfMove;
    
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, point)) {
            type = view.tag;
        }
    }
    
    return type;
}

- (void)resetPoint {
    self.tlPoint = self.frame.origin;
    self.trPoint = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
    self.blPoint = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
    self.brPoint = CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
}

- (void)setColor:(UIColor *)color frame:(CGRect)frame annotationType:(AnnotationType)type {
   
    _color = color;
    _shapeLayer.strokeColor = color.CGColor;
    _shapeLayer.fillColor = color.CGColor;
    
    _type = type;
    
    self.frame = frame;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
}

- (CGRect)getPathRect {
    return CGRectInset(self.bounds, _lineWidth / 2, _lineWidth / 2);
}


#pragma mark - setting

- (void)setShowEditBox:(BOOL)showEditBox {
    
    _showEditBox = showEditBox;
    
    if (_showEditBox) {
        [self addEditButton];
    } else {
        [self removeEditButton];
    }
    
}


#pragma mark - private 

- (void)addEditButton {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor whiteColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = kEditLayerLineWidth;
    _editLayer = layer;
    [self.layer addSublayer:layer];
    
    UIButton *tlButton = [[UIButton alloc] init];
    tlButton.tag = EditTypeOfDelete;
    [tlButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self addSubview:tlButton];
    _deleteButton = tlButton;
    
    
    UIButton *tButton = [[UIButton alloc] init];
    tButton.tag = EditTypeOfMove;
    [tButton setImage:[UIImage imageNamed:@"an_edit_point"] forState:UIControlStateNormal];
    [self addSubview:tButton];
    _tButton = tButton;
    
    UIButton *trButton = [[UIButton alloc] init];
    trButton.tag = EditTypeOfMove;
    [trButton setImage:[UIImage imageNamed:@"an_edit_point"] forState:UIControlStateNormal];
    [self addSubview:trButton];
    _trButton = trButton;
    
    UIButton *lButton = [[UIButton alloc] init];
    lButton.tag = EditTypeOfMove;
    [lButton setImage:[UIImage imageNamed:@"an_edit_point"] forState:UIControlStateNormal];
    [self addSubview:lButton];
    _lButton = lButton;
    
    UIButton *rButton = [[UIButton alloc] init];
    rButton.tag = EditTypeOfMove;
    [rButton setImage:[UIImage imageNamed:@"an_edit_point"] forState:UIControlStateNormal];
    [self addSubview:rButton];
    _rButton = rButton;
    
    UIButton *blButton = [[UIButton alloc] init];
    blButton.tag = EditTypeOfMove;
    [blButton setImage:[UIImage imageNamed:@"an_edit_point"] forState:UIControlStateNormal];
    [self addSubview:blButton];
    _blButton = blButton;
    
    UIButton *bButton = [[UIButton alloc] init];
    bButton.tag = EditTypeOfMove;
    [bButton setImage:[UIImage imageNamed:@"an_edit_point"] forState:UIControlStateNormal];
    [self addSubview:bButton];
    _bButton = bButton;
    
    UIButton *brButton = [[UIButton alloc] init];
    brButton.tag = EditTypeOfZoom;
    [brButton setImage:[UIImage imageNamed:@"an_edit_scale"] forState:UIControlStateNormal];
    [self addSubview:brButton];
    _scaleButton = brButton;

}

- (void)removeEditButton {
    [_editLayer removeFromSuperlayer];
    [_deleteButton removeFromSuperview];
    [_tButton removeFromSuperview];
    [_trButton removeFromSuperview];
    [_lButton removeFromSuperview];
    [_rButton removeFromSuperview];
    [_blButton removeFromSuperview];
    [_bButton removeFromSuperview];
    [_scaleButton removeFromSuperview];
}


@end
