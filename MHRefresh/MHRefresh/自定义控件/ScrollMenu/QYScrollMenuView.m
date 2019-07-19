//
//  QYScrollMenuView.m
//  MHRefresh
//
//  Created by panle on 2019/7/19.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYScrollMenuView.h"

static const CGFloat kSplitLineVH = 0.5;
static const CGFloat kDefaultCacheCount = 5;

struct CGItemW {
    CGFloat normalW;
    CGFloat selectW;
};

typedef struct CG_BOXABLE CGItemW CGItemW;

@interface QYScrollMenuItem ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGItemW p_itemW;

@end

@interface QYScrollMenuView () <UIScrollViewDelegate> {
    CGFloat _p_startX;
    CGFloat _p_endX;
    CGFloat _p_lrSpace;
}

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIScrollView *itemScrollView;

@property (nonatomic, strong) UIView *indexLineView;
@property (nonatomic, strong) UIView *splitLineView;

@property (nonatomic, strong) NSMutableArray <UIButton *>* buttonArray;
@property (nonatomic, strong) NSMutableSet *cacheSet;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSArray <QYScrollMenuItem *> *itemsArray;

@end


@implementation QYScrollMenuItem

+ (QYScrollMenuItem *)qy_scrollMenuItemWithTitle:(NSString *)title
{
    return [[QYScrollMenuItem alloc] initWithTitle:title];
}

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.title = title;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithTitle:@""];
}

@end


@implementation QYScrollMenuView

#pragma mark - init

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self layoutQYScrollMenuViewOfUI];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self layoutQYScrollMenuViewOfUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self layoutQYScrollMenuViewOfUI];
    }
    return self;
}

- (void)dealloc
{
    _cacheSet = nil;
    for (UIButton *btn in _buttonArray) {
        [btn removeFromSuperview];
    }
    
    [_buttonArray removeAllObjects];
    _buttonArray = nil;
}


#pragma mark - public

- (void)qy_updateToIndex:(NSInteger)index
{
    //刷新布局
    if (index >= _buttonArray.count || index < 0) {
        index = 0;
    }
    
    [self p_resetButtonColorWithTargetIndex:index];
    _currentIndex = index;
    
    [self p_adjustLineViewFrame];
    [self p_adjustScrollViewOffset];
}

- (void)qy_configItems:(NSArray <QYScrollMenuItem *>*)items
{
    [self p_resetLayout];
    _itemsArray = items;
    [self p_startLayout];
    
}

- (void)layoutSubviews
{
    _itemScrollView.frame = self.bounds;
    [self p_resetLayout];
    [self p_startLayout];
    [self p_resetButtonColorWithTargetIndex:_currentIndex];
}


#pragma mark - callBack

- (void)p_callBackWithEvent:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(up_scrollMenuViewSelectEvent:index:)]) {
        [_delegate up_scrollMenuViewSelectEvent:self index:button.tag];
    }
    [self qy_updateToIndex:button.tag];
}


#pragma mark - layout

- (void)p_resetLayout
{
    for (UIButton *obj in _buttonArray) {
        [obj removeFromSuperview];
        [self.cacheSet addObject:obj];
    }
    
    [_buttonArray removeAllObjects];
    _currentIndex = 0;
}

- (void)p_startLayout
{
    _p_startX = 0.0;
    _p_lrSpace = 0.0;
    
    _itemScrollView.frame = self.bounds;
    
    [self p_resetMenuItemW];
    [self p_resetLayoutOfStartXAndLRSpace];
    [self p_addButton];
    [self p_adjustLineViewFrame];
}

- (void)p_addButton
{
    NSInteger tag = 0;
    CGFloat width = _p_startX;
    
    for (QYScrollMenuItem *menuItem in _itemsArray) {
        
        if (tag != 0) {
            width += _p_lrSpace;
        }
        
        UIButton *button = [self p_buttonWithTitle:menuItem.title tag:tag];
        button.frame = CGRectMake(width, 0.0, menuItem.p_itemW.normalW, _itemScrollView.frame.size.height);
        [_itemScrollView addSubview:button];
        [self.buttonArray addObject:button];
        width += menuItem.p_itemW.normalW;
        tag++;
    }

    width += _p_endX;
    _itemScrollView.contentSize = CGSizeMake(width, _itemScrollView.frame.size.height);
}

- (void)p_adjustLineViewFrame
{
    UIButton *button = [self p_buttonWithIndex:_currentIndex];
    
    if (!button) {
        button = _buttonArray.firstObject;
    }
    
    CGFloat lineW = _lineSize.width;
    
    switch (_lineLayoutType) {
        case QYLineLayoutTypeFixed:
            break;
            
        case UPLineWidthTypeEqualText:
            lineW = button.frame.size.width;
            break;
    }
    
    CGFloat offsetX = MIN_X(button.frame) + (button.frame.size.width - lineW) / 2.0;
    CGFloat offsetY = self.frame.size.height - _lineSize.height - kSplitLineVH;
    CGFloat height = _lineSize.height;
    
    _indexLineView.frame = CGRectMake(offsetX, offsetY, lineW, height);
    _indexLineView.backgroundColor = self.selectedColor;
}

