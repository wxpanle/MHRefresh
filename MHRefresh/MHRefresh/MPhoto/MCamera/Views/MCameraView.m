//
//  MCameraView.m
//  MHRefresh
//
//  Created by developer on 2017/9/6.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MCameraView.h"

static const CGFloat kFlashButtonWidth = 44.0;
static const CGFloat kFlashSetButtonWidth = 60.0;
static const CGFloat kTopButtonHeight = 44.0;
static const CGFloat kCancelButtonLeading = 20.0;
static const CGFloat kTakePictureOutButtonWidth = 66.0;
static const CGFloat kTakePictureOnButtonWidth = 50.0;
static const CGFloat kTakePictureOutButtonBottom = 15.0;
static const CGFloat kTakePictureOutButtonTop = 20.0;

@interface MCameraView()

@property (nonatomic, strong) UIView *imagingRegionView;

@property (nonatomic, strong) UIButton *flashButton;

@property (nonatomic, strong) UIButton *flashOnButton;

@property (nonatomic, strong) UIButton *flashOffButton;

@property (nonatomic, strong) UIButton *flashAutoButton;

@property (nonatomic, strong) UIButton *preOrPostButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *takePictureOutButton;

@property (nonatomic, strong) UIButton *takePictureOnButton;

@property (nonatomic, assign) MCameraFlashMode flashMode;

@property (nonatomic, assign) MCameraPosition cameraPosition;

@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;

@property (nonatomic, strong) CALayer *videoLayer;

@end

@implementation MCameraView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUIOfSelf];
        [self layoutUIOfFlashButton];
        [self layoutUIOfFlashOnButton];
        [self layoutUIOfFlashOffButton];
        [self layoutUIOfFlashAutoButton];
        [self layoutUIOfPreOrPostButton];
        [self layoutUIOfImagingRegionView];
        [self layoutUIOfTakePictureOutButton];
        [self layoutUIOfTakePictureOnButton];
        [self layoutUIOfCancelButton];
        [self updateUIOfFlashSetButton];
    }
    return self;
}

#pragma mark - operation
- (void)updateViewTransformWithDeviewOrientation:(UIDeviceOrientation)orientation {
    [self flipDirectionWithDeviceOrientation:orientation];
}

- (void)addVideoPreviewLayer:(CALayer *)layer {
    if (nil == layer) {
        return;
    }
    
    if (self.videoLayer) {
        [self.videoLayer removeFromSuperlayer];
    }
    
    self.videoLayer = layer;
    layer.frame = self.imagingRegionView.bounds;
    [self.imagingRegionView.layer addSublayer:self.videoLayer];
}

#pragma mark - layout
- (void)layoutUIOfSelf {
    self.deviceOrientation = UIDeviceOrientationPortrait;
    self.flashMode = MCameraFlashModeAuto;
    self.cameraPosition = MCameraPositionBack;
    self.backgroundColor = [UIColor blackColor];
}

- (void)layoutUIOfFlashButton {
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flashButton setImage:[[UIImage imageNamed:@"camear_auto"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.flashButton addTarget:self action:@selector(switchFalshMode) forControlEvents:UIControlEventTouchUpInside];
    self.flashButton.frame = CGRectMake(0, 0, kFlashButtonWidth, kFlashButtonWidth);
    [self addSubview:self.flashButton];
}

- (void)layoutUIOfFlashOnButton {
    
    CGFloat offentX = self.sm_width / 2.0 - kFlashSetButtonWidth / 2.0;
    self.flashOnButton = [self createFlashButtonWithSelector:@selector(switchFlashModeForOn) flashMode:MCameraFlashModeOn];
    self.flashOnButton.frame = CGRectMake(offentX, 0, kFlashSetButtonWidth, kTopButtonHeight);
    [self addSubview:self.flashOnButton];
}

- (void)layoutUIOfFlashOffButton {

    CGFloat offentX = self.sm_width / 2.0 + kFlashSetButtonWidth / 2.0;
    self.flashOffButton = [self createFlashButtonWithSelector:@selector(switchFlashModeForOff) flashMode:MCameraFlashModeOff];
    self.flashOffButton.frame = CGRectMake(offentX, 0, kFlashSetButtonWidth, kTopButtonHeight);
    [self addSubview:self.flashOffButton];
}

- (void)layoutUIOfFlashAutoButton {
    
    CGFloat offentX = self.sm_width / 2.0 - kFlashSetButtonWidth * 1.5;
    self.flashAutoButton = [self createFlashButtonWithSelector:@selector(switchFlashModeForAuto) flashMode:MCameraFlashModeAuto];
    self.flashAutoButton.frame = CGRectMake(offentX, 0.0, kFlashSetButtonWidth, kTopButtonHeight);
    [self addSubview:self.flashAutoButton];
}

- (void)layoutUIOfPreOrPostButton {
    self.preOrPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.preOrPostButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [self.preOrPostButton addTarget:self action:@selector(switchPreOrPost) forControlEvents:UIControlEventTouchUpInside];
    self.preOrPostButton.frame = CGRectMake(self.sm_width - kTopButtonHeight, 0, kTopButtonHeight, kTopButtonHeight);
    [self addSubview:self.preOrPostButton];
}

- (void)layoutUIOfImagingRegionView {
    CGFloat height = self.sm_height - kTopButtonHeight - kTakePictureOnButtonWidth - kTakePictureOutButtonBottom - kTakePictureOutButtonTop;
    
    self.imagingRegionView = [[UIView alloc] initWithFrame:CGRectMake(0, kTopButtonHeight, self.sm_width, height)];
    self.imagingRegionView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.imagingRegionView];
}

