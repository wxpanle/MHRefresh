//
//  UPBaseSliderTableViewCell.m
//  Up
//
//  Created by panle on 2018/4/4.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPBaseSliderTableViewCell.h"
#import "UPBaseTableView.h"

@interface UPSliderRowAction ()

@property (nonatomic, assign) UPSliderRowActionType type;

@property (nonatomic, copy) UPDefNilBlock handleBlock;

@property (nonatomic, assign) CGFloat imageBGWidth;

@end

#pragma mark - UPSliderRowAction

@implementation UPSliderRowAction

+ (instancetype)sliderRowActionWithType:(UPSliderRowActionType)type
                            handleBlock:(UPDefNilBlock)handleBlock {
    
    return [[self alloc] initWithsliderRowActionWithType:type handleBlock:handleBlock];
}

- (instancetype)initWithsliderRowActionWithType:(UPSliderRowActionType)type handleBlock:(UPDefNilBlock)handleBlock {
    
    if (self = [super init]) {
        [self layoutUI];
        _type = type;
        _handleBlock = handleBlock;
    }
    return self;
}

- (void)layoutUI {
    
    _onlyImageLRSpace = UPDefaultTpBmSpace;
    _imageBGWidth = 48.0;
    switch (_type) {
        case UPSRATypeImage:
            _contentMaxWidth = _onlyImageLRSpace  + _imageBGWidth;
            break;
            
        default:
            _contentMaxWidth = 80.0;
            break;
    }
    
}

#pragma mark - getter

- (UIFont *)textFont {
    
    if (nil == _textFont) {
        _textFont = [UIFont fontPingFang:QYPingFangSCRegular size:[UIFont systemFontSize]];
    }
    return _textFont;
}

- (UIColor *)textColor {
    
    if (nil == _textColor) {
        _textColor = [UIColor whiteColor];
    }
    return _textColor;
}

- (UIColor *)bgColor {
    
    if (nil == _bgColor) {
        _bgColor = [UIColor grayColor];
    }
    return _bgColor;
}

- (UIColor *)imageBgColor {
    
    if (nil == _imageBgColor) {
        _imageBgColor = [UIColor whiteColor];
    }
    return _imageBgColor;
}

- (CGFloat)contentMaxWidth {
    
    switch (_type) {
        case UPSRATypeImage:
            return _imageBGWidth + _onlyImageLRSpace;
            break;
            
        default:
            return _contentMaxWidth;
            break;
    }
}

- (void)dealloc {
    
    _handleBlock = nil;
    DLOG_DEALLOC
}

@end

#pragma mark - UPSliderView

@interface UPSliderView : UIView

@property (nonatomic, strong) UPSliderRowAction *rowAction;

@property (nonatomic, strong) CAShapeLayer *imageBgLayer;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) CGFloat originWidth;

- (instancetype)initWithFrame:(CGRect)frame sliderRowAction:(UPSliderRowAction *)rowAction;

@end

@implementation UPSliderView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame sliderRowAction:(UPSliderRowAction *)rowAction {
    
    if (self = [super initWithFrame:frame]) {
        _rowAction = rowAction;
        [self layoutUI];
    }
    return self;
}


#pragma mark - layoutUI

- (void)layoutUI {
    [self layoutUISelf];
    
    switch (_rowAction.type) {
        case UPSRATypeMix:
        case UPSRATypeText:
            [self layoutUIOfTitleLabel];
            break;
            
        case UPSRATypeImage:
            [self layoutUIOfImageBgLayer];
            [self layoutUIOfImageView];
            break;
    }
    
    [self layoutUIOfTapGestureRecognizer];
}

- (void)layoutUISelf {
    if (_rowAction) {
        self.backgroundColor = _rowAction.bgColor;
    }
}

- (void)layoutUIOfImageBgLayer {
    
    CGFloat diameter = _rowAction.imageBGWidth;
    CGFloat offentX = (self.sm_width - diameter) / 2.0;
    CGFloat offentY = (self.sm_height - diameter) / 2.0;

    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(offentX, offentY, diameter, diameter) cornerRadius:diameter / 2.0];
    bezierPath.lineWidth = 0.1;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    
    _imageBgLayer = [CAShapeLayer layer];
    _imageBgLayer.path = bezierPath.CGPath;
    _imageBgLayer.fillColor = _rowAction.imageBgColor.CGColor;
    _imageBgLayer.strokeColor = _rowAction.imageBgColor.CGColor;
    
    [self.layer addSublayer:_imageBgLayer];
}