- (void)p_resetButtonColorWithTargetIndex:(NSInteger)index
{
    UIButton *button = [self p_buttonWithIndex:_currentIndex];
    [button setTitleColor:self.normalColor forState:(UIControlStateNormal)];
    button.titleLabel.font = self.normalFont;
    button.frame = [self p_normalButtonFrameWithIndex:_currentIndex];
    
    UIButton *targetButton = [self p_buttonWithIndex:index];
    [targetButton setTitleColor:self.selectedColor forState:(UIControlStateNormal)];
    targetButton.titleLabel.font = self.selectedFont;
    targetButton.frame = [self p_selectedButtonFrameWithIndex:index];
}

- (CGRect)p_normalButtonFrameWithIndex:(NSInteger)index
{
    CGFloat offsetX = [self p_buttonXWithIndex:index];
    CGFloat offsetY = 0.0;
    CGFloat width = [self p_itemWithIndex:index].p_itemW.normalW;
    CGFloat height = _itemScrollView.frame.size.height;
    return CGRectMake(offsetX, offsetY, width, height);
}

- (CGRect)p_selectedButtonFrameWithIndex:(NSInteger)index
{
    CGRect normalRect = [self p_normalButtonFrameWithIndex:index];
    QYScrollMenuItem *item = [self p_itemWithIndex:index];
    CGFloat x = normalRect.origin.x + (item.p_itemW.selectW - item.p_itemW.normalW) / 2.0;
    return CGRectMake(x, normalRect.origin.y, item.p_itemW.selectW, normalRect.size.height);
}

- (CGFloat)p_buttonXWithIndex:(NSInteger)index
{
    if (index == 0) {
        return _p_startX;
    }
    
    CGFloat x = _p_startX;
    for (NSInteger i = 0; i < index; i++) {
        
        if (i != 0) {
            x += _p_lrSpace;
        }
        
        QYScrollMenuItem *item = [self p_itemWithIndex:i];
        if (!item) {
            break;
        }
        x += item.p_itemW.normalW;
    }
    return x += _p_lrSpace;
}

- (void)p_adjustScrollViewOffset
{
    [_itemScrollView setContentOffset:CGPointMake([self p_caculteCurrentIndexNeedOffsetX], 0) animated:YES];
}

- (CGFloat)p_caculteCurrentIndexNeedOffsetX
{
    UIButton *button = [self p_buttonWithIndex:_currentIndex];
    
    if (!button) {
        return 0.0;
    }
    
    return (MAX_X(button.frame) + _p_lrSpace) < SCREEN_W ? 0.0 : (MAX_X(button.frame) - SCREEN_W + (button.tag == _itemsArray.count - 1 ? _p_endX : (_p_lrSpace + _p_endX)));
}

- (void)p_resetMenuItemW
{
    for (QYScrollMenuItem *menuItem in _itemsArray) {
        CGItemW itemW;
        itemW.normalW = [self p_widthWithFont:self.normalFont string:menuItem.title];
        itemW.selectW = [self p_widthWithFont:self.selectedFont string:menuItem.title];
        menuItem.p_itemW = itemW;
    }
}

- (void)p_resetLayoutOfStartXAndLRSpace
{
    switch (_itemLayoutType) {
        case QYMenuItemLayoutTypeeLinear: {
            _p_startX = _itemInsets.left;
            _p_lrSpace = _itemLRSapce;
            _p_endX = _itemInsets.right;
        }
            break;
            
        case QYMenuItemLayoutTypeEqualSpace: {
            CGFloat contentW = [self p_itemWidthSum] + [self p_itemReduceOneCount] * _itemLRSapce;
            CGFloat startX = (self.frame.size.width - contentW) / 2.0;
            if (startX < 0) {
                _itemLayoutType = QYMenuItemLayoutTypeeLinear;
                [self p_resetLayoutOfStartXAndLRSpace];
            } else {
                _p_startX = startX;
                _p_endX = startX;
                _p_lrSpace = _itemLRSapce;
            }
        }
            break;
            
        case QYMenuItemLayoutTypeDynamicSpace: {
            CGFloat contentW = [self p_itemWidthSum] + _itemInsets.left + _itemInsets.right;
            if (contentW > self.frame.size.width) {
                _itemLayoutType = QYMenuItemLayoutTypeeLinear;
                _itemLRSapce = 30.0;
                [self p_resetLayoutOfStartXAndLRSpace];
            } else {
                _p_startX = _itemInsets.left;
                _p_endX = _itemInsets.right;
                _p_lrSpace = (self.frame.size.width - contentW) / [self p_itemReduceOneCount];
            }
        }
            break;
    }
}

- (CGFloat)p_itemWidthSum
{
    CGFloat w = 0;
    for (QYScrollMenuItem *item in _itemsArray) {
        w += item.p_itemW.normalW;
    }
    return w;
}

