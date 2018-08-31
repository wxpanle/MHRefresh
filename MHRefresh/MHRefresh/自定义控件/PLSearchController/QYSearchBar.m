//
//  QYSearchBar.m
//  MHRefresh
//
//  Created by panle on 2018/7/18.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYSearchBar.h"
#import "NSBundle+QYSearchExtension.h"

static const CGFloat kSearchBarH = 52.0;

static const CGFloat kEdgeSpace = 15.0;
static const CGFloat kCancelBLeading = 16.0;

static const CGFloat kTextFieldH = 36.0;
static const CGFloat kTextFieldTBSpace = 8.0;

static const CGFloat kSearchIconW = 34.0;
static const CGFloat kSearchIconH = 16.0;

static const CGFloat kClearIconW = 38.0;

@interface QYSearchBar () <UITextFieldDelegate>

@property (nonatomic, assign) UPSearchBarState state;

@property (nonatomic, weak) id <QYSearchBarUpdateDelegate> updateDelegate;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIImageView *searchIconImageView;

@property (nonatomic, strong) UILabel *defaultStatePlaceLabel;

@property (nonatomic, strong) NSMutableDictionary *placeholdStringDictionary;

@property (nonatomic, strong) NSMutableDictionary *placeholdCacheWidthDictionary;

@end

@implementation QYSearchBar

+ (instancetype)qy_searchBarWithUpdateDelegate:(__weak id <QYSearchBarUpdateDelegate>)delegate {
    return [[self alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREEN_W, kSearchBarH) withUpdateDelegate:delegate];
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame withUpdateDelegate:(__weak id <QYSearchBarUpdateDelegate>)delegate {
    
    if (self = [super initWithFrame:frame]) {
        _updateDelegate = delegate;
        [self layoutOfUI];
    }
    return self;
}

#pragma mark - public

- (void)qy_setPlaceholderString:(NSString *)placeholder state:(UPSearchBarState)state {
    
    if (!placeholder.length) {
        [self.placeholdStringDictionary removeObjectForKey:@(state).stringValue];
        [self.placeholdCacheWidthDictionary setObject:@(0.0) forKey:@(state).stringValue];
    } else {
        [self.placeholdStringDictionary setObject:placeholder forKey:@(state).stringValue];
        CGFloat width = [self p_sizeWithString:placeholder font:self.defaultStatePlaceLabel.font].width;
        width = width >= SCREEN_W / 3.0 ? SCREEN_W / 3.0 : width;
        [self.placeholdCacheWidthDictionary setObject:@(width) forKey:@(state).stringValue];
    }
    
    CGFloat width = [[self.placeholdCacheWidthDictionary objectForKey:@(UPSearchBarStateDefault).stringValue] floatValue];
    self.defaultStatePlaceLabel.sm_width = width;
    self.defaultStatePlaceLabel.text = [self.placeholdStringDictionary objectForKey:@(UPSearchBarStateDefault).stringValue];
    
    switch (_state) {
        case UPSearchBarStateDefault: {
            self.searchIconImageView.sm_x = (SCREEN_W - width - self.searchIconImageView.sm_width) / 2.0;
            self.defaultStatePlaceLabel.sm_x = CGRectGetMaxX(self.searchIconImageView.frame);
            self.defaultStatePlaceLabel.hidden = NO;
            self.searchIconImageView.hidden = NO;
            break;
        }
            
        case UPSearchBarStateEditing:
            
            _textField.placeholder = [self.placeholdStringDictionary objectForKey:@(UPSearchBarStateEditing).stringValue];
            
            break;
    }
}

- (void)qy_becomeFirstResponder {
    [_textField becomeFirstResponder];
}

- (void)qy_resignFirstResponder {
    [_textField resignFirstResponder];
}

- (void)qy_startAnimation {
    _cancelButton.alpha = 0.0;
    CGFloat width = [[self.placeholdCacheWidthDictionary objectForKey:@(UPSearchBarStateDefault).stringValue] floatValue];
    self.searchIconImageView.sm_x = (SCREEN_W - width - self.searchIconImageView.sm_width) / 2.0;
    self.defaultStatePlaceLabel.sm_x = CGRectGetMaxX(self.searchIconImageView.frame);
    self.defaultStatePlaceLabel.hidden = NO;
    self.searchIconImageView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _cancelButton.hidden = NO;
        _cancelButton.alpha = 1.0;
        self.searchIconImageView.sm_x = kEdgeSpace;
        self.defaultStatePlaceLabel.sm_x = kEdgeSpace + CGRectGetWidth(self.searchIconImageView.frame);
        _textField.sm_width = SCREEN_W - _cancelButton.sm_width - kEdgeSpace * 2.0 - kCancelBLeading;
    } completion:^(BOOL finished) {
        self.searchIconImageView.hidden = YES;
        self.defaultStatePlaceLabel.hidden = YES;
        _textField.placeholder = [self.placeholdStringDictionary objectForKey:@(UPSearchBarStateEditing).stringValue];
        _textField.leftView.hidden = NO;
    }];
}