- (void)layoutUIOfImageView {
    
    UIImage *image = _rowAction.image;
    
    if (!image && _rowAction.imageName) {
        image = [UIImage imageNamed:_rowAction.imageName];
        _rowAction.image = image;
    }
    
    if (!image) {
        return;
    }
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat offentX = (self.sm_width - width) / 2.0;
    CGFloat offentY = (self.sm_height - height) / 2.0;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offentX, offentY, width, height)];
    [self addSubview:_imageView];
}

- (void)layoutUIOfTitleLabel {
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, 0, _rowAction.contentMaxWidth, self.sm_height);
    _titleLabel.numberOfLines = 1;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _titleLabel.text = _rowAction.text;
    _titleLabel.textColor = _rowAction.textColor;
    _titleLabel.font = _rowAction.textFont;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)layoutUIOfTapGestureRecognizer {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapGestureRecognizer)]];
}


#pragma mark - event
- (void)p_tapGestureRecognizer {
    CallBackBlock(_rowAction.handleBlock);
}


#pragma mark - dealloc

- (void)dealloc {
    DLOG_DEALLOC
}

@end


#pragma mark - UPBaseSliderTableViewCell

typedef NS_ENUM(NSInteger, UPPGDirection) {
    UPPGDirectionNone = 0,
    UPPGDirectionHorizontal,
    UPPGDirectionVertical
};

typedef NS_ENUM(NSInteger, UPPGHorizontalDirection) {
    UPPGHDirectionNone = 0,
    UPPGHDirectionLeft,
    UPPGHDirectionRight
};

static const CGFloat kSliderActionSpeed = 600;

@interface UPBaseSliderTableViewCell () <UIGestureRecognizerDelegate>

///------------------------------
/// @name 内容部分
///------------------------------
@property (nonatomic, strong, readwrite) UIView *upContentView;

///------------------------------
/// @name sliserRowAction
///------------------------------

@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) NSMutableArray *sliderActionView;

@property (nonatomic, strong) NSArray *sliderViewActionArray;

///------------------------------
/// @name 手势
///------------------------------

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

/** 手势回合中 */
@property (nonatomic, assign) BOOL gestureInProgress;

/** 回合中禁止右滑 */
@property (nonatomic, assign) BOOL gestureInProressForbidRight;

/** 手势中是否已经回调数据 */
@property (nonatomic, assign) BOOL gestureIsCallBack;

/** 当前回合内action数量 */
@property (nonatomic, assign) NSInteger gestureCount;

/** 手势是否可用 */
@property (nonatomic, assign) BOOL gestureEnable;

@property (nonatomic, assign) CGFloat sliderViewOriginWidth;

@end

@implementation UPBaseSliderTableViewCell

#pragma mark - init

- (void)awakeFromNib {
    [super awakeFromNib];
    [self super_layoutOfUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self super_layoutOfUI];
    }
    return self;
}


#pragma mark - layoutUI

- (void)super_layoutOfUI {
    
    [self super_layoutUIOfSelf];
    [self super_layoutUIOfUpContentView];
//    [self super_layoutUIOfGestureRecognizer];
    
    
    [self super_layoutUIOfSwipeGestureRecognizer];
    
}

- (void)super_layoutUIOfSelf {
    
    _allowSlider = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)super_layoutUIOfUpContentView {
    
    _upContentView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    _upContentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_upContentView];
}

- (void)super_layoutUIOfGestureRecognizer {
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_panGestureRecognizer:)];
    _panGestureRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:_panGestureRecognizer];
}

- (void)super_layoutUIOfSwipeGestureRecognizer {
    _swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(p_swipe:)];
    _swipeGestureRecognizer.delegate = self;
    _swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.contentView addGestureRecognizer:_swipeGestureRecognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _upContentView.frame = self.contentView.bounds;
}

#pragma mark - ======== getter ========

#pragma mark - ======== setter ========

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    
    if (editing == NO) {
        [self endSliderAnimation];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing == NO) {
        [self endSliderAnimation];
    }
}

- (void)setUpContentViewBgColor:(UIColor *)upContentViewBgColor {
    
    self.contentView.backgroundColor = upContentViewBgColor;
    self.upContentView.backgroundColor = upContentViewBgColor;
}

#pragma mark - ======== event ========

