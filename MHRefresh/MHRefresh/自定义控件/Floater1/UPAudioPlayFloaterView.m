//
//  UPAudioPlayFloaterView.m
//  Up
//
//  Created by panle on 2018/4/26.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UPAudioPlayFloaterView.h"

static const CGFloat kFaloaterViewH = 40.0;
static const CGFloat kEdgeBW = 24.0;
static const CGFloat kButtonW = 48.0;
static const CGFloat kContainerViewLeading = 10.0;

static const CGFloat kContainerViewBottom = 80.0;

static const CGFloat kAnimationDuration = 0.25;

static const CGFloat kCornerRadius = 6.0;

@interface UPAudioPlayFloaterView () {
    CAShapeLayer *_edgeButtonShapeLayer;
}

/** 控制刷新数据即可 */
@property (nonatomic, assign, readwrite) UPAPFloaterViewState state;
/** 位置 */
@property (nonatomic, assign, readwrite) UPAPFloaterViewPosition position;

@property (nonatomic, copy) NSString *courseImage;

@property (nonatomic, strong) UIView *shadowView;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *edgeButton;
@property (nonatomic, strong) UIButton *listButton;
@property (nonatomic, strong) UIButton *playControlButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *leftLineView;
@property (nonatomic, strong) UIView *rightLineView;

@end

@implementation UPAudioPlayFloaterView

+ (instancetype)audioPlayFloaterView {
    return [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _position = UPAPFloaterViewPositionShow;
        [self layoutOfUI];
    }
    return self;
}

#pragma mark - public

- (void)up_updateDataWithState:(UPAPFloaterViewState)state imageName:(NSString *)imageName {
    [self p_updateStateWithState:state];
    [self p_updateImageName:imageName];
}

- (void)up_updateToPosition:(UPAPFloaterViewPosition)position {
    
    if (_position == position) {
        return;
    }
    
    switch (position) {

        case UPAPFloaterViewPositionShow:
            [self p_refreshPositionToShow];
            break;
        case UPAPFloaterViewPositionEdge:
            [self p_refreshPositionToEdge];
            break;
        case UPAPFloaterViewPositionHidden:
            self.hidden = YES;
            break;
    }
    _position = position;
}


#pragma mark - ===== layoutOfUI =====

- (void)layoutOfUI {
    
    [self layoutUIOfSelf];
    [self layoutUIOfShadowView];
    [self layoutUIOfContainerView];
    [self layoutUIOfEdgeButton];
    [self layoutUIOfListButton];
    [self layoutUIOfLeftLineView];
    [self layoutUIOfPlayControlButton];
    [self layoutUIOfRightLineView];
    [self layoutUIOfCloseButton];
}

