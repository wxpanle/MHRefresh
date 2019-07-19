//
//  UPEventLabel.h
//  Up
//
//  Created by panle on 2018/4/27.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@class UPEventLabel;

typedef NS_ENUM(NSInteger, UPEventLabelContentMode) {
    UPEventLabelContentModeCenter,
    UPEventLabelContentModeLeft,
    UPEventLabelContentModeRight,
    UPEventLabelContentModeTop,
    UPEventLabelContentModeBottom
};

@class UPEventLabel, UPEventLabelLink;

@protocol UPEventLabelEventDelegate <NSObject>

@optional
- (void)up_eventLabel:(UPEventLabel *)label selectedLink:(NSURL *)url;

- (void)up_eventLabelCopyEvent:(UPEventLabel *)label;

- (void)up_eventLabel:(UPEventLabel *)label longPressLink:(NSURL *)url point:(CGPoint)point;

@end


@protocol UPEventLabelDelegate <NSObject>
@property (nonatomic, copy) id text;
@end

@interface UPEventLabel : UILabel <UPEventLabelDelegate, UIGestureRecognizerDelegate>

- (void)updateText:(NSString *)text andHighLightText:(NSArray <NSString *>*)highLightTextArray;

- (instancetype) init NS_UNAVAILABLE;

@property (nonatomic, weak) id <UPEventLabelEventDelegate> eventDelegate;

@property (readonly, nonatomic, strong) NSArray <NSTextCheckingResult *>* links;

@property (nonatomic, strong) NSDictionary *linkAttributes;

@property (nonatomic, strong) NSDictionary *activeLinkAttributes;

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

@property (nonatomic, assign) UPEventLabelContentMode up_contentMode;

///--------------------------------------------
/// @name Accessing Truncation Token Appearance
///--------------------------------------------

/**
 The attributed string to apply to the truncation token at the end of a truncated line.
 */
@property (nonatomic, strong) IBInspectable NSAttributedString *attributedTruncationToken;

///--------------------------
/// @name Long press gestures
///--------------------------

@property (nonatomic, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;

///--------------------------------------------
/// @name Calculating Size of Attributed String
///--------------------------------------------

+ (CGSize)sizeThatFitsAttributedString:(NSAttributedString *)attributedString
                       withConstraints:(CGSize)size
                limitedToNumberOfLines:(NSUInteger)numberOfLines;

///----------------------------------
/// @name Setting the Text Attributes
///----------------------------------

- (void)setText:(id)text;


///------------------------------------
/// @name Accessing the Text Attributes
///------------------------------------

@property (readwrite, nonatomic, copy) NSAttributedString *attributedText;

///-------------------
/// @name Adding Links
///-------------------

- (void)addLink:(UPEventLabelLink *)link;
- (UPEventLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result;
- (UPEventLabelLink *)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result
                                         attributes:(NSDictionary *)attributes;

- (UPEventLabelLink *)addLinkToURL:(NSURL *)url
                         withRange:(NSRange)range;


@end


@interface UPEventLabelLink : NSObject

typedef void (^ UPEventLabelLinkBlock) (UPEventLabel *, UPEventLabelLink *);

@property (nonatomic, readonly) NSTextCheckingResult *result;

@property (nonatomic, readonly) NSDictionary *attributes;

@property (nonatomic, readonly) NSDictionary *activeAttributes;

@property (nonatomic, readonly) NSDictionary *inactiveAttributes;

@property (nonatomic, copy) UPEventLabelLinkBlock linkTapBlock;

@property (nonatomic, copy) UPEventLabelLinkBlock linkLongPressBlock;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
                  activeAttributes:(NSDictionary *)activeAttributes
                inactiveAttributes:(NSDictionary *)inactiveAttributes
                textCheckingResult:(NSTextCheckingResult *)result;

- (instancetype)initWithAttributesFromLabel:(UPEventLabel *)label
                         textCheckingResult:(NSTextCheckingResult *)result;

@end
