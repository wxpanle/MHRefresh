//
//  UPReportDoneCell.m
//  Up
//
//  Created by panle on 2018/7/30.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPReportDoneCell.h"

static const CGFloat kDoneButtonH = 40.0;
static const CGFloat kDoneButtonLeading = 32.0;

@interface UPReportDoneCell ()

@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation UPReportDoneCell

#pragma mark - init

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}


#pragma mark - public

+ (CGFloat)up_cellHeight {
    return 80.0;
}

- (void)up_updateDataWithIsAllowDoneEvent:(BOOL)isAllow {
    _doneButton.enabled = isAllow;
}


#pragma mark - layoutUI

- (void)layoutUI {
    [self layoutUIOfSelf];
    [self layoutUIOfDoneButton];
}

- (void)layoutUIOfSelf {
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOfDoneButton {
    
//    CGFloat width = self.contentView.width - kDoneButtonLeading * 2.0;
//    CGFloat offentY = ([[self class] up_cellHeight] - kDoneButtonH) / 2.0;
//
//    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_doneButton setTitle:LocalizedString(@"reportMessage.reportDone.title") forState:UIControlStateNormal];
//    [_doneButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    _doneButton.titleLabel.font = [UIFont fontPingFang:QYPingFangSCRegular size:17.0];
//    _doneButton.backgroundColor = [UIColor colorWithHexString:@"fe9600"];
//    _doneButton.layer.cornerRadius = 4.0;
//    _doneButton.clipsToBounds = YES;
//    _doneButton.frame = CGRectMake(kDoneButtonLeading, offentY, width, kDoneButtonH);
//    [_doneButton addTarget:self action:@selector(p_done) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_doneButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    _doneButton.width = self.contentView.width - kDoneButtonLeading * 2.0;
}


#pragma mark - event

- (void)p_done {
    
    if (_delegate && [_delegate respondsToSelector:@selector(up_reportDoneCellDoneEvent:)]) {
        [_delegate up_reportDoneCellDoneEvent:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
