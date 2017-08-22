//
//  YXAnnotationTabbarView.m
//  Annotation
//
//  Created by zyx on 2017/4/28.
//  Copyright © 2017年 bluelive. All rights reserved.
//

#import "YXAnnotationTabbarView.h"
#import "YXButton.h"
#import "YXAnnotationConfig.h"

static CGFloat kAnimationDuration = .5;

@interface YXAnnotationTabbarView ()

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIButton *shapeButton;

@property (nonatomic, strong) UIButton *colorButton;

@property (nonatomic, strong) UIButton *rotateButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation YXAnnotationTabbarView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    
    CGFloat w = self.frame.size.width / 3;
    
    
    YXButton *btn = [[YXButton alloc] initWithFrame:CGRectMake(0, 0, w, self.frame.size.height)];
    btn.tag = YXAnnotationTabbarItemShape;
    [btn setTitle:@"形状" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"an_shape_square"] forState:UIControlStateNormal];
    
    [btn setTitleColor:RGB(51, 51, 51) forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:10]];
    
    [btn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    _shapeButton = btn;

    
    YXButton *btn2 = [[YXButton alloc] initWithFrame:CGRectMake(w , 0, w, self.frame.size.height)];
    btn2.tag = YXAnnotationTabbarItemColor;
    [btn2 setTitle:@"颜色" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"an_shape_square"] forState:UIControlStateNormal];
    
    [btn2 setTitleColor:RGB(51, 51, 51) forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:10]];
    
    [btn2 addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    _colorButton = btn2;
    
    YXButton *btn3 = [[YXButton alloc] initWithFrame:CGRectMake(w * 2, 0, w, self.frame.size.height)];
    btn3.tag = YXAnnotationTabbarItemRotate;
    [btn3 setTitle:@"旋转" forState:UIControlStateNormal];
    [btn3 setImage:[UIImage imageNamed:@"an_rotate"] forState:UIControlStateNormal];
    
    [btn3 setTitleColor:RGB(51, 51, 51) forState:UIControlStateSelected];
    [btn3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [btn3.titleLabel setFont:[UIFont systemFontOfSize:10]];
    
    [btn3 addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn3];
    _rotateButton = btn3;
    
    self.selectedButton = _shapeButton;
    
    return self;
}

#pragma mark - public

- (void)showRotate {
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    
    [btn addTarget:self action:@selector(cancelRotate) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    btn.alpha = 0.0;
    _cancelButton = btn;
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - self.frame.size.height, 0, self.frame.size.height, self.frame.size.height)];
    
    [btn2 addTarget:self action:@selector(confirmRotate) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn2];
    btn2.alpha = 0.0;
    _confirmButton = btn2;
    
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _cancelButton.alpha = 1.0;
        _confirmButton.alpha = 1.0;
        
        _shapeButton.alpha = 0.0;
        _colorButton.alpha = 0.0;
        _rotateButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    } completion:^(BOOL finished) {
        
    }];

}

- (void)setImage:(UIImage *)image atIndex:(NSInteger)index {
    
    if (index == 0) {
        [_shapeButton setImage:image forState:UIControlStateNormal];
    }
    
    if (index == 1) {
        [_colorButton setImage:image forState:UIControlStateNormal];
    }
    
}

#pragma mark - event

- (void)tapButton:(UIButton *)btn {
    
    YXAnnotationTabbarItem originItem = _selectedItem;
    
    if (self.selectedButton != btn) {
        self.selectedButton = btn;
    }
    
    if (_cancelButton) {
        if ([self.delegate respondsToSelector:@selector(yxAnnotationTabbarViewDidTapRotateButton:)]) {
            [self.delegate yxAnnotationTabbarViewDidTapRotateButton:self];
        }
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(yxAnnotationTabbarView:didSelectItem:originItem:)]) {
        [self.delegate yxAnnotationTabbarView:self didSelectItem:_selectedItem originItem:originItem];
    }
    
}

- (void)cancelRotate {

    [UIView animateWithDuration:kAnimationDuration animations:^{
        _cancelButton.alpha = 0.0;
        _confirmButton.alpha = 0.0;
        
        _shapeButton.alpha = 1.0;
        _colorButton.alpha = 1.0;
        _rotateButton.center = CGPointMake(self.frame.size.width / 6 * 5, self.frame.size.height / 2);
    } completion:^(BOOL finished) {
        [_cancelButton removeFromSuperview];
        [_confirmButton removeFromSuperview];
        
        _cancelButton = nil;
        _confirmButton = nil;
    }];
    
    if ([self.delegate respondsToSelector:@selector(yxAnnotationTabbarViewCancelRotate:)]) {
        [self.delegate yxAnnotationTabbarViewCancelRotate:self];
    }
}

- (void)confirmRotate {

    [UIView animateWithDuration:kAnimationDuration animations:^{
        _cancelButton.alpha = 0.0;
        _confirmButton.alpha = 0.0;
        
        _shapeButton.alpha = 1.0;
        _colorButton.alpha = 1.0;
        _rotateButton.center = CGPointMake(self.frame.size.width / 6 * 5, self.frame.size.height / 2);
    } completion:^(BOOL finished) {
        [_cancelButton removeFromSuperview];
        [_confirmButton removeFromSuperview];
        _cancelButton = nil;
        _confirmButton = nil;
    }];
    
    
    if ([self.delegate respondsToSelector:@selector(yxAnnotationTabbarViewConfirmRotate:)]) {
        [self.delegate yxAnnotationTabbarViewConfirmRotate:self];
    }
    
}

#pragma mark - setting


- (void)setSelectedButton:(UIButton *)selectedButton {
    
    [_selectedButton setSelected:false];
    _selectedButton = selectedButton;
    
    [_selectedButton setSelected:YES];
    _selectedItem = selectedButton.tag;
}



@end
