//
//  QYKeyboardTextView.h
//  MHRefresh
//
//  Created by panle on 2018/9/28.
//  Copyright © 2018年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QYKeyboardTextView;

@protocol QYKeyboardTextViewDelegate <NSObject>

- (void)qy_keyboardTextViewTextHeightDidChange:(QYKeyboardTextView *)keyBoardTextView;

@end

@interface QYKeyboardTextView : UITextView

@property (nonatomic, assign) NSInteger showMaxLines;

@property (nonatomic, weak) id <QYKeyboardTextViewDelegate> textDelegate;

@end