- (void)p_swipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    
    if (!_allowSlider) {
        return;
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            DLog(@"滑动开始");
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
//            CGPoint point = [gestureRecognizer locationInView:self];
            DLog(@"滑动中");
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            DLog(@"滑动结束");
            NSArray <UPSliderRowAction *> *rowActionArray = [_sliderDelegate up_sliderRowActionArrayWithTableViewCell:self indexPath:self.up_indexPath];
            
            _gestureCount = rowActionArray.count;
            
            if (!rowActionArray.count) {
                _gestureEnable = NO;
            } else {
                
                //添加滑动view
                UIView *view = [self p_createSliderViewWithHeadViewActionArray:rowActionArray];
                view.frame = CGRectMake(MAX_X(_upContentView.frame), 0, _sliderViewOriginWidth, self.upContentView.sm_height);
                [self.contentView addSubview:view];
                _sliderView = view;
            }
            
            [UIView animateWithDuration:UPDefaultAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                _upContentView.frame = CGRectMake(-_sliderViewOriginWidth, _upContentView.sm_y, _upContentView.sm_width, _upContentView.sm_height);
                _sliderView.frame = CGRectMake(MAX_X(_upContentView.frame), 0, CGFloat_fab(_upContentView.sm_x), _upContentView.sm_height);
                CGFloat offsetX = 0;
                for (UPSliderView *sliderView in _sliderActionView) {
                    sliderView.frame = CGRectMake(offsetX, 0, sliderView.originWidth, _upContentView.sm_height);
                    offsetX += sliderView.originWidth;
                }
            } completion:^(BOOL finished) {
//                CallBackBlock(handleBlock);
            }];
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            DLog(@"滑动失败");
            break;
            
        default:
            break;
    }
}

- (void)p_panGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    
    UIView *view = gestureRecognizer.view;
    static UPPGHorizontalDirection direction = UPPGHDirectionNone;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            
            if (!_allowSlider) {
                return;
            }
            
            if (_gestureInProgress) {
                _gestureInProressForbidRight = YES;
                return;
            }
            
            //获取手势原点数据
            CGPoint point = [gestureRecognizer translationInView:view];
            UPPGHorizontalDirection tempDirection = [self p_gainHorizontalDirectionWithPoint:point direction:direction];
        
            //初始化数据
            direction = UPPGHDirectionNone;
            _gestureInProgress = YES;
            _gestureEnable = YES;
            _gestureIsCallBack = NO;
            _gestureInProressForbidRight = NO;
            
            //手势开始清空sliderView
            if (_sliderView) {
                [_sliderView removeFromSuperview];
                _sliderView = nil;
            }
            
            if (direction == UPPGHDirectionNone &&
                tempDirection == UPPGHDirectionLeft) {
                
                if (!_gestureIsCallBack) {
                    _gestureIsCallBack = YES;
                    
                    if (_sliderDelegate && [_sliderDelegate respondsToSelector:@selector(up_sliderRowActionArrayWithTableViewCell:indexPath:)]) {
                        NSArray <UPSliderRowAction *> *rowActionArray = [_sliderDelegate up_sliderRowActionArrayWithTableViewCell:self indexPath:self.up_indexPath];
                        
                        _gestureCount = rowActionArray.count;
                        
                        if (!rowActionArray.count) {
                            _gestureEnable = NO;
                        } else {
                        
                            //添加滑动view
                            UIView *view = [self p_createSliderViewWithHeadViewActionArray:rowActionArray];
                            view.frame = CGRectMake(MAX_X(_upContentView.frame), 0, _sliderViewOriginWidth, self.upContentView.sm_height);
                            [self.contentView addSubview:view];
                            _sliderView = view;
                        }
                        
                    } else {
                        _gestureEnable = NO;
                    }
                }
                
            } else {
                
                _gestureEnable = NO;

                [self p_sliderAnimationWithResilience:YES conpleteBlock:^{
                    [_sliderView removeFromSuperview];
                    _sliderView = nil;
                    _gestureInProgress = NO;
                    _sliderActionView = nil;
                }];
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            
            if (!_allowSlider ||
                !_gestureEnable ||
                !_sliderView ||
                _gestureInProressForbidRight) {
                break;
            }
            
            CGPoint point = [gestureRecognizer translationInView:view];
            _upContentView.frame = CGRectMake(_upContentView.sm_x + point.x, _upContentView.sm_y, _upContentView.sm_width, _upContentView.sm_height);
            _sliderView.frame = CGRectMake(MAX_X(_upContentView.frame), 0, CGFloat_fab(_upContentView.sm_x), _upContentView.sm_height);

            CGFloat sliderX = CGFloat_fab(_upContentView.sm_x);
            CGFloat averageFrame = sliderX > _sliderViewOriginWidth ? sliderX : _sliderViewOriginWidth;
            
            CGFloat originX = 0;
            
            for (UPSliderView *sliderView in _sliderActionView) {
                CGFloat width = sliderView.originWidth * averageFrame / _sliderViewOriginWidth;
                CGFloat currentOriginX = sliderView.originWidth * sliderX / _sliderViewOriginWidth;
                sliderView.frame = CGRectMake(originX, 0, width, sliderView.sm_height);
                originX += currentOriginX;
            }
            
            if (_upContentView.sm_x > 0) {
                
                if (CGFloat_fab(_upContentView.sm_x) > 15) {
                    [self p_sliderAnimationWithResilience:NO conpleteBlock:nil];
                }
                
            } else {
                
                if (CGFloat_fab(_upContentView.sm_x) > _sliderViewOriginWidth) {
                    [self p_sliderAnimationWithResilience:NO conpleteBlock:nil];
                }
            }
            
            [gestureRecognizer setTranslation:CGPointZero inView:view];
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            
            if (!_allowSlider ||
                !_gestureEnable ||
                _gestureInProressForbidRight) {
                return;
            }

            CGFloat appearWidth = CGFloat_fab(_upContentView.sm_x);
            
            if (appearWidth >= _sliderViewOriginWidth) {
                break;
            }
            
            if (appearWidth >= _sliderViewOriginWidth / 3.0) {
                [self p_sliderAnimationWithResilience:NO conpleteBlock:nil];
                break;
            }
            
            CGPoint velocity = [gestureRecognizer velocityInView:view];
            
            if (CGFloat_fab(velocity.x) >= kSliderActionSpeed)  {
                [self p_sliderAnimationWithResilience:NO conpleteBlock:nil];
                break;
            }
            
            //复位
            [self p_sliderAnimationWithResilience:YES conpleteBlock:^{
                [_sliderView removeFromSuperview];
                _sliderView = nil;
                _gestureInProgress = NO;
                _sliderActionView = nil;
            }];
            
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            _gestureInProgress = NO;
            
            if (!_allowSlider) {
                return;
            }
            if (_sliderView) {
                [self p_sliderAnimationWithResilience:YES conpleteBlock:nil];
            }

            break;
            
        default:
            break;
    }

}

