//
//  QYMultiSelectTableViewCell.m
//  MHRefresh
//
//  Created by panle on 2018/1/22.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYMultiSelectTableViewCell.h"

@interface QYMultiSelectTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation QYMultiSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _editViewWidth = 44.0;
        [self.titleLabel class];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375.0, 30.0)];
        _titleLabel.text = @"这是一个测试 这是一个测试  这是一个测试  这是一个测试 这是一个测试 这是一个测试";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)editView {
    if (nil == _editView) {
        _editView = [[UIView alloc] initWithFrame:CGRectMake(-self.editViewWidth, 0, self.editViewWidth, self.sm_height)];
        _editView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_editView];
    }
    return _editView;

}

- (void)startEditAnimation {
    self.editView.frame = CGRectMake(0, 0, self.editViewWidth, self.sm_height);
    self.titleLabel.frame = CGRectMake(self.editViewWidth, 0, 375.0 - self.editViewWidth, 30.0);
}

- (void)endEditAnimation {
    self.editView.frame = CGRectMake(-self.editViewWidth, 0, self.editViewWidth, self.sm_height);
    self.titleLabel.frame = CGRectMake(0, 0, 375.0, 30.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
