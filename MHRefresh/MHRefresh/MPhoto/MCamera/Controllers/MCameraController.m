//
//  MCameraController.m
//  MHRefresh
//
//  Created by developer on 2017/9/6.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MCameraController.h"
#import "MCameraView.h"
#import "MDeviceOrientationModel.h"
#import "MCameraPhotoModel.h"

@interface MCameraController () <MCameraViewDelegate>

@property (nonatomic, strong) MCameraView *cameraView;

@property (nonatomic, strong) MDeviceOrientationModel *deviceOrientaionModel;

@property (nonatomic, strong) MCameraPhotoModel *photoModel;

@end

@implementation MCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUIOfSelf];
    [self layoutUIOfCameraView];
    [self layoutOfDeviceOrientationModel];
    [self layoutOfPhotoModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - status
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)layoutUIOfSelf {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)layoutUIOfCameraView {
    self.cameraView = [[MCameraView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.cameraView.delegate = self;
    [self.view addSubview:self.cameraView];
}

- (void)layoutOfDeviceOrientationModel {
    MemoryWeakSelf
    [self.deviceOrientaionModel setDeviceOrientationCallBackBlock:^(UIDeviceOrientation deviceOrientation) {
        [weakSelf.cameraView updateViewTransformWithDeviewOrientation:deviceOrientation];
        [weakSelf.photoModel updateCaptureVideoOrientationWithdeviceOrientation:deviceOrientation];
    }];
}

- (void)layoutOfPhotoModel {
    MemoryWeakSelf
    [self.photoModel setCameraCapturePictureCallBackBlock:^(UIImage *image) {
        [weakSelf capturePictureComplete:image];
    }];
    
    [self.photoModel setCameraPhotoAddVideoLayerCallBackBlock:^(CALayer *videoLayer) {
        [weakSelf.cameraView addVideoPreviewLayer:videoLayer];
    }];
    
    [self.photoModel setCameraPhotoNotAuthorizedCallBackBlock:^{
        [weakSelf cameraViewCancel];
    }];
    
    [self.photoModel startConfigurationCamera];
}

#pragma mark - callBack
- (void)capturePictureComplete:(UIImage *)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishImagePickerController:image:)]) {
        [self.delegate finishImagePickerController:self image:image];
    }
}

#pragma mark - MCameraViewDelegate
- (void)cameraViewSwicthFlashMode:(MCameraFlashMode)flashMode {
    [self.photoModel startSwitchFlashMode:flashMode];
}

- (void)cameraViewCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraViewSwitchPreOrPostPosition:(MCameraPosition)position {
    [self.photoModel startSwitchCameraPosition:position];
}

- (void)cameraViewTakePicture {
    [self.photoModel startCapturePicture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter
- (MDeviceOrientationModel *)deviceOrientaionModel {
    if (nil == _deviceOrientaionModel) {
        _deviceOrientaionModel = [[MDeviceOrientationModel alloc] init];
    }
    return _deviceOrientaionModel;
}

- (MCameraPhotoModel *)photoModel {
    if (nil == _photoModel) {
        _photoModel = [[MCameraPhotoModel alloc] init];
    }
    return _photoModel;
}

- (void)dealloc {
    NSLog(@"%@ dealloc",self);
}

@end
