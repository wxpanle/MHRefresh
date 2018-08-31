//
//  UPBaseTableViewCell.m
//  Up
//
//  Created by panle on 2018/3/22.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPBaseTableViewCell.h"

@implementation UPBaseTableViewCell

#pragma mark - dynamic

@dynamic up_indexPath;


#pragma mark - init

- (void)awakeFromNib {
    [super awakeFromNib];
    [self super_layoutUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self super_layoutUI];
    }
    return self;
}


#pragma mark - public

+ (CGFloat)up_cellHeight {
    return 44.0;
}

- (void)up_hideSeparatorLine {
    self.separatorInset = UIEdgeInsetsMake(self.separatorInset.top, self.separatorInset.left, -1, self.separatorInset.right);
}

- (void)up_showSeparatorLine {
    self.separatorInset = UIEdgeInsetsMake(self.separatorInset.top, self.separatorInset.left, 0, self.separatorInset.right);
}


#pragma mark - super layoutUI

- (void)super_layoutUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 15.0, 0, 15.0);
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


#pragma mark - setter

- (void)setUp_indexPath:(NSIndexPath *)up_indexPath {
    _up_section = up_indexPath.section;
    _up_row = up_indexPath.row;
}


#pragma mark - getter

- (NSIndexPath *)up_indexPath {
    return [NSIndexPath indexPathForRow:_up_row inSection:_up_section];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