- (void)layoutUIOfSelf {
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutUIOfShadowView {
//    CGFloat width = 0;
//    CGFloat height = kFaloaterViewH;
//    CGFloat offentX = kContainerViewLeading;
//    CGFloat offentY = SCREEN_H - K_BOTTOM_H(kContainerViewBottom) - height;
//
//    _shadowView = [UPFactory up_viewWithFrame:CGRectMake(offentX, offentY, width, height)];
//    _shadowView.layer.cornerRadius = kCornerRadius;
//    _shadowView.layer.shadowOffset = CGSizeMake(0.0, 3.0);
//    _shadowView.layer.shadowRadius = 3.0;
//    _shadowView.layer.shadowOpacity = 0.15;
//    _shadowView.layer.shadowColor = [UIColor colorWithHexString:@"000000" alpha:1.0].CGColor;
//    _shadowView.layer.borderColor = [UIColor colorWithHexString:@"000000" alpha:0.2].CGColor;
//    [_shadowView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(p_pan:)]];
//
//    [self addSubview:_shadowView];
}

- (void)layoutUIOfContainerView {
//    _containerView = [UPFactory up_viewWithFrame:CGRectMake(0, 0, kButtonW * 3.0 + UPDefaultLineNarrow * 2.0, kFaloaterViewH) bgColorHexString:@"ffffff" cornerRadius:kCornerRadius];
//    _containerView.layer.borderColor = [UIColor colorWithHexString:@"000000" alpha:0.2].CGColor;
//    _containerView.layer.borderWidth = 0.5;
//    [_shadowView addSubview:_containerView];
}

- (void)layoutUIOfEdgeButton {
    
//    UIImage *image = [UIImage imageNamed:@"up_audio_floater_open"];
//
//    CGFloat width = kEdgeBW;
//    CGFloat height = kFaloaterViewH;
//    CGFloat offentX = 0;
//    CGFloat offentY = SCREEN_H - K_BOTTOM_H(kContainerViewBottom) - height;
//
//    _edgeButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    _edgeButtonShapeLayer = [CAShapeLayer up_circleShapeLayerWithRect:_edgeButton.bounds type:UPShapeLayerCircleCutRight cornerRadius:kCornerRadius lineWidth:0.5 strokeColor:[UIColor colorWithHexString:@"000000" alpha:0.2] fillColor:[UIColor whiteColor]];
//    _edgeButtonShapeLayer.shadowOpacity = 0.16;
//    _edgeButtonShapeLayer.shadowOffset = CGSizeMake(0, -3.0);
//    _edgeButtonShapeLayer.shadowColor = [UIColor colorWithHexString:@"000000" alpha:0.2].CGColor;
//    _edgeButtonShapeLayer.shadowRadius = 3.0;
//    [_edgeButton.layer addSublayer:_edgeButtonShapeLayer];
//
//    [_edgeButton setImage:image.up_imageOriginalRender forState:UIControlStateNormal];
//    [_edgeButton addTarget:self action:@selector(p_open) forControlEvents:UIControlEventTouchUpInside];
//    _edgeButton.frame = CGRectMake(offentX, offentY, width, height);
//    _edgeButton.hidden = YES;
//    _edgeButton.backgroundColor = [UIColor clearColor];
//
//    [_edgeButton bringSubviewToFront:_edgeButton.imageView];
//    [self addSubview:_edgeButton];
}

- (void)layoutUIOfListButton {
    
    CGFloat width = kButtonW;
    CGFloat height = kFaloaterViewH;
    CGFloat offentX = 0;
    CGFloat offentY = 0;
    
    _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_listButton addTarget:self action:@selector(p_list) forControlEvents:UIControlEventTouchUpInside];
    _listButton.frame = CGRectMake(offentX, offentY, width, height);
    _listButton.imageEdgeInsets = UIEdgeInsetsMake(8, 12, 8, 12);
    [_containerView addSubview:_listButton];
}

- (void)layoutUIOfLeftLineView {
    
//    CGFloat width = 1.0;
//    CGFloat height = kEdgeBW;
//    CGFloat offentX = MAX_X(_listButton.frame);
//    CGFloat offentY = (kFaloaterViewH - height) / 2.0;
//
//    _leftLineView = [UPFactory up_viewWithFrame:CGRectMake(offentX, offentY, width, height) bgColorHexString:@"ebebeb"];
//    [_containerView addSubview:_leftLineView];
}

- (void)layoutUIOfPlayControlButton {
    
    UIImage *image = [UIImage imageNamed:@"up_audio_floater_play"];
    UIImage *selectImage = [UIImage imageNamed:@"up_audio_floater_pause"];
    
    CGFloat width = kButtonW;
    CGFloat height = kFaloaterViewH;
    CGFloat offentX = MAX_X(_leftLineView.frame);
    CGFloat offentY = 0;
    
    _playControlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playControlButton setImage:image forState:UIControlStateNormal];
    [_playControlButton setImage:selectImage forState:UIControlStateSelected];
    [_playControlButton addTarget:self action:@selector(p_playControl) forControlEvents:UIControlEventTouchUpInside];
    _playControlButton.frame = CGRectMake(offentX, offentY, width, height);
    [_containerView addSubview:_playControlButton];
}

- (void)layoutUIOfRightLineView {
    
    CGFloat width = 1.0;
    CGFloat height = kEdgeBW;
    CGFloat offentX = MAX_X(_playControlButton.frame);
    CGFloat offentY = (kFaloaterViewH - height) / 2.0;
    
//    _rightLineView = [UPFactory up_viewWithFrame:CGRectMake(offentX, offentY, width, height) bgColorHexString:@"ebebeb"];
//    [_containerView addSubview:_rightLineView];
}

- (void)layoutUIOfCloseButton {
    
    UIImage *image = [UIImage imageNamed:@"up_audio_floater_close"];
    
    CGFloat width = kButtonW;
    CGFloat height = kFaloaterViewH;
    CGFloat offentX = MAX_X(_rightLineView.frame);
    CGFloat offentY = 0;
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setImage:image forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(p_close) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.frame = CGRectMake(offentX, offentY, width, height);
    [_containerView addSubview:_closeButton];
}

#pragma mark - ===== event =====