#pragma mark - ======== delegate ========

#pragma mark - ======== UIGestureRecognizerDelegate ========

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (_gestureInProgress) {
        
        if (self.isSliding && [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self endSliderAnimation];
        }
        
        return NO;
    }
    
//    if (gestureRecognizer != _panGestureRecognizer || gestureRecognizer != _swipeGestureRecognizer) {
//        return NO;
//    }
    
//    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        return NO;
//    }
    
    if (_allowSlider == NO && _sliderDelegate && [_sliderDelegate respondsToSelector:@selector(up_isAllowSliderTableViewCell:indexPath:)]) {
        _allowSlider = [_sliderDelegate up_isAllowSliderTableViewCell:self indexPath:self.up_indexPath];
    }
    
    BOOL gestureRecognizerConflict = NO;
    
//    UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
//    UPPGDirection direction = [self p_gainDirectionWithPoint:[panGestureRecognizer translationInView:panGestureRecognizer.view]];
//    gestureRecognizerConflict = direction == UPPGDirectionHorizontal ? YES : NO;
    
//    return _allowSlider == YES && gestureRecognizerConflict == YES;
    
    return YES;
}

#pragma mark - ======== private ========

- (UPPGDirection)p_gainDirectionWithPoint:(CGPoint)point {
    
    if (point.x != 0.0) {
        
        if (point.y == 0.0) {
            return UPPGDirectionHorizontal;
        } else if (CGFloat_fab(point.x) / CGFloat_fab(point.y) >= 1.0) {
            return UPPGDirectionHorizontal;
        } else {
            return UPPGDirectionVertical;
        }
    } else if (point.y != 0.0) {
        if (point.x == 0.0) {
            return UPPGDirectionVertical;
        } else if (CGFloat_fab(point.y) / CGFloat_fab(point.x) > 1.0) {
            return UPPGDirectionVertical;
        } else {
            return UPPGDirectionHorizontal;
        }
    }
    
    return UPPGDirectionNone;
}

- (UPPGHorizontalDirection)p_gainHorizontalDirectionWithPoint:(CGPoint)point direction:(UPPGHorizontalDirection)direction {
    
    if (direction != UPPGHDirectionNone ||
        point.x == 0) {
        return direction;
    }
    
    return point.x > 0 ? UPPGHDirectionRight : UPPGHDirectionLeft;
}

