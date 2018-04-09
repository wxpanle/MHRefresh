//
//  MCAlertView.m
//  test
//
//  Created by developer on 2017/5/25.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MCAlertView.h"

#pragma mark - MDownLoadSelectAction

@protocol MMCAlertActionDelegate <NSObject>

- (void)didTapAction;

@end

@interface MCAlertAction()

@property (nonatomic, weak) id <MMCAlertActionDelegate> delegate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) double downLoadSize;

@property (nonatomic, assign) MCAlertActionType actionType;

@property (nonatomic, copy) MCAlertActionBlock handleBlock;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *color;

- (UIButton *)getDownLoadActionButton;

@end

@implementation MCAlertAction

- (void)dealloc {
    DLog(@"%@ dealloc", self);
}

- (instancetype)initWithTitle:(NSString *)title downLoadSize:(double)size actionType:(MCAlertActionType)actionType handle:(MCAlertActionBlock)handle {
    if (self = [super init]) {
        self.title = title;
        self.downLoadSize = size;
        self.actionType = actionType;
        self.handleBlock = handle;
        [self layoutUI];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title actionType:(MCAlertActionType)actionType handle:(MCAlertActionBlock)handle {
    if (self = [super init]) {
        self.title = title;
        self.downLoadSize = 0.0;
        self.actionType = actionType;
        self.handleBlock = handle;
        [self layoutUI];
    }
    return self;
}

- (void)setTextFont:(UIFont *)font {
    _font = font;
}

- (void)setTextColor:(UIColor *)color {
    _color = color;
}

- (void)layoutUI {
    [self createButton];
}

- (UIButton *)getDownLoadActionButton {
    if (nil == _button) {
        [self createButton];
    }
    return _button;
}

#pragma mark - MDownLoadSelectAction private
- (void)createButton {
    if (nil == _button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        switch (_actionType) {
            case MCAlertActionTypeCancelImgae: {
                [self cancelButtonImage];
            }
                break;
                
            case MCAlertActionTypeCancelText: {
                [self cancelButtonText];
            }
                break;
                
            case MCAlertActionTypeDelete: {
                _font = [UIFont fontPingFang:QYPingFangSCSemibold size:16.0];
                _color = [UIColor colorWithHexString:@"4f83d9" alpha:1.0];
            }
            case MCAlertActionTypeDownLoad:
            case MCAlertActionTypeDefault: {
                [_button setAttributedTitle:[self getAttributeString] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
        
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        _button.titleLabel.numberOfLines = 0;
        [_button addTarget:self action:@selector(didTapAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)cancelButtonImage {
    UIImage *image = [[UIImage imageNamed:@"shop_buy_cancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_button setImage:image forState:UIControlStateNormal];
    _button.frame = CGRectMake(0, 0, 32, 32);
}

- (void)cancelButtonText {
    UIFont *font = _font ? _font : [UIFont fontPingFang:QYPingFangSCMedium size:16.0];
    UIColor *color = _color ? _color : [UIColor colorWithIntegerRed:161 green:161 blue:161];
    NSAttributedString *string = [self getAttributeString:self.title withColor:color andFont:font];
    [_button setAttributedTitle:string forState:UIControlStateNormal];
}

- (void)didTapAction {
    if (_handleBlock) {
        _handleBlock(self);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapAction)]) {
        [self.delegate didTapAction];
    }
}

- (NSAttributedString *)getAttributeString {
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] init];
    
    NSString *title = self.title;
    NSAttributedString *textAttributeString = [self getTextAttribute:title];
    if (textAttributeString.length) {
        [mutableAttributeString appendAttributedString:textAttributeString];
    }
    
    if (self.downLoadSize != 0) {
        double size = _downLoadSize / 1024.0 / 1024.0;
        NSString *sizeString = [NSString stringWithFormat:@"\n%.2fM", size];
        NSAttributedString *sizeAttributeString = [self getSizeAttribute:sizeString];
        if (sizeAttributeString.length) {
            [mutableAttributeString appendAttributedString:sizeAttributeString];
        }
    }

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0.0;
    style.alignment = NSTextAlignmentCenter;
    [mutableAttributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mutableAttributeString.string.length)];
    
    return mutableAttributeString;
}

- (NSAttributedString *)getSizeAttribute:(NSString *)string {
    UIColor *color = [UIColor colorWithIntegerRed:161 green:161 blue:161];
    UIFont *font = [UIFont fontPingFang:QYPingFangSCMedium size:10.0];
    return [self getAttributeString:string withColor:color andFont:font];
}

- (NSAttributedString *)getTextAttribute:(NSString *)string {
    UIFont *font = _font ? _font : [UIFont fontPingFang:QYPingFangSCMedium size:16.0];
    UIColor *color = _color ? _color : [UIColor colorWithIntegerRed:63 green:144 blue:220];
    return [self getAttributeString:string withColor:color andFont:font];
}

- (NSAttributedString *)getAttributeString:(NSString *)string withColor:(UIColor *)color andFont:(UIFont *)font {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    UIFont *mFont = font == nil ? [UIFont systemFontOfSize:17.0] : font;
    UIColor *mColor = color == nil ? [UIColor whiteColor] : color;
    [dictionary setObject:mFont forKey:NSFontAttributeName];
    [dictionary setObject:mColor forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:string attributes:dictionary];
    return attributeString;
}

@end


#pragma mark - MCAlertView

static const CGFloat kAlertViewWidth = 242.0;
static const CGFloat kAlertMainBodyHeight = 89.5;
static const CGFloat kTitleAndMessageLabelDefaultEdge = 16.0;
static const CGFloat kImageViewOffentBottom = 10.0;
static const CGFloat kAlertHalfButtonWidth = 120.5;
static const CGFloat kAlertButtonHeight = 49.0;
static const CGFloat kAlertLineWidth = 0.5;

static const CGFloat kSheetEdgeTop = 30.0;
static const CGFloat kSheetEdgeBottom = 7.0;

static const NSTimeInterval kAlertAnimationDuration = 0.25;


typedef NS_ENUM(NSInteger, MCAlertButtonLayoutType) {
    MCAlertButtonLayoutTypeHalfWidth,
    MCAlertButtonLayoutTypeFullWidth
};

@interface MCAlertView() <MMCAlertActionDelegate>

@property (nonatomic, assign) MCAlertViewType viewType;

@property (nonatomic, assign) MCAlertImagePosition imagePosition;

@property (nonatomic, strong) NSMutableArray <MCAlertAction *> *actionArray;

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *message;

/** 主容器 */
@property (nonatomic, strong) UIView *containerView;

/** 按钮容器 MCAlertAction */
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, assign) CGFloat topContainerHeight;

@property (nonatomic, assign) CGFloat actionContainerHeight;

@property (nonatomic, assign) CGFloat bottomContainerHeight;

@property (nonatomic, assign) MCAlertButtonLayoutType mCAlertButtonLayoutType;

@property (nonatomic, assign, getter=isShowing) BOOL showing;

@property (nonatomic, assign) BOOL isHasActionCancelImage;

@property (nonatomic, assign) BOOL isHasActionCancelText;

@property (nonatomic, assign) BOOL isScrollEnable;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIFont *messageFont;

@property (nonatomic, strong) UIColor *messageColor;

@end

@implementation MCAlertView

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message MAlertViewType:(MCAlertViewType)viewType {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)]) {
        self.title = title;
        self.message = message;
        _viewType = viewType;
        [self layoutUIOfSelf];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName imagePosition:(MCAlertImagePosition)position message:(NSString *)message MAlertViewType:(MCAlertViewType)viewType {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)]) {
        self.title = title;
        self.message = message;
        self.imageName = imageName;
        self.imagePosition = position;
        _viewType = viewType;
        [self layoutUIOfSelf];
    }
    return self;
}