- (void)p_pan:(UIPanGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint point = [gestureRecognizer translationInView:_shadowView];
            _shadowView.sm_x += point.x;
            _shadowView.sm_y += point.y;
            [gestureRecognizer setTranslation:CGPointZero inView:_shadowView];
            break;
        }
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded: {
            
            CGFloat x = (_shadowView.sm_x >= SCREEN_W / 2.0) ? (SCREEN_W - _shadowView.sm_width - kContainerViewLeading) : kContainerViewLeading;
            
            CGFloat y = 0;
            
            CGFloat minY = SCREEN_H - K_BOTTOM_H(kFaloaterViewH) - kContainerViewLeading * 2.0;
            
            if (_shadowView.sm_y < kContainerViewLeading * 3.0) {
                y = kContainerViewLeading * 3.0;
            } else if (_shadowView.sm_y > minY) {
                y = minY;
            } else {
                y = _shadowView.sm_y;
            }
            
            [UIView animateWithDuration:kAnimationDuration
                                  delay:0
                 usingSpringWithDamping:0.7
                  initialSpringVelocity:1.0
                                options:0
                             animations:^{
                                 _shadowView.frame = CGRectMake(x, y, _shadowView.sm_width, _shadowView.sm_height);
                                 _edgeButton.sm_y = y;
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
            

            break;
        }
        default:
            
            break;
    }
    
}

- (void)p_open {
    //刷新数据
    if (_delegate && [_delegate respondsToSelector:@selector(up_audioPlayFloaterViewOpenEvent:)]) {
        [_delegate up_audioPlayFloaterViewOpenEvent:self];
    }
    [self p_refreshPositionToShow];
}

- (void)p_refreshPositionToShow {
    
    self.hidden = NO;
    
    CGFloat endEdgeX = 0;
    CGFloat endContainerX = 0;
    
    if (_shadowView.sm_x >= SCREEN_W / 2.0) { //右边
        _shadowView.sm_x = SCREEN_W;
        _edgeButton.sm_x = SCREEN_W - kEdgeBW;

        endEdgeX = SCREEN_W - kEdgeBW;
        endContainerX = SCREEN_W - kContainerViewLeading - _shadowView.sm_width;
    } else {
        _shadowView.sm_x = -_containerView.sm_width;
        _edgeButton.sm_x = 0;
        
        endEdgeX = 0;
        endContainerX = kContainerViewLeading;
    }
    
    _shadowView.hidden = NO;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _edgeButton.sm_x = endEdgeX;
        _shadowView.sm_x = endContainerX;
        _edgeButton.alpha = 0.0;
    } completion:^(BOOL finished) {
        _position = UPAPFloaterViewPositionShow;
    }];
}

- (void)p_refreshPositionToEdge {
    
    self.hidden = NO;
    
    _edgeButton.hidden = NO;
    
    CGFloat endEdgeX = 0;
    CGFloat endContainerX = 0;
    
    if (_shadowView.sm_x >= SCREEN_W / 2.0) { //右边
        
        _edgeButton.sm_x = MIN_X(_shadowView.frame);
        endEdgeX = SCREEN_W - kEdgeBW;
        endContainerX = SCREEN_W;
        
//        [_edgeButtonShapeLayer up_updateShapeLayerWithRect:_edgeButton.bounds type:UPShapeLayerCircleCutLeft cornerRadius:kCornerRadius];
        
    } else {
        
//        [_edgeButtonShapeLayer up_updateShapeLayerWithRect:_edgeButton.bounds type:UPShapeLayerCircleCutRight cornerRadius:kCornerRadius];
        
        _edgeButton.sm_x = MAX_X(_shadowView.frame);
        endEdgeX = 0;
        endContainerX = -_shadowView.sm_width;
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _shadowView.sm_x = endContainerX;
        _edgeButton.sm_x = endEdgeX;
        _edgeButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        _position = UPAPFloaterViewPositionEdge;
    }];
}

- (void)p_edge {
    [self p_refreshPositionToEdge];
    if (_delegate && [_delegate respondsToSelector:@selector(up_audioPlayFloaterViewEdgeEvent:)]) {
        [_delegate up_audioPlayFloaterViewEdgeEvent:self];
    }
}

- (void)p_playControl {
    if (_delegate && [_delegate respondsToSelector:@selector(up_audioPlayFloaterViewPlayControlEvent:)]) {
        [_delegate up_audioPlayFloaterViewPlayControlEvent:self];
    }
}

- (void)p_close {
    [self up_updateToPosition:UPAPFloaterViewPositionHidden];
    if (_delegate && [_delegate respondsToSelector:@selector(up_audioPlayFloaterViewCloseEvent:)]) {
        [_delegate up_audioPlayFloaterViewCloseEvent:self];
    }
}

