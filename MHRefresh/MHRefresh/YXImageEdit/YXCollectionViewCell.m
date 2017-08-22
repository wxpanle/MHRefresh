//
//  YXCollectionViewCell.m
//  Annotation
//
//  Created by zyx on 2017/5/2.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import "YXCollectionViewCell.h"

static const CGFloat kLineWidth = 6.0;

@interface YXCollectionViewCell()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) CAShapeLayer *selectedLayer;


@end

@implementation YXCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [self addSubview:btn];
    [btn setEnabled:NO];
    _button = btn;
    
    return self;
}

- (void)setCellType:(CellType)type style:(id)style {
    _type = type;
    
    switch (_type) {
        case CellTypeOfColor:{
            [_button setBackgroundColor:(UIColor *)style];
            [_button setImage:nil forState:UIControlStateNormal];
            break;
        }
        case CellTypeOfShape: {
            [_button setImage:(UIImage *)style forState:UIControlStateNormal];
            [_button setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
            break;
        }
    }
}

- (void)setSelected:(BOOL)selected {
    
    if (selected == self.selected) {
        return;
    }
    
    [super setSelected:selected];
    
    if (selected) {
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(kLineWidth / 2, kLineWidth / 2, self.bounds.size.width - kLineWidth, self.bounds.size.height - kLineWidth)].CGPath;
        shapeLayer.lineWidth = kLineWidth;
        shapeLayer.strokeColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:shapeLayer];
        
        _selectedLayer = shapeLayer;
        
        if (_type == CellTypeOfColor) {
            [_button setImage:[UIImage imageNamed:@"an_color_selected"] forState:UIControlStateNormal];
        }
    } else {
        if (_selectedLayer) {
            [_selectedLayer removeFromSuperlayer];
            if (_type == CellTypeOfColor) {
                [_button setImage:nil forState:UIControlStateNormal];
            }
        }
    }
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.button.frame = self.bounds;
}

@end