#pragma mark - layoutUI
- (void)layoutUIOfSelf {
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    self.userInteractionEnabled = YES;
    _isHasActionCancelImage = NO;
    _isHasActionCancelText = NO;
    _isScrollEnable = NO;
    _topContainerHeight = 0.0;
    _actionContainerHeight = 0.0;
    _bottomContainerHeight = 0.0;
}

#pragma mark - public
- (void)addAlertAction:(MCAlertAction *)action {
    if (nil == action || self.isShowing) {
        return; //开始布局后不再接受新的action
    }
    [self.actionArray addObject:action];
}

- (void)showAlertActionView {
    
    if (self.isShowing) {
        return; //正在布局中不接受再一次布局
    }
    
    self.showing = YES;
    
    [self clearNoNeedCancelActionWith:MCAlertActionTypeCancelImgae];
    [self clearNoNeedCancelActionWith:MCAlertActionTypeCancelText];
    [self calculateContainerViewHeight];
    [self startLayoutView];
    [self startShowView];
}

#pragma mark layout action
- (void)clearNoNeedCancelActionWith:(MCAlertActionType)type {
    NSPredicate *predicate = nil;
    
    switch (type) {
        case MCAlertActionTypeCancelImgae:
        case MCAlertActionTypeCancelText: {
            predicate = [NSPredicate predicateWithBlock:^BOOL(MCAlertAction *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return evaluatedObject.actionType == type;
            }];
        }
            break;
            
        default:
            break;
    }
    
    if (nil == predicate) {
        return;
    }
    
    NSArray *array = [self.actionArray filteredArrayUsingPredicate:predicate];
    
    if (array.count == 0) {
        return;
    }
    
    if (type == MCAlertActionTypeCancelImgae) {
        _isHasActionCancelImage = YES; //判断是否需要添加右上角取消按钮
    }
    
    if (type == MCAlertActionTypeCancelText) {
        _isHasActionCancelText = YES; //判断是否有取消文字
    }
    
    MCAlertAction *action = array.lastObject;
    [self.actionArray removeObjectsInArray:array];
    [self.actionArray addObject:action];
}

