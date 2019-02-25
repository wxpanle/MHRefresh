//
//  UPDReportHeaderCell.m
//  Up
//
//  Created by panle on 2018/7/30.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPDReportHeaderCell.h"

@interface UPDReportHeaderCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation UPDReportHeaderCell

#pragma mark - init

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutOfUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutOfUI];
    }
    return self;
}


#pragma mark - public

+ (CGFloat)up_cellHeight {
    return 60.0;
}


#pragma mark - layoutOfUI

- (void)layoutOfUI {
    [self layoutUIOfSelf];
    [self layoutUIOfTitleLabel];
}

- (void)layoutUIOfSelf {
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOfTitleLabel {

//    NSString *string = LocalizedString(@"reportMessage.reportReason.title");
//    UIFont *font = [UIFont fontPingFang:QYPingFangSCMedium size:17.0];
//
//    CGSize size = [string sizeWithFont:font constrainedSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//
//    CGFloat offentX = (self.contentView.width - size.width) / 2.0;
//    CGFloat offentY = ([[self class] up_cellHeight] - size.height) / 2.0;
//
//    _titleLabel = [UPFactory up_labelWithFrame:CGRectMake(offentX, offentY, size.width, size.height) text:string font:font textColor:[UIColor up_textColor] numberOfLines:1 textAlignment:NSTextAlignmentCenter lineBreakMode:NSLineBreakByWordWrapping];
//    [self.contentView addSubview:_titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    _titleLabel.x = (self.contentView.width - _titleLabel.width) / 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