- (UIView *)p_createSliderViewWithHeadViewActionArray:(NSArray <UPSliderRowAction *> *)array {
    
    CGFloat width = 0;
    
    UIView *view = [[UIView alloc] init];
    
    _sliderActionView = [NSMutableArray array];
    
    UPSliderRowAction *rowAction = array.firstObject;
    
    //左右两边附加view width
    CGFloat extraWidth = 0;
    
    if (rowAction.type == UPSRATypeImage) {
        extraWidth = rowAction.onlyImageLRSpace / 2.0;
    }
    
    CGFloat offsetX = 0;
    
    //最左边的view
    UPSliderView *leftSliderView = [[UPSliderView alloc] initWithFrame:CGRectMake(offsetX, 0, extraWidth, self.upContentView.sm_height) sliderRowAction:nil];
    leftSliderView.backgroundColor = rowAction.bgColor;
    leftSliderView.originWidth = extraWidth;
    [_sliderActionView addObject:leftSliderView];
    [view addSubview:leftSliderView];
    
    offsetX += extraWidth;
    width += extraWidth;
    
    //中间
    for (UPSliderRowAction *action in array) {
        
        CGFloat maxWidth = action.contentMaxWidth;
        
        CGRect frame = CGRectMake(offsetX, 0, maxWidth, self.upContentView.sm_height);
        UPSliderView *sliderView = [[UPSliderView alloc] initWithFrame:frame sliderRowAction:action];
        sliderView.originWidth = maxWidth;
        
        [_sliderActionView addObject:sliderView];
        [view addSubview:sliderView];
        
        offsetX += maxWidth;
        width += maxWidth;
    }
    
    rowAction = array.lastObject;
    
    //最左边的view
    UPSliderView *rightSliderView = [[UPSliderView alloc] initWithFrame:CGRectMake(offsetX, 0, extraWidth, self.upContentView.sm_height) sliderRowAction:nil];
    rightSliderView.backgroundColor = rowAction.bgColor;
    rightSliderView.originWidth = extraWidth;
    [_sliderActionView addObject:rightSliderView];
    [view addSubview:rightSliderView];
    
    width += extraWidth;
    
    _sliderViewOriginWidth = width;
    
    return view;
}

- (void)endSliderAnimation {
    
    if (!_sliderView && _upContentView.sm_x == 0) {
        return;
    }
    
    [self p_sliderAnimationWithResilience:YES conpleteBlock:^{
        [_sliderView removeFromSuperview];
        _sliderView = nil;
        _sliderActionView = nil;
        _gestureInProgress = NO;
    }];
}

- (void)p_sliderAnimationWithResilience:(BOOL)isResilience conpleteBlock:(UPDefNilBlock)handleBlock {
    
    [UIView animateWithDuration:UPDefaultAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        _sliderView.frame = CGRectMake(MAX_X(_upContentView.frame), 0, CGFloat_fab(_upContentView.sm_x), _upContentView.sm_height);
        _upContentView.frame = CGRectMake(isResilience ? 0 : -_sliderViewOriginWidth, _upContentView.sm_y, _upContentView.sm_width, _upContentView.sm_height);
        CGFloat offsetX = 0;
        for (UPSliderView *sliderView in _sliderActionView) {
            sliderView.frame = CGRectMake(offsetX, 0, sliderView.originWidth, _upContentView.sm_height);
            offsetX += sliderView.originWidth;
        }
    } completion:^(BOOL finished) {
        CallBackBlock(handleBlock);
    }];
}

#pragma mark - ===== getter =====

- (BOOL)isSliding {
    return (!_sliderView && _upContentView.sm_x == 0) ? NO : YES;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//
//    if ([self p_isSliding]) {
//        [self p_endSliderAnimation];
//    }
//    return [self p_isSliding] == YES ? nil : [super hitTest:point withEvent:event];
//}

- (BOOL)p_isSliding {
    
    BOOL result = NO;
//    for (UITableViewCell *cell in [self.up_tableView visibleCells]) {
//
//        if (result == NO && [cell respondsToSelector:@selector(isSliding)]) {
//            BOOL hit = [cell performSelector:@selector(isSliding)];
//            if (hit == YES) {
//                result = YES;
//                break;
//            }
//        }
//    }
    return result;
}

- (void)p_endSliderAnimation {
    for (UITableViewCell *cell in [self.up_tableView visibleCells]) {
        if ([cell respondsToSelector:@selector(endSliderAnimation)]) {
            [cell performSelector:@selector(endSliderAnimation)];
        }
    }
}

#pragma mark - ======== dealloc ========

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
