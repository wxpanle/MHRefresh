//
//  QYPhotoBrowser.m
//  MHRefresh
//
//  Created by panle on 2018/8/1.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYPhotoBrowser.h"
#import "QYPhotoBrowerView.h"

@interface QYPhotoBrowser () <UIScrollViewDelegate>

/** 单击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
/** 双击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleGesture;
/** image视图 */
@property (nonatomic, strong) UIImageView *imageView;
/** 预览图片view */
@property (nonatomic,strong) QYPhotoBrowerView *photoBrowserView;
/** 设备方向 */
@property (nonatomic,assign) UIDeviceOrientation orientation;

@end

@implementation QYPhotoBrowser {
    BOOL _hasShowedFistView;
    UIView *_contentView;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        
        self.userInteractionEnabled = YES;
        
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.doubleGesture];
    }
    return self;
}

//当视图移动完成后调用
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    _photoBrowserView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - getter

- (UITapGestureRecognizer *)tapGesture {
    
    if (nil == _tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        _tapGesture.numberOfTapsRequired = 1;
        _tapGesture.delaysTouchesBegan = YES;
        [_tapGesture requireGestureRecognizerToFail:self.doubleGesture];
        
        [self addGestureRecognizer:_tapGesture];
    }
    return _tapGesture;
}

- (UITapGestureRecognizer *)doubleGesture {
    
    if (nil == _doubleGesture) {
        _doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleGesture.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:_doubleGesture];
    }
    return _doubleGesture;
}


#pragma mark private methods


- (void)onDeviceOrientationChangeWithObserver {
    [self onDeviceOrientationChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)onDeviceOrientationChange {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    self.orientation = orientation;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        if (self.bounds.size.width < self.bounds.size.height) {
            //还原缩放动画
            [_photoBrowserView.scrollView setZoomScale:1.0 animated:YES];//还原
            
            [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
                self.bounds = CGRectMake(0, 0, SCREEN_H, SCREEN_W);
                
            } completion:^(BOOL finished) {
                [self setNeedsLayout];
                [self layoutIfNeeded];
            }];
        }
    } else if (orientation==UIDeviceOrientationPortrait){
        if (self.bounds.size.width > self.bounds.size.height) {
            [_photoBrowserView.scrollView setZoomScale:1.0 animated:YES];//还原
            [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                self.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
                
                self.bounds = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
                [self setNeedsLayout];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)showFirstImage {
    
    _photoBrowserView.alpha = 0;
    _contentView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        //将点击的临时imageview动画放大到和目标imageview一样大
        _photoBrowserView.alpha = 1;
        _contentView.alpha = 1;
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
    }];
    
}

- (void)hidePhotoBrowser {
    [self prepareForHide];
}

- (void)prepareForHide{
    
    _photoBrowserView.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - tap
#pragma mark 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    [self hidePhotoBrowser];
}

#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self];
    if (_photoBrowserView.scrollView.zoomScale <= 1.0) {
        CGFloat scaleX = touchPoint.x + _photoBrowserView.scrollView.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + _photoBrowserView.scrollView.contentOffset.y;//需要放大的图片的Y点
        [_photoBrowserView.scrollView zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
    } else {
        [_photoBrowserView.scrollView setZoomScale:1.0 animated:YES]; //还原
    }
}

#pragma mark public methods
- (void)show {
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor blackColor];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    _contentView.bounds = window.bounds;
    
    self.frame = _contentView.bounds;
    window.windowLevel = UIWindowLevelStatusBar+10.0f;//隐藏状态栏
    [_contentView addSubview:self];
    
    _photoBrowserView = [[QYPhotoBrowerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [_photoBrowserView setImageWithImageKey:nil placeholderImage:nil];
    
    _contentView.userInteractionEnabled = YES;
    
    _photoBrowserView.userInteractionEnabled = NO;
    
    [window addSubview:_contentView];
    
    [_contentView addSubview:_photoBrowserView];
    
    [self performSelector:@selector(onDeviceOrientationChangeWithObserver) withObject:nil afterDelay:0.25 + 0.2];
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector];
}

@end
