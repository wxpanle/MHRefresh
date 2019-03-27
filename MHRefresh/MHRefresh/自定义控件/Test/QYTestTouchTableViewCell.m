//
//  QYTestTouchTableViewCell.m
//  MHRefresh
//
//  Created by panle on 2019/3/15.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYTestTouchTableViewCell.h"

@interface QYTestTouchTableViewCell ()

@property (nonatomic, strong) CALayer *selfLayer;
@property (nonatomic, strong) UILabel *label;

@end

@implementation QYTestTouchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
        [self addSubview:_label];
        
        _selfLayer = [CALayer layer];
        _selfLayer.frame = CGRectMake(150, 10, 30, 30);
        _selfLayer.contents = @"这是一个点击测试";
        _selfLayer.backgroundColor = UIColor.redColor.CGColor;
        _selfLayer.contentsGravity = kCAGravityResize;
        [self.layer addSublayer:_selfLayer];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self.superview];
    CALayer *layer = [self.layer hitTest:point];
    if (_selfLayer == layer) {
        NSLog(@"row = %ld", self.up_row);
    }
    NSLog(@"%@ = %@", NSStringFromCGPoint(point), NSStringFromCGRect(_selfLayer.frame));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