#pragma mark - layout action button
- (void)startLayoutView {
    
    //主容器
    [self layoutUIOfContainerView];
    
    //布局弹窗头部视图
    [self layoutUIOfTopBodyView];
    
    //布局actionButton
    [self layoutUIOfActionView];
}

- (void)layoutUIOfContainerView {
    [self addSubview:self.containerView];
}

- (void)layoutUIOfTopBodyView {
    
    BOOL isImageExist = nil == _imageView ? NO : YES;
    BOOL isTitleExist = nil == _titleLabel ? NO : YES;
    BOOL isMessageExist = nil == _messageLabel ? NO : YES;
    
    CGFloat x = self.containerView.sm_width / 2.0;
    
    if (isImageExist && isTitleExist && isMessageExist) { //如果三者都存在
        CGFloat imageViewY = kTitleAndMessageLabelDefaultEdge;
        CGFloat titleLabelY = kTitleAndMessageLabelDefaultEdge;
        CGFloat messageLabelY = kTitleAndMessageLabelDefaultEdge;
        
        switch (self.imagePosition) {
            case MCAlertImagePositionTop: {
                
                imageViewY += _imageView.sm_height / 2.0;
                titleLabelY += _imageView.sm_height + kImageViewOffentBottom + _titleLabel.sm_height / 2.0;
                messageLabelY += _imageView.sm_height + kImageViewOffentBottom + _titleLabel.sm_height + kTitleAndMessageLabelDefaultEdge + _messageLabel.sm_height / 2.0;
                break;
            }
                
            case MCAlertImagePositionBottom: {
                titleLabelY += _titleLabel.sm_height / 2.0;
                messageLabelY += _titleLabel.sm_height + kTitleAndMessageLabelDefaultEdge + _messageLabel.sm_height / 2.0;
                imageViewY += kTitleAndMessageLabelDefaultEdge + _titleLabel.sm_height + _messageLabel.sm_height + kImageViewOffentBottom + _imageView.sm_height / 2.0;
                break;
            }
                
            case MCAlertImagePositionCenter:{
                titleLabelY += _titleLabel.sm_height / 2.0;
                imageViewY += kImageViewOffentBottom + _titleLabel.sm_height + _imageView.sm_height / 2.0;
                messageLabelY += kImageViewOffentBottom * 2 + _titleLabel.sm_height + _imageView.sm_height + _messageLabel.sm_height / 2.0;
                break;
            }
            default:
                break;
        }
        
        _imageView.center = CGPointMake(x, imageViewY);
        _titleLabel.center = CGPointMake(x, titleLabelY);
        _messageLabel.center = CGPointMake(x, messageLabelY);
    } else if (isImageExist && isTitleExist) {
        
        CGFloat imageViewY = kTitleAndMessageLabelDefaultEdge;
        CGFloat titleLabelY = kTitleAndMessageLabelDefaultEdge;
        
        switch (self.imagePosition) {
            case MCAlertImagePositionTop: {
                
                imageViewY += _imageView.sm_height / 2.0;
                titleLabelY += _imageView.sm_height + kImageViewOffentBottom + _titleLabel.sm_height / 2.0;
                break;
            }
                
            case MCAlertImagePositionBottom:
            case MCAlertImagePositionCenter:{
                titleLabelY += _titleLabel.sm_height / 2.0;
                imageViewY += kImageViewOffentBottom + _titleLabel.sm_height + _imageView.sm_height / 2.0;
                break;
            }
            default:
                break;
        }
        
        _imageView.center = CGPointMake(x, imageViewY);
        _titleLabel.center = CGPointMake(x, titleLabelY);
    } else if (isImageExist && isMessageExist) {
        CGFloat imageViewY = kTitleAndMessageLabelDefaultEdge;
        CGFloat messageLabelY = kTitleAndMessageLabelDefaultEdge;
        
        switch (self.imagePosition) {
            case MCAlertImagePositionTop: {
                
                imageViewY += _imageView.sm_height / 2.0;
                messageLabelY += _imageView.sm_height + kImageViewOffentBottom + _messageLabel.sm_height / 2.0;
                break;
            }
                
            case MCAlertImagePositionBottom:
            case MCAlertImagePositionCenter:{
                messageLabelY += _messageLabel.sm_height / 2.0;
                imageViewY += kImageViewOffentBottom + _messageLabel.sm_height + _imageView.sm_height / 2.0;
                break;
            }
            default:
                break;
        }
        
        _imageView.center = CGPointMake(x, imageViewY);
        _messageLabel.center = CGPointMake(x, messageLabelY);
    } else if (isTitleExist && isMessageExist) {
        _messageLabel.center = CGPointMake(x, self.topContainerHeight - kTitleAndMessageLabelDefaultEdge - _messageLabel.frame.size.height / 2.0);
        _titleLabel.center = CGPointMake(x, self.topContainerHeight - kTitleAndMessageLabelDefaultEdge * 2 - _messageLabel.frame.size.height - 5);
    } else if (isImageExist) { //不考虑image位置 居中显示
        _imageView.center = CGPointMake(x, self.topContainerHeight / 2.0);
    } else if (isTitleExist) {
        _titleLabel.center = CGPointMake(x, self.topContainerHeight / 2.0);
    } else if (isMessageExist) {
        _messageLabel.center = CGPointMake(x, self.topContainerHeight / 2.0);
    } else {
        DLog(@"都不存在  发生错误");
    }
    
    isImageExist == NO ?: [self.containerView addSubview:_imageView];
    isTitleExist == NO ?: [self.containerView addSubview:_titleLabel];
    isMessageExist == NO ?: [self.containerView addSubview:_messageLabel];
}