- (void)layoutUIOfTakePictureOutButton {
    
    CGFloat offentX = self.sm_width / 2.0 - kTakePictureOutButtonWidth / 2.0;
    CGFloat offentY = self.sm_height - kTakePictureOutButtonBottom - kTakePictureOutButtonWidth;
    
    self.takePictureOutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.takePictureOutButton.frame = CGRectMake(offentX, offentY, kTakePictureOutButtonWidth, kTakePictureOutButtonWidth);
    [self.takePictureOutButton setImage:[[UIImage imageNamed:@"camera_out"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.takePictureOutButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.takePictureOutButton];
}

- (void)layoutUIOfTakePictureOnButton {
    CGFloat offentX = self.sm_width / 2.0 - kTakePictureOnButtonWidth / 2.0;
    CGFloat offentY = self.sm_height - kTakePictureOutButtonBottom - kTakePictureOutButtonWidth / 2.0 - kTakePictureOnButtonWidth / 2.0;
    
    self.takePictureOnButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.takePictureOnButton.frame = CGRectMake(offentX, offentY, kTakePictureOnButtonWidth, kTakePictureOnButtonWidth);
    [self.takePictureOnButton setImage:[[UIImage imageNamed:@"camera_in"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.takePictureOnButton addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.takePictureOnButton];
}

- (void)layoutUIOfCancelButton {
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:19.0];
    self.cancelButton.frame = CGRectMake(kCancelButtonLeading, self.takePictureOnButton.sm_centerY - 10.0, 40.0, 20.0);
    [self.cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
}

#pragma mark - event
- (void)switchFalshMode {
    
    self.flashButton.selected = !self.flashButton.isSelected;
    
    [self updateUIOfFlashSetButton];
}

- (void)switchFlashModeForAuto {
    self.flashMode = MCameraFlashModeAuto;
    [self flashModeChange];
}

- (void)switchFlashModeForOn {
    self.flashMode = MCameraFlashModeOn;
    [self flashModeChange];
}

- (void)switchFlashModeForOff {
    self.flashMode = MCameraFlashModeOff;
    [self flashModeChange];
}

- (void)switchPreOrPost {
    
    [UIView transitionWithView:self.imagingRegionView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.cameraPosition = self.cameraPosition == MCameraPositionBack ? MCameraPositionFront : MCameraPositionBack;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(cameraViewSwitchPreOrPostPosition:)]) {
            [self.delegate cameraViewSwitchPreOrPostPosition:self.cameraPosition];
        }
    } completion:^(BOOL finished) {
        
    }];

}

- (void)takePicture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraViewTakePicture)]) {
        [self.delegate cameraViewTakePicture];
    }
}

- (void)cancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraViewCancel)]) {
        [self.delegate cameraViewCancel];
    }
}


#pragma mark - help
- (void)flashModeChange {
    
    self.flashButton.selected = NO;
    [self updateUIOfFlashSetButton];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraViewSwicthFlashMode:)]) {
        [self.delegate cameraViewSwicthFlashMode:self.flashMode];
    }
}

