//
//  UPReportInputCell.m
//  Up
//
//  Created by panle on 2018/7/30.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPReportInputCell.h"
//#import "UPReportEntryModel.h"

static const CGFloat kTextViewLeading = 32.0;
static const CGFloat kTextViewTop = 8.0;
static const CGFloat kTextViewH = 70.0;

static const CGFloat kLimitTrailing = 8.0;
static const CGFloat kLimitBottom = 4.0;

static const CGFloat kPlaceLeading = 8.0;
static const CGFloat kPlaceTop = 8.0;
static const CGFloat kPlaceMaxW = 231.0;

@interface UPReportInputCell () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *placeLabel;

@property (nonatomic, strong) UILabel *limitLabel;

@end

@implementation UPReportInputCell

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
    return 78.0;
}

- (void)up_updateDataWithReportEntryModel:(UPReportEntryModel *)model {
    
//    _textView.text = model.customString;
    [self textViewDidChange:_textView];
}

- (void)up_becomeFirstResponder {
    [_textView becomeFirstResponder];
}

- (void)up_resignFirstResponder {
    [_textView resignFirstResponder];
}


#pragma mark - layoutUI

- (void)layoutOfUI {
    [self layoutUIOfSelf];
    [self layoutUIOfTextView];
    [self layoutUIOfPlaceLabel];
    [self layoutUIOfLimitLabel];
}

- (void)layoutUIOfSelf {
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOfTextView {

//    _textView = [[UITextView alloc] initWithFrame:CGRectMake(kTextViewLeading, kTextViewTop, self.contentView.width - kTextViewLeading * 2.0, kTextViewH)];
//    _textView.textColor = [UIColor up_textColor];
//    _textView.delegate = self;
//    _textView.font = [UIFont fontPingFang:QYPingFangSCRegular size:13.0];
//    _textView.layer.borderColor = [UIColor up_cellLineColor].CGColor;
//    _textView.layer.borderWidth = 0.5;
//    [self.contentView addSubview:_textView];
}

- (void)layoutUIOfPlaceLabel {

//    NSString *string = LocalizedString(@"reportMessage.inputReportReason.title");
//    UIFont *font = [UIFont fontPingFang:QYPingFangSCRegular size:13.0];
//    CGFloat offentX = kTextViewLeading + kPlaceLeading;
//    CGFloat offentY = kTextViewTop + kPlaceTop;
//    CGFloat height = [string heightWithFont:font constrainedToWidth:kPlaceMaxW];
//
//    _placeLabel = [UPFactory up_labelWithFrame:CGRectMake(offentX, offentY, kPlaceMaxW, height) text:string font:font textColor:[UIColor colorWithHexString:@"b4b4b8"] numberOfLines:0 textAlignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping];
//    [self.contentView addSubview:_placeLabel];
}

- (void)layoutUIOfLimitLabel {
    
//    NSString *string = @"00/50";
//    UIFont *font = [UIFont fontPingFang:QYPingFangSCRegular size:11.0];
//
//    CGSize size = [string sizeWithFont:font constrainedSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//    CGFloat offentX = self.contentView.width - size.width - kTextViewLeading - kLimitTrailing;
//    CGFloat offentY = ([[self class] up_cellHeight] - size.height - kLimitBottom);
//
//    string = [@"0/" stringByAppendingString:@(UPMessageReportReasonMax).stringValue];
//    _limitLabel = [UPFactory up_labelWithFrame:CGRectMake(offentX, offentY, size.width, size.height) text:string font:font textColor:[UIColor colorWithHexString:@"b4b4b8"] numberOfLines:1 textAlignment:NSTextAlignmentRight lineBreakMode:NSLineBreakByWordWrapping];
//    [self.contentView addSubview:_limitLabel];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
//    _textView.width = self.contentView.width - kTextViewLeading * 2.0;
//    _limitLabel.x = self.contentView.width - _limitLabel.width - kTextViewLeading - kLimitTrailing;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    if (_textView != textView) {
        return;
    }
    
    if (!_textView.text.length) {
        
        return;
    }
    
    _placeLabel.hidden = YES;
    
    NSString *string = [_textView.text copy];
    
    if (string.length == 0) {
        _placeLabel.hidden = YES;
        [self p_updateLimitText:@""];
        [self p_textChange];
    } else if (string.length > UPMessageReportReasonMax) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            _placeLabel.hidden = NO;
            _textView.text = [string substringWithRange:NSMakeRange(0, UPMessageReportReasonMax)];
            [self p_textChange];
        });
    } else {
        _placeLabel.hidden = YES;
        [self p_updateLimitText:_textView.text];
        [self p_textChange];
    }
}

#pragma mark - private

- (void)p_updateLimitText:(NSString *)text {
    _limitLabel.text = [[@(text.length).stringValue stringByAppendingString:@"/"] stringByAppendingString:@(UPMessageReportReasonMax).stringValue];
}

- (void)p_textChange {
    if (_delegate &&
        [_delegate respondsToSelector:@selector(up_reportInputCellTextChangeEvent:text:)]) {
        [_delegate up_reportInputCellTextChangeEvent:self text:_textView.text];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
