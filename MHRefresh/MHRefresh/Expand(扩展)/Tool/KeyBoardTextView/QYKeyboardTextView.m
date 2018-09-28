//
//  QYKeyboardTextView.m
//  MHRefresh
//
//  Created by panle on 2018/9/28.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYKeyboardTextView.h"

@interface QYKeyboardTextView ()

@property (nonatomic, assign) CGFloat textMaxHeight;

@end

@implementation QYKeyboardTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)qy_layoutOfUI {
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_textDidChange)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

#pragma mark - event

- (void)p_textDidChange {
    
    CGFloat estimateHeight = ceil([self sizeThatFits:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)].height);
    
    if (estimateHeight > _textMaxHeight) {
        estimateHeight = _textMaxHeight;
        self.scrollEnabled = YES;
    } else {
        self.scrollEnabled = NO;
        CGRect frame = self.frame;
        frame.size.height = estimateHeight;
        self.frame = frame;
        [self p_callBackTextHeightChange];
    }
    [self layoutIfNeeded];
}


#pragma mark - setter

- (void)setShowMaxLines:(NSInteger)showMaxLines {
    _showMaxLines = showMaxLines;
    _textMaxHeight = ceil(self.font.lineHeight * showMaxLines + self.textContainerInset.top + self.textContainerInset.bottom);
}


#pragma mark - private

- (void)p_callBackTextHeightChange {
    if (_textDelegate &&
        [_textDelegate respondsToSelector:@selector(qy_keyboardTextViewTextHeightDidChange:)]) {
        [_textDelegate qy_keyboardTextViewTextHeightDidChange:self];
    }
}


#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLOG_DEALLOC
}


@end
