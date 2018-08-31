//
//  UPPackageCell.m
//  Up
//
//  Created by panle on 2018/4/8.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPPackageCell.h"

static CGFloat kContentMaxHeight = 24.0;

@interface UPPackageCell ()

@property (nonatomic, strong) UIButton *testButton;

@property (nonatomic, strong) UILabel *packageNameLabel;

@property (nonatomic, strong) UILabel *packageNumberLabel;

@end

@implementation UPPackageCell

#pragma mark - ======== init ========

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self layoutUI];
    }
    return self;
}

#pragma mark - ===== public =====

- (void)updatePackageNameWithText:(NSString *)text cardNumber:(NSInteger)number; {
    _packageNameLabel.text = text;
    if (number < 0) {
        _packageNumberLabel.hidden = YES;
    } else {
        _packageNumberLabel.hidden = NO;
    }
    _packageNameLabel.frame = [self p_packageNameLabelFrameWithText:text];
    _packageNumberLabel.frame = [self p_packageNumberLabelFrameWithString:[NSString stringWithFormat:@"(%@)", @(number).stringValue]];
    
    _packageNameLabel.text = text;
    _packageNumberLabel.text = [NSString stringWithFormat:@"(%@)", @(number).stringValue];
}

#pragma mark - ======== layoutUI ========

- (void)layoutUI {
    [self layoutUIOfSelf];
    [self layoutUIOfPackageNameLabel];
    [self layoutUIOfPackageNumberLabel];
}

- (void)layoutUIOfSelf {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutUIOfTestButton {
    
    _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_testButton setBackgroundColor:[UIColor redColor]];
    
    _testButton.frame = CGRectMake(SCREEN_W - 40.0, [[self class] up_cellHeight] - 20.0, 30.0, 15.0);
    
    [_testButton addTarget:self action:@selector(p_test) forControlEvents:UIControlEventTouchUpInside];
    [self.upContentView addSubview:_testButton];
}

- (void)layoutUIOfPackageNameLabel {
    
    _packageNameLabel = [[UILabel alloc] init];
    _packageNameLabel.numberOfLines = 1;
    _packageNameLabel.textAlignment = NSTextAlignmentLeft;
    _packageNameLabel.textColor = [UIColor colorWithHexString:@"272727"];
    _packageNameLabel.font = [UIFont fontPingFang:QYPingFangSCRegular size:16.0];
    _packageNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.upContentView addSubview:_packageNameLabel];
}

- (void)layoutUIOfPackageNumberLabel {
    
    _packageNumberLabel = [[UILabel alloc] init];
    _packageNumberLabel.numberOfLines = 1;
    _packageNumberLabel.textAlignment = NSTextAlignmentLeft;
    _packageNumberLabel.textColor = [UIColor colorWithHexString:@"8e8e93"];
    _packageNumberLabel.font = [UIFont fontPingFang:QYPingFangSCRegular size:16.0];
    _packageNumberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.upContentView addSubview:_packageNumberLabel];
    _packageNumberLabel.frame = [self p_packageNumberLabelFrameWithString:@"(134)"];
    _packageNumberLabel.text = @"(134)";
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.separatorInset = UIEdgeInsetsMake(0, UPDefaultEdgeSpace, 0, UPDefaultEdgeSpace);
}

#pragma mark - ======== getter ========

+ (CGFloat)up_cellHeight {
    return 64.0;
}

- (CGRect)p_packageNameLabelFrameWithText:(NSString *)string {
    
    if (!string.length) {
        return CGRectZero;
    }
    
    CGFloat offentX = 28.0;
    CGFloat offentY = ([[self class] up_cellHeight] - kContentMaxHeight) / 2.0;
    CGFloat width = [string widthWithFont:_packageNameLabel.font constrainedToHeight:kContentMaxHeight];
    width = width > (SCREEN_W / 2.0) ? (SCREEN_W / 2.0) : width;
    CGFloat height = kContentMaxHeight;
    
    return CGRectMake(offentX, offentY, width, height);
}

- (CGRect)p_packageNumberLabelFrameWithString:(NSString *)string {
    
    if (!string.length) {
        return CGRectZero;
    }
    
    CGFloat offentX = MAX_X(_packageNameLabel.frame) + 15.0;
    CGFloat offentY = ([[self class] up_cellHeight] - kContentMaxHeight) / 2.0;
    CGFloat width = [string widthWithFont:_packageNumberLabel.font constrainedToHeight:kContentMaxHeight];
    CGFloat height = kContentMaxHeight;
    
    return CGRectMake(offentX, offentY, width, height);
}

- (void)p_test {
    DLog(@"点击测试");
}

#pragma mark - ======== setter ========

#pragma mark - ======== private ========

#pragma mark - ======== dealloc ========

- (void)dealloc {
    DLOG_DEALLOC
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
