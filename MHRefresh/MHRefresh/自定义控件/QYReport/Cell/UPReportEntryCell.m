//
//  UPReportEntryCell.m
//  Up
//
//  Created by panle on 2018/7/30.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPReportEntryCell.h"
//#import "UPReportEntryModel.h"

static const CGFloat kSelectImageLeading = 30.0;
static const CGFloat kSelectImageTop = 10.0;
static const CGFloat kSelectImageWH = 20.0;
static const CGFloat kEntryLabelLeading = 12.0;

@interface UPReportEntryCell ()

@property (nonatomic, strong) UIImageView *selectImageView;

@property (nonatomic, strong) UILabel *reportEntryLabel;

@end

@implementation UPReportEntryCell

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
    return 40.0;
}

- (void)up_updateDataWithReportEntryModel:(UPReportEntryModel *)model {
    
//    _reportEntryLabel.text = model.entry;
//    _selectImageView.image = model.isSelected == YES ? [UIImage imageNamed:@"up_report_selected"] : [UIImage imageNamed:@"up_report_unselected"];
}


#pragma mark - layoutUI

- (void)layoutOfUI {
    [self layoutUIOfSelf];
    [self layoutUIOfSelectImageView];
    [self layoutUIOfReportEntryLabel];
}

- (void)layoutUIOfSelf {
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOfSelectImageView {
    
    _selectImageView = [[UIImageView alloc] init];
    _selectImageView.frame = CGRectMake(kSelectImageLeading, kSelectImageTop, kSelectImageWH, kSelectImageWH);
    _selectImageView.image = [UIImage imageNamed:@"up_report_unselected"];
    [self.contentView addSubview:_selectImageView];
}

- (void)layoutUIOfReportEntryLabel {
    
//    UIFont *font = [UIFont fontPingFang:QYPingFangSCRegular size:16.0];
//    CGFloat offentX = MAX_X(_selectImageView.frame) + kEntryLabelLeading;
//    CGFloat width = self.contentView.width - offentX - UPDefaultEdgeSpace;
//    CGFloat height = [NSString singleHeightWithFont:font constrainedToWidth:CGFLOAT_MAX];
//    CGFloat offentY = ([[self class] up_cellHeight] - height) / 2.0;
//
//    _reportEntryLabel = [UPFactory up_singleLeftLabelWithFrame:CGRectMake(offentX, offentY, width, height) text:nil font:font textColor:[UIColor up_textColor]];
//    [self.contentView addSubview:_reportEntryLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    _reportEntryLabel.width = self.contentView.width - _reportEntryLabel.x - UPDefaultEdgeSpace;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