- (void)qy_endAnimation {
    CGFloat width = [[self.placeholdCacheWidthDictionary objectForKey:@(UPSearchBarStateDefault).stringValue] floatValue];
    _textField.text = @"";
    _textField.placeholder = @"";
    _textField.leftView.hidden = YES;
    self.defaultStatePlaceLabel.hidden = NO;
    self.searchIconImageView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _cancelButton.hidden = YES;
        _cancelButton.alpha = 0.0;
        self.searchIconImageView.sm_x = (SCREEN_W - width - self.searchIconImageView.sm_width) / 2.0;
        self.defaultStatePlaceLabel.sm_x = CGRectGetMaxX(self.searchIconImageView.frame);
        _textField.sm_width = SCREEN_W - kEdgeSpace * 2.0;
    } completion:^(BOOL finished) {
        [self qy_resignFirstResponder];
    }];
}

#pragma mark - layoutOfUI

- (void)layoutOfUI {
    [self layoutUIOfSelf];
    [self layoutUIOfBgImageView];
    [self layoutUIOfTextField];
    [self layoutUIOfCancelButton];
}

- (void)layoutUIOfSelf {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOfBgImageView {
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _bgImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgImageView];
}

- (void)layoutUIOfTextField {
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(kEdgeSpace, kTextFieldTBSpace, SCREEN_W - kEdgeSpace * 2.0, kTextFieldH)];
    
    UIImage *image = [UIImage imageNamed:@"qy_search_box"];
    _textField.background = image;

    _textField.font = [UIFont fontPingFang:QYPingFangSCRegular size:15.0];
    _textField.textColor = [UIColor colorWithHexString:@"272727"];
    
    [_textField addTarget:self
                   action:@selector(p_textFieldDidChange)
         forControlEvents:UIControlEventEditingChanged];
    _textField.delegate = self;
    
    UIImageView *searchIcon = [self p_searchIconImageView];
    searchIcon.frame = CGRectMake(0, 0, kSearchIconW, kSearchIconH);
    _textField.leftView = searchIcon;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(0, 0, kClearIconW, kTextFieldH);
    [clearButton setImage:[UIImage imageNamed:@"qy_search_clear"] forState:UIControlStateNormal];
    [clearButton addTarget:self
                    action:@selector(p_clearSearch)
          forControlEvents:UIControlEventTouchUpInside];
    _textField.rightView = clearButton;
    _textField.rightViewMode = UITextFieldViewModeWhileEditing;
    
    _textField.leftView.hidden = YES;
    _textField.rightView.hidden = YES;
    
    clearButton.hidden = YES;
    
    _textField.leftView.sm_x = SCREEN_W / 2.0;
    
    [self addSubview:_textField];
}

