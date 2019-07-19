//
//  QYAttributedLabel.h
//  MHRefresh
//
//  Created by panle on 2019/7/16.
//  Copyright © 2019 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYAttributedCheckingResult.h"

NS_ASSUME_NONNULL_BEGIN

@class QYAttributedLabel;

typedef NS_ENUM(NSInteger, QYAttributedLabelContentMode) {
    QYAttributedLabelContentModeCenter,
    QYAttributedLabelContentModeLeft,
    QYAttributedLabelContentModeRight,
    QYAttributedLabelContentModeTop,
    QYAttributedLabelContentModeBottom
};

@protocol QYAttributedLabelDelegate <NSObject>

- (void)qy_attributeLabelTapEvent:(QYAttributedLabel *)attributeLabel checkingResult:(QYAttributedCheckingResult *)checkingResult;

@end


@protocol UPEventLabelDelegate <NSObject>
@property (nonatomic, copy) id text;
@end

@interface QYAttributedLabel : UILabel

- (void)updateText:(NSString *)text andHighLightText:(NSArray <NSString *>*)highLightTextArray;

@property (nonatomic, weak) id <QYAttributedLabelDelegate> eventDelegate;

/** 默认显示的属性 */
@property (nonatomic, strong) NSDictionary *resultAttributes;
/** 点击时显示的属性 */
@property (nonatomic, strong) NSDictionary *activeLinkAttributes;
/** 不获取状态时的属性 */
@property (nonatomic, strong) NSDictionary *inactiveLinkAttributes;

/** edge inset for backgroud link {0, -1, 0, -1} */
@property (nonatomic, assign) UIEdgeInsets linkBackgroundEdgeInset;

/** default NO */
@property (nonatomic, assign) BOOL extendsLinkTouchArea;


@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat highlightedShadowRadius;
@property (nonatomic, assign) CGSize highlightedShadowOffset;
@property (nonatomic, strong) UIColor *highlightedShadowColor;
@property (nonatomic, assign) CGFloat kern;

///--------------------------------------------
/// @name Acccessing Paragraph Style Attributes
///--------------------------------------------

@property (nonatomic, assign) CGFloat firstLineIndent;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat minimumLineHeight;
@property (nonatomic, assign) CGFloat maximumLineHeight;
@property (nonatomic, assign) CGFloat lineHeightMultiple;

@property (nonatomic, assign) IBInspectable UIEdgeInsets textInsets;

@property (nonatomic, assign) QYAttributedLabelContentMode qy_contentMode;

///--------------------------------------------
/// @name Accessing Truncation Token Appearance
///--------------------------------------------

/**
 The attributed string to apply to the truncation token at the end of a truncated line.
 */
@property (nonatomic, strong) IBInspectable NSAttributedString *attributedTruncationToken;

///--------------------------------------------
/// @name Calculating Size of Attributed String
///--------------------------------------------

+ (CGSize)sizeThatFitsAttributedString:(NSAttributedString *)attributedString
                       withConstraints:(CGSize)size
                limitedToNumberOfLines:(NSUInteger)numberOfLines;

///----------------------------------
/// @name Setting the Text Attributes
///----------------------------------

//- (void)setText:(id)text;


///------------------------------------
/// @name Accessing the Text Attributes
///------------------------------------

//@property (readwrite, nonatomic, copy) NSAttributedString *attributedText;

///-------------------
/// @name Adding Links
///-------------------

//- (void)addLink:(UPEventLabelLink *)link;
//- (UPEventLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result;
//- (UPEventLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result
//                                         attributes:(NSDictionary *)attributes;
//
//- (UPEventLabelLink *)addLinkToURL:(NSURL *)url
//                         withRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