- (void)updateUIOfFlashSetButton {
    
    self.flashAutoButton.selected = self.flashMode == MCameraFlashModeAuto ? YES : NO;
    self.flashOnButton.selected = self.flashMode == MCameraFlashModeOn ? YES : NO;
    self.flashOffButton.selected = self.flashMode == MCameraFlashModeOff ? YES : NO;
    
    self.flashAutoButton.hidden = !self.flashButton.isSelected;
    self.flashOnButton.hidden = !self.flashButton.isSelected;
    self.flashOffButton.hidden = !self.flashButton.isSelected;
}

#pragma mark - deviceOpeartion
- (void)flipDirectionWithDeviceOrientation:(UIDeviceOrientation)orientation {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation) {
        case UIDeviceOrientationPortrait: {
            if (self.deviceOrientation != UIDeviceOrientationPortrait) {
                self.deviceOrientation = UIDeviceOrientationPortrait;
                [self relevanceButtonTransForm:transform];
            }
            
            break;
        }
            
        case UIDeviceOrientationLandscapeLeft: {
            if (self.deviceOrientation != UIDeviceOrientationLandscapeRight) {
                self.deviceOrientation = UIDeviceOrientationLandscapeRight;
                transform = CGAffineTransformMakeRotation(90 / 180.0 * M_PI);
                [self relevanceButtonTransForm:transform];
            }
            break;
        }
            
        case UIDeviceOrientationLandscapeRight: {
            if (self.deviceOrientation != UIDeviceOrientationLandscapeLeft) {
                self.deviceOrientation = UIDeviceOrientationLandscapeLeft;
                transform = CGAffineTransformMakeRotation(-90 / 180.0 * M_PI);
                [self relevanceButtonTransForm:transform];
            }
            break;
        }
            
        case UIDeviceOrientationPortraitUpsideDown: {
            if (self.deviceOrientation != UIDeviceOrientationPortraitUpsideDown) {
                self.deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
                transform = CGAffineTransformMakeRotation(180.0 / 180.0 * M_PI);
                [self relevanceButtonTransForm:transform];
            }
            break;
        }
            
        default:
            break;
    }
}

- (void)relevanceButtonTransForm:(CGAffineTransform)transform {
    [UIView animateWithDuration:0.25 animations:^{
        self.cancelButton.transform = transform;
        self.preOrPostButton.transform = transform;
        self.flashButton.transform = transform;
        self.flashOnButton.transform = transform;
        self.flashAutoButton.transform = transform;
        self.flashOffButton.transform = transform;
    }];
}

#pragma mark - setter
- (void)setCameraPosition:(MCameraPosition)cameraPosition {

    _cameraPosition = cameraPosition;
    
    switch (cameraPosition) {
        case MCameraPositionFront: {
            self.flashButton.hidden = YES;
            self.flashButton.selected = NO;
            break;
        }
            
        case MCameraPositionBack: {
            self.flashButton.hidden = NO;
            break;
        }
    }
    
    [self updateUIOfFlashSetButton];
}

- (void)setFlashMode:(MCameraFlashMode)flashMode {
    _flashMode = flashMode;
    
    switch (flashMode) {
        case MCameraFlashModeOn:
            [self.flashButton setImage:[UIImage imageNamed:@"flash_on"] forState:UIControlStateNormal];
            break;
            
        case MCameraFlashModeAuto:
            [self.flashButton setImage:[UIImage imageNamed:@"camear_auto"] forState:UIControlStateNormal];
            break;
            
        case MCameraFlashModeOff:
            [self.flashButton setImage:[UIImage imageNamed:@"flash_off"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

#pragma mark - help create button
- (UIButton *)createFlashButtonWithSelector:(SEL)action flashMode:(MCameraFlashMode)mode {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *normalTextString = nil;
    switch (mode) {
        case MCameraFlashModeAuto:
            normalTextString = @"自动";
            break;
            
        case MCameraFlashModeOn:
            normalTextString = @"打开";
            break;
            
        case MCameraFlashModeOff:
            normalTextString = @"关闭";
            break;
        default:
            break;
    }
    [button setTitle:normalTextString forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:236 / 255.0 green:129 / 255.0 blue:29 / 255.0 alpha:1.0] forState:UIControlStateSelected];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

@end