- (void)p_list {
    if (_delegate && [_delegate respondsToSelector:@selector(up_audioPlayFloaterViewListEvent:)]) {
        [_delegate up_audioPlayFloaterViewListEvent:self];
    }
}


#pragma mark - state

- (void)p_updateStateWithState:(UPAPFloaterViewState)state {
    
    if (_state == state) {
        return;
    }
    
    _state = state;
    switch (_position) {
        case UPAPFloaterViewPositionHidden: {
            [self p_refreshControlUIWithState:state];
        }
            break;
        case UPAPFloaterViewPositionEdge:
            [self p_refreshControlUIWithState:state];
            [self p_refreshPositionToShow];
            break;
            
        case UPAPFloaterViewPositionShow:
            [self p_refreshControlUIUseAnimationWithState:state];
            break;
    }
}

- (void)p_refreshControlUIUseAnimationWithState:(UPAPFloaterViewState)state {
    [UIView animateWithDuration:UPDefaultAnimationDuration animations:^{
        [self p_refreshControlUIWithState:state];
    }];
}

- (void)p_refreshControlUIWithState:(UPAPFloaterViewState)state {
    switch (state) {
        case UPAPFloaterViewStatePause:
            _shadowView.sm_width = kButtonW * 3.0 + UPDefaultLineNarrow * 2.0;
            _containerView.sm_width = _shadowView.sm_width;
            _rightLineView.hidden = NO;
            _closeButton.hidden = NO;
            _playControlButton.selected = NO;
            
            if (_shadowView.sm_x > SCREEN_W / 2.0 &&
                MAX_X(_shadowView.frame) > SCREEN_W - kContainerViewLeading) {
                _shadowView.sm_x -= kButtonW + UPDefaultLineNarrow;
            }
            break;
            
        case UPAPFloaterViewStatePlaying:
            
            _shadowView.sm_width = kButtonW * 2.0 + UPDefaultLineNarrow;
            _containerView.sm_width = _shadowView.sm_width;
            _rightLineView.hidden = YES;
            _closeButton.hidden = YES;
            _playControlButton.selected = YES;
            
            if (_shadowView.sm_x > SCREEN_W / 2.0 &&
                MAX_X(_shadowView.frame) + UPDefaultLineNarrow < SCREEN_W) {
                _shadowView.sm_x += kButtonW + UPDefaultLineNarrow;
            }
            
            break;
            
         case UPAPFloaterViewStateUnknow:
            
            break;
    }
}

- (void)p_updateImageName:(NSString *)imageName {
    
    if (!imageName.length) {
        return;
    }
    
    if (![_courseImage isEqualToString:imageName]) {
        
        _courseImage = imageName;
        //更新课程imageView
//        UIImage *placeImage = [UIImage placeholdWhiteImage];
//        [_listButton setImage:placeImage forState:UIControlStateNormal];
        
//        WeakSelf
//        [UIImage donwloadImageWithUrlString:imageName successBlock:^(UIImage *image) {
//            StrongSelf
//            if (!strongSelf) {
//                return;
//            }
//
//            if ([strongSelf.courseImage isEqualToString:imageName]) {
//                [strongSelf.listButton setImage:image forState:UIControlStateNormal];
//            }
//
//        } failureBlock:^(MNetworkBaseRequest * _Nullable mRequest) {
//            DLog(@"下载失败");
//        }];
    }
}


#pragma mark - hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    switch (_position) {
        case UPAPFloaterViewPositionShow:
            if (CGRectContainsPoint([_listButton convertRect:_listButton.bounds toView:self], point)) {
                return _listButton;
            }
            
            switch (_state) {
                case UPAPFloaterViewStatePlaying: {
                    
                }
                    break;
                    
                case UPAPFloaterViewStatePause: {
                    if (CGRectContainsPoint([_closeButton convertRect:_closeButton.bounds toView:self], point)) {
                        return _closeButton;
                    } else if ([NSRunLoop mainRunLoop].currentMode == UITrackingRunLoopMode) {
                        [self p_edge];
                    }

                }
                    break;
                    
                case UPAPFloaterViewStateUnknow:
                    break;
            }
            
            if (CGRectContainsPoint([_playControlButton convertRect:_playControlButton.bounds toView:self], point)) {
                return _playControlButton;
            }
            
            return nil;
            break;
            
        case UPAPFloaterViewPositionEdge:
            return CGRectContainsPoint([_edgeButton convertRect:_edgeButton.bounds toView:self], point) ? _edgeButton : nil;
            break;
            
        case UPAPFloaterViewPositionHidden:
            return nil;
            break;
    }
}

@end