- (NSInteger)p_itemReduceOneCount
{
    return _itemsArray.count == 0 ? 0 : (_itemsArray.count - 1);
}

- (UIButton *)p_buttonWithIndex:(NSInteger)index
{
    if (index < _buttonArray.count) {
        return [_buttonArray objectAtIndex:index];
    }
    return nil;
}

- (QYScrollMenuItem *)p_itemWithIndex:(NSInteger)index
{
    if (index < _itemsArray.count) {
        return [_itemsArray objectAtIndex:index];
    }
    return nil;
}


#pragma mark - help

- (CGFloat)p_widthWithFont:(UIFont *)font string:(NSString *)string
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.maximumLineHeight = font.pointSize * 1.5;
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraph};
    CGSize textSize = [string boundingRectWithSize:CGSizeMake(100000, 100000)
                                           options:(NSStringDrawingUsesLineFragmentOrigin |
                                                    NSStringDrawingTruncatesLastVisibleLine)
                                        attributes:attributes
                                           context:nil].size;
    return ceil(textSize.width);
}



#pragma mark - layoutOfUI

- (void)layoutQYScrollMenuViewOfUI
{
    [self layoutQYScrollMenuViewUIOfSelf];
    [self layoutQYScrollMenuViewUIOfeffectView];
    [self layoutQYScrollMenuViewUIOfScrollView];
    [self layoutQYScrollMenuViewUIOfMenuLineView];
    [self layoutQYScrollMenuViewUIOfBottomLineView];
}

- (void)layoutQYScrollMenuViewUIOfSelf
{
    self.backgroundColor = [UIColor colorWithHexString:@"ffffff" alpha:0.9];
    self.backgroundColor = [UIColor greenColor];
    
    _itemLayoutType = QYMenuItemLayoutTypeeLinear;
    _lineLayoutType = QYLineLayoutTypeEqualText;

    _itemInsets = UIEdgeInsetsMake(0, 20.0, 0, 20.0);
    _lineSize = CGSizeMake(26.0, 3.0);
    _itemLRSapce = 30.0;
}

- (void)layoutQYScrollMenuViewUIOfeffectView
{
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _effectView.frame = self.bounds;
    [self addSubview:_effectView];
}

- (void)layoutQYScrollMenuViewUIOfScrollView
{
    _itemScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _itemScrollView.delegate = self;
    _itemScrollView.pagingEnabled = NO;
    _itemScrollView.bounces = YES;
    _itemScrollView.backgroundColor = [UIColor clearColor];
    _itemScrollView.showsVerticalScrollIndicator = NO;
    _itemScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_itemScrollView];
}

- (void)layoutQYScrollMenuViewUIOfMenuLineView
{
    _indexLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - _lineSize.height - kSplitLineVH, self.frame.size.width, _lineSize.height)];
    _indexLineView.backgroundColor = self.selectedColor;
    [_itemScrollView addSubview:_indexLineView];
}

- (void)layoutQYScrollMenuViewUIOfBottomLineView
{
    _splitLineView = [[UIView alloc] init];
    _splitLineView.frame = CGRectMake(0.0, self.frame.size.height - kSplitLineVH, self.frame.size.width, kSplitLineVH);
    _splitLineView.backgroundColor = [UIColor grayColor];
    [self addSubview:_splitLineView];
}


#pragma mark - getter

- (NSMutableSet *)cacheSet
{
    if (nil == _cacheSet) {
        _cacheSet = [NSMutableSet setWithCapacity:kDefaultCacheCount];
    }
    return _cacheSet;
}

- (NSMutableArray <UIButton *>*)buttonArray
{
    if (nil == _buttonArray) {
        _buttonArray = [NSMutableArray arrayWithCapacity:kDefaultCacheCount];
    }
    return _buttonArray;
}

- (UIButton *)p_buttonWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIButton *button = _cacheSet.anyObject;
    
    if (button) {
        [_cacheSet removeObject:button];
    } else {
        button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button addTarget:self action:@selector(p_callBackWithEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    [button setTitle:title forState:(UIControlStateNormal)];
    [button setTitleColor:self.normalColor forState:(UIControlStateNormal)];
    button.titleLabel.font = self.normalFont;
    button.tag = tag;
    return button;
}

- (UIColor *)normalColor
{
    if (nil == _normalColor) {
        _normalColor = [UIColor blackColor];
    }
    return _normalColor;
}

- (UIColor *)selectedColor
{
    if (nil == _selectedColor) {
        _selectedColor = [UIColor orangeColor];
    }
    return _selectedColor;
}

- (UIFont *)normalFont
{
    if (nil == _normalFont) {
        _normalFont = [UIFont systemFontOfSize:14.0];
    }
    return _normalFont;
}

- (UIFont *)selectedFont
{
    if (nil == _selectedFont) {
        _selectedFont = [UIFont boldSystemFontOfSize:14.0];
    }
    return _selectedFont;
}

@end