- (void)layoutUIOfCancelButton {
    
    NSString *string = [NSBundle qy_localizedStringForKey:@"QYSearchCancelButtonText"];
    if (!string.length) {
        string = @"取消";
    }
    UIFont *font = [UIFont fontPingFang:QYPingFangSCRegular size:15.0];
    CGSize size = [self p_sizeWithString:string font:font];
    
    CGFloat offentX = SCREEN_W - size.width - kEdgeSpace;
    CGFloat offentY = (kSearchBarH - size.height) / 2.0;
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:string forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = font;
    _cancelButton.frame = CGRectMake(offentX, offentY, size.width, size.height);
    
    _cancelButton.hidden = YES;
    
    [_cancelButton addTarget:self
               action:@selector(p_cancel)
     forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelButton];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_updateDelegate && [_updateDelegate respondsToSelector:@selector(qy_searchBarShouldBeginEditing:)]) {
        return [_updateDelegate qy_searchBarShouldBeginEditing:self];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(qy_searchBarDidBeginEditing:)]) {
        [_delegate qy_searchBarDidBeginEditing:self];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (_updateDelegate && [_updateDelegate respondsToSelector:@selector(qy_searchBarShouldEndEditing:)]) {
        return [_updateDelegate qy_searchBarShouldEndEditing:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(qy_searchBarDidEndEditing:)]) {
        [_delegate qy_searchBarDidEndEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - event

- (void)p_textFieldDidChange {
    
    _textField.rightView.hidden = !(_textField.text.length != 0 && _textField.isEditing);
    
    if (_updateDelegate && [_updateDelegate respondsToSelector:@selector(qy_searchBar:textDidChange:)]) {
        [_updateDelegate qy_searchBar:self textDidChange:_textField.text];
    }
}

- (void)p_clearSearch {
    _textField.text = @"";
}

- (void)p_cancel {
    
    if (_updateDelegate && [_updateDelegate respondsToSelector:@selector(qy_searchBarCancel:)]) {
        [_updateDelegate qy_searchBarCancel:self];
    }
}

#pragma mark - setter

- (void)setPlaceholder:(NSString *)placeholder {
    _textField.placeholder = placeholder;
}

- (void)setSearchBgImage:(UIImage *)searchBgImage {
    _bgImageView.image = searchBgImage;
}

- (void)setSearchBgColor:(UIColor *)searchBgColor {
    _bgImageView.backgroundColor = searchBgColor == nil ? [UIColor whiteColor] : searchBgColor;
}

- (void)setSearchTextFieldBgColor:(UIColor *)searchTextFieldBgColor {
    _textField.backgroundColor = searchTextFieldBgColor;
}


#pragma mark - private

- (NSMutableDictionary *)placeholdStringDictionary {
    
    if (nil == _placeholdStringDictionary) {
        _placeholdStringDictionary = [NSMutableDictionary dictionary];
    }
    return _placeholdStringDictionary;
}

- (NSMutableDictionary *)placeholdCacheWidthDictionary {
    
    if (nil == _placeholdCacheWidthDictionary) {
        _placeholdCacheWidthDictionary = [NSMutableDictionary dictionary];
    }
    return _placeholdCacheWidthDictionary;
}

- (UILabel *)defaultStatePlaceLabel {
    
    if (nil == _defaultStatePlaceLabel) {
        _defaultStatePlaceLabel = [[UILabel alloc] init];
        _defaultStatePlaceLabel.textColor = [UIColor colorWithHexString:@"8e8e93"];
        UIFont *font = [UIFont fontPingFang:QYPingFangSCRegular size:15.0];
        _defaultStatePlaceLabel.font = font;
        
        CGFloat height = [self p_sizeWithString:nil font:font].height;
        CGFloat offentY = (kSearchBarH - height) / 2.0;
        _defaultStatePlaceLabel.frame = CGRectMake(0, offentY, 0, height);
        [self addSubview:_defaultStatePlaceLabel];
        _defaultStatePlaceLabel.hidden = YES;
    }
    return _defaultStatePlaceLabel;
}

- (UIImageView *)searchIconImageView {
    if (nil == _searchIconImageView) {
        _searchIconImageView = [self p_searchIconImageView];
        CGFloat offentY = (kSearchBarH - kSearchIconH) / 2.0;
        _searchIconImageView.frame = CGRectMake(0, offentY, kSearchIconW, kSearchIconH);
        _searchIconImageView.hidden = YES;
        [self addSubview:_searchIconImageView];
    }
    return _searchIconImageView;
}

- (UIImageView *)p_searchIconImageView {
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qy_search_icon"]];
    searchIcon.contentMode = UIViewContentModeScaleAspectFit;
    return searchIcon;
}

- (CGSize)p_sizeWithString:(NSString *)string font:(UIFont *)font {
    
    if (nil == font) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    
    __autoreleasing NSString *tempString = [string copy];
    
    if (nil == tempString || !tempString.length) {
        tempString = @"字符串为空";
    }
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraph};
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect frame = [tempString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:options attributes:attributes context:nil];
    
    return CGSizeMake(ceil(frame.size.width), ceil(frame.size.height));
}

@end