- (void)layoutUIOfActionView {
    
    [self.containerView addSubview:self.scrollView];
    
    //布局起始线条
    CGFloat overallLineY = 0.0;
    UIView *overallLine = [self lineView];
    overallLine.frame = CGRectMake(0, overallLineY, kAlertViewWidth, 0.5);
    [self.scrollView addSubview:overallLine];
    overallLineY += 0.5;
    
    //处理取消按钮的顺序
    MCAlertAction *action = [self.actionArray lastObject];
    if (action.actionType == MCAlertActionTypeCancelText) {
        
        switch (self.viewType) {
            case MCAlertViewTypeAlert: { //如果为alert且按钮分割一半的话 将取消按钮提升至第一位
                if (self.mCAlertButtonLayoutType == MCAlertButtonLayoutTypeHalfWidth) {
                    [self.actionArray removeLastObject];
                    [self.actionArray insertObject:action atIndex:0];
                }
            }
                break;
                
            case MCAlertViewTypeSheet:{
                
                //布局取消按钮
                action.delegate = self;
                [self addSubview:self.bottomView];
                UIButton *button = [action getDownLoadActionButton];
                button.frame = CGRectMake(0, 0, kAlertViewWidth, kAlertButtonHeight);
                [self.bottomView addSubview:button];
                break;
            }
                
            default:
                break;
        }
    }
    
    UIView *lastLineView = nil;
    CGFloat overallLineX = 0.0;
    
    for (MCAlertAction *action in self.actionArray) {
        action.delegate = self;
        switch (action.actionType) {
            case MCAlertActionTypeCancelImgae: {
                UIButton *button = [action getDownLoadActionButton];
                button.frame = CGRectMake(self.containerView.sm_x + kAlertViewWidth - 23.0, self.containerView.sm_y - 14.0, 32, 32);
                [self addSubview:button];
            }
                break;
            case MCAlertActionTypeCancelText: {
                if (self.viewType == MCAlertViewTypeSheet) {
                    break;
                }
            }
            case MCAlertActionTypeDelete:
            case MCAlertActionTypeDefault:
            case MCAlertActionTypeDownLoad: {
                UIButton *button = [action getDownLoadActionButton];
                if (self.mCAlertButtonLayoutType == MCAlertButtonLayoutTypeFullWidth) {
                    button.frame = CGRectMake(0, overallLineY, kAlertViewWidth, kAlertButtonHeight);
                    [self.scrollView addSubview:button];
                    UIView *line = [self lineView];
                    line.frame = CGRectMake(0, overallLineY + kAlertButtonHeight, kAlertViewWidth, kAlertLineWidth);
                    [self.scrollView addSubview:line];
                    lastLineView = line;
                    overallLineY += (kAlertButtonHeight + kAlertLineWidth);
                } else {
                    button.frame = CGRectMake(overallLineX, overallLineY, kAlertHalfButtonWidth, kAlertButtonHeight);
                    [self.scrollView addSubview:button];
                    UIView *line = [self lineView];
                    line.frame = CGRectMake(overallLineX, overallLineY, kAlertLineWidth, kAlertButtonHeight);
                    [self.scrollView addSubview:line];
                    overallLineX += (kAlertHalfButtonWidth + kAlertLineWidth);
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    if (lastLineView) {
        [lastLineView removeFromSuperview];
        lastLineView = nil;
    }
}

#pragma mark - show hidden alert
- (void)startShowView {
    self.alpha = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:kAlertAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
}

- (void)cancelShowView {
    [UIView animateWithDuration:kAlertAnimationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - MCAlertActionDelegate
- (void)didTapAction {
    [self cancelShowView];
}

#pragma mark - setter
- (void)setTitleFont:(UIFont *)font {
    _titleFont = font;
}

- (void)setMessageFont:(UIFont *)font {
    _messageFont = font;
}

- (void)setTitleColor:(UIColor *)color {
    _titleColor = color;
}

- (void)setMessageColor:(UIColor *)color {
    _messageColor = color;
}

#pragma mark - getter
- (NSMutableArray <MCAlertAction *> *)actionArray {
    if (nil == _actionArray) {
        _actionArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _actionArray;
}

- (UIView *)containerView {
    if (nil == _containerView) {
    
        CGFloat width = kAlertViewWidth;
        CGFloat height = self.topContainerHeight + [self adjustActionContainerHeight];
        CGFloat offentX = (SCREEN_W - kAlertViewWidth) / 2.0;
        CGFloat offentY = 0.0;
        
        switch (self.viewType) {
            case MCAlertViewTypeAlert: {
                offentY = (SCREEN_H - height) / 2.0;
                break;
            }
                
            case MCAlertViewTypeSheet: {
                offentY = SCREEN_H - height - (_isHasActionCancelText ? kAlertButtonHeight + kSheetEdgeBottom * 2 : kSheetEdgeBottom);
                break;
            }
            default:
                break;
        }
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(offentX, offentY, width, height)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.cornerRadius = 8.5;
        _containerView.clipsToBounds = YES;
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.title;
        _titleLabel.textColor = _titleColor ? _titleColor : [UIColor colorWithIntegerRed:51 green:51 blue:51];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        UIFont *font = _titleFont ? _titleFont : [UIFont fontPingFang:QYPingFangSCSemibold size:16.0];
        CGFloat width = kAlertViewWidth - kTitleAndMessageLabelDefaultEdge * 2;
        CGFloat height = [self heightWithWidth:width andFont:font andString:self.title];
        _titleLabel.font = font;
        _titleLabel.frame = CGRectMake(0, 0, width, height);
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (nil == _messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = self.message;
        _messageLabel.textColor = _messageColor ? _messageColor : [UIColor colorWithIntegerRed:51 green:51 blue:51];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        UIFont *font = _messageFont ? _messageFont : [UIFont fontPingFang:QYPingFangSCSemibold size:16.0];
        CGFloat width = kAlertViewWidth - kTitleAndMessageLabelDefaultEdge * 2;
        CGFloat height = [self heightWithWidth:width andFont:font andString:self.message];
        _messageLabel.font = font;
        _messageLabel.frame = CGRectMake(0, 0, width, height);
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

- (UIImageView *)imageView {
    
    if (nil == _imageView) {
        UIImage *image = [UIImage imageNamed:self.imageName];
        _imageView = [[UIImageView alloc] initWithImage:image];
        CGSize imageSize = [self topImageSize];
        _imageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    }
    return _imageView;
}

- (UIScrollView *)scrollView {
    
    if (nil == _scrollView) {

        CGFloat height = _isScrollEnable ? [self adjustActionContainerHeight] : self.actionContainerHeight;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topContainerHeight, kAlertViewWidth, height)];
        _scrollView.scrollEnabled = _isScrollEnable;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(kAlertViewWidth, self.actionContainerHeight);
    }
    return _scrollView;
}

- (UIView *)bottomView {
    
    if (nil == _bottomView) {
        
        CGFloat width = kAlertViewWidth;
        CGFloat height = kAlertButtonHeight;
        CGFloat offentX = (self.sm_width - width) / 2.0;
        CGFloat offentY = self.sm_height - kSheetEdgeBottom - height;

        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(offentX, offentY, kAlertViewWidth, kAlertButtonHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.cornerRadius = 8.5;
        _bottomView.clipsToBounds = YES;
    }
    
    return _bottomView;
}

#pragma mark - MCAlertViewHelp help
- (void)calculateContainerViewHeight { //不包含sheet下底部按钮高度
    
    [self setActionLayoutType];
    
    self.topContainerHeight = [self calcuteTopHeight]; //上部高度
    
    self.bottomContainerHeight = [self calcuteBottomHeight]; //sheet下底部按钮高度
    
    self.actionContainerHeight = [self calcuteActionHeight]; //活动按钮高度
}

- (void)setActionLayoutType {
    
    switch (self.viewType) {
        case MCAlertViewTypeAlert: {
            if ([self getActionCount] == 2) {
                self.mCAlertButtonLayoutType = MCAlertButtonLayoutTypeHalfWidth;
            } else {
                self.mCAlertButtonLayoutType = MCAlertButtonLayoutTypeFullWidth;
            }
            break;
        }
            
        case MCAlertViewTypeSheet: {
            self.mCAlertButtonLayoutType = MCAlertButtonLayoutTypeFullWidth;
            break;
        }
            
        default:
            break;
    }
}

- (CGFloat)calcuteTopHeight {
    
    CGFloat imageViewHeight = [self topImageSize].height;
    CGFloat titleLabelHeight = 0.0;
    CGFloat messageLabelHeight = 0.0;
    
    if (self.title.length) {
        titleLabelHeight = self.titleLabel.frame.size.height;
    }
    
    if (self.message.length) {
        messageLabelHeight = self.messageLabel.frame.size.height;
    }
    
    if (self.imageName.length) {
        [self.imageView class];
    }

    CGFloat topHeight = 0.0;
    
    topHeight += ((imageViewHeight != 0.0 && (titleLabelHeight != 0.0 || messageLabelHeight != 0.0)) ? kImageViewOffentBottom : 0.0);
    
    topHeight += titleLabelHeight + messageLabelHeight + imageViewHeight;
    
    NSInteger count = (titleLabelHeight != 0.0 && messageLabelHeight != 0.0) ? 3 : 2;
    topHeight += kTitleAndMessageLabelDefaultEdge * count;
    
    if (self.imagePosition == MCAlertImagePositionCenter) {
        
        if (kTitleAndMessageLabelDefaultEdge > kImageViewOffentBottom) {
            topHeight -= (kTitleAndMessageLabelDefaultEdge - kImageViewOffentBottom);
        } else {
            topHeight += (kImageViewOffentBottom - kTitleAndMessageLabelDefaultEdge);
        }
    }
    
    if (topHeight <= kAlertMainBodyHeight) {
        topHeight = kAlertMainBodyHeight;
    }
    
    return topHeight;
}

- (CGFloat)calcuteActionHeight {
    
    CGFloat actionHeight = 0.0;
    NSInteger buttonCount = [self getActionCount];
    
    switch (self.viewType) {
        case MCAlertViewTypeSheet:
            if (_isHasActionCancelText) {
                buttonCount -= 1; //取消按钮置于最下方
            }
            break;
            
        default:
            break;
    }
    
    switch (self.mCAlertButtonLayoutType) {
        case MCAlertButtonLayoutTypeFullWidth: {
            actionHeight = (kAlertButtonHeight + kAlertLineWidth) * buttonCount;
        }
            break;
            
        case MCAlertButtonLayoutTypeHalfWidth: {
            actionHeight = kAlertButtonHeight + kAlertLineWidth;
        }
            break;
            
        default:
            break;
    }
    
    return actionHeight;
}

- (CGFloat)calcuteBottomHeight {
    //sheet情况下 需要
    CGFloat bottomHeight = 0.0;
    
    switch (self.viewType) {
        case MCAlertViewTypeSheet:
            if (_isHasActionCancelText) {
                bottomHeight = kAlertButtonHeight;
            }
            break;
            
        default:
            break;
    }
    
    return bottomHeight;
}

- (CGFloat)adjustActionContainerHeight {
    
    CGFloat allowHeight = 0.0;
    
    switch (self.viewType) {
        case MCAlertViewTypeAlert: {
            allowHeight = SCREEN_H - kSheetEdgeTop * 2 - self.topContainerHeight;
            break;
        }
            
        case MCAlertViewTypeSheet: {
            
            allowHeight = SCREEN_H - kSheetEdgeBottom - (_isHasActionCancelText ? kAlertButtonHeight + kSheetEdgeBottom : 0.0) - kSheetEdgeTop - self.topContainerHeight;
            break;
        }
            
        default:
            break;
    }
    
    if (self.actionContainerHeight > allowHeight) {
        _isScrollEnable = YES;
    } else {
        _isScrollEnable = NO;
        allowHeight = self.actionContainerHeight;
    }
    
    return allowHeight;
}

- (NSInteger)getActionCount {
    NSInteger count = self.actionArray.count - (_isHasActionCancelImage ? 1.0 : 0);
    return count >= 0 ? count : 0;
}

- (CGSize)topImageSize {
    
    if (!self.imageName.length) {
        return CGSizeZero;
    }
    
    UIImage *image = [UIImage imageNamed:self.imageName];
    if (image.size.width >= kAlertViewWidth - kTitleAndMessageLabelDefaultEdge * 2) {
        CGFloat height = (kAlertViewWidth - kTitleAndMessageLabelDefaultEdge * 2) * image.size.height / image.size.width;
        return CGSizeMake(kAlertViewWidth - kTitleAndMessageLabelDefaultEdge * 2, height);
    }
    
    return image.size;
}

- (UIView *)lineView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithIntegerRed:229 green:229 blue:229];
    return view;
}

- (CGFloat)heightWithWidth:(CGFloat)width andFont:(UIFont *)font andString:(NSString *)string {
    
    if (nil == font) {
        font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    }
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect frame = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName : font} context:nil];
    return frame.size.height;
}

#pragma mark - dealloc
- (void)dealloc {
    DLog(@"%@ dealloc", self);
}

@end
