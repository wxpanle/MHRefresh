//
//  MCameraPhotoModel.m
//  MHRefresh
//
//  Created by developer on 2017/9/6.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MCameraPhotoModel.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+SMExtension.h"

@interface MCameraPhotoModel()

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) dispatch_queue_t sessionQueue;

@property (nonatomic, strong) AVCaptureDeviceInput *currentDevice;

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) AVCapturePhotoOutput *photoOutPut;

@property (nonatomic, strong) UIImage *resultImage;

@property (nonatomic, copy) MCameraNotAuthorizedBlock notAuthorizedBlock;

@property (nonatomic, copy) MCameraAddVideoLayerBlock addVideoLayerBlock;

@property (nonatomic, copy) MCameraCapturePictureBlock capturePictureBlock;

@property (nonatomic, assign) MCameraPosition cameraPosition;

@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

@end

@implementation MCameraPhotoModel

- (instancetype)init {
    if (self = [super init]) {
        self.cameraPosition = MCameraPositionBack;
        self.videoOrientation = AVCaptureVideoOrientationPortrait;
    }
    return self;
}

#pragma mark - public
- (void)startConfigurationCamera {
    [self conformAuthorizationStatus];
}

- (void)startCapturePicture {
    
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (!stillImageConnection.isVideoOrientationSupported) {
        return;
    }
    
    if (!stillImageConnection.isEnabled) {
        return;
    }
    
    stillImageConnection.videoOrientation = self.videoOrientation;
    
    dispatch_async(self.sessionQueue, ^{
        
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

            if (error) {
                NSLog(@"捕捉失败 %@", error.description);
                return;
            }
            
            NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:data];
            
            if (image) {
                self.resultImage = [image fixOrientation];
                [self cameraCapturePictureCallBack];
            }
            
        }];
        
    });
    
}

- (void)startSwitchFlashMode:(MCameraFlashMode)flashMode {
    
    __autoreleasing NSError *error = nil;
    
    @try {
        [self.currentDevice.device lockForConfiguration:&error];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    switch (flashMode) {
        case MCameraFlashModeAuto:
            self.currentDevice.device.flashMode = AVCaptureFlashModeAuto;
            break;
            
        case MCameraFlashModeOn:
            self.currentDevice.device.flashMode = AVCaptureFlashModeOn;
            break;
            
        case MCameraFlashModeOff:
            self.currentDevice.device.flashMode = AVCaptureFlashModeOff;
            break;
            
        default:
            break;
    }

    [self.currentDevice.device unlockForConfiguration];
}

- (void)startSwitchCameraPosition:(MCameraPosition)position {
    self.cameraPosition = position;
    [self startAddPut];
}

- (void)updateCaptureVideoOrientationWithdeviceOrientation:(UIDeviceOrientation)orientation {
    
    switch (orientation) {
        case UIDeviceOrientationPortrait: {
            if (self.videoOrientation != AVCaptureVideoOrientationPortrait) {
                self.videoOrientation = AVCaptureVideoOrientationPortrait;
            }
            break;
        }
            
        case UIDeviceOrientationLandscapeLeft: {
            if (self.videoOrientation != AVCaptureVideoOrientationLandscapeRight) {
                self.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            }
            break;
        }
            
        case UIDeviceOrientationLandscapeRight: {
            if (self.videoOrientation != AVCaptureVideoOrientationLandscapeLeft) {
                self.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;

            }
            break;
        }
            
        case UIDeviceOrientationPortraitUpsideDown: {
            if (self.videoOrientation != AVCaptureVideoOrientationPortraitUpsideDown) {
                self.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - help ConfigurationCamera
- (void)conformAuthorizationStatus {
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    switch (authorizationStatus) {
        case AVAuthorizationStatusNotDetermined: {
            [self noDeterminedAuthorization];
            break;
        }
            
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied: {
            [self nonAuthorization];
            break;
        }
            
        case AVAuthorizationStatusAuthorized: {
            [self alreadyAuthorization];
            break;
        }
            
        default:
            break;
    }
}

- (void)nonAuthorization {
    [self cameraNotAuthorizedCallBack];
}

- (void)alreadyAuthorization {
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self cameraAddVideoLayerCallBack:layer];
    
    
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
    
    [self startAddPut];
}

- (void)noDeterminedAuthorization {
    
    MemoryWeakSelf
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            [weakSelf alreadyAuthorization];
        } else {
            [weakSelf nonAuthorization];
        }
    }];
}

- (void)startAddPut {
    
    dispatch_async(self.sessionQueue, ^{
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        [self.session beginConfiguration];
        [self addInput];
        [self addOuput];
        [self.session commitConfiguration];
    });
}

- (void)addInput {
    
    AVCaptureDevice *device = [self getAvaliableDeviceWithMediaType:AVMediaTypeVideo cameraPosition:self.cameraPosition];
    
    if (nil == device) {
        NSLog(@"获取相机失败 未发现可用设备");
        return;
    }
    
    AVCaptureDeviceInput *deviceInput = nil;
    NSError *error = nil;
    
    @try {
        deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    } @catch (NSException *exception) {
        if (error) {
            NSLog(@"获取相机失败 %@", error.description);
        }
    } @finally {
        
    }
    
    if (self.currentDevice) {
        [self.session removeInput:self.currentDevice];
    }
    
    self.currentDevice = deviceInput;
    
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
    }
}

- (AVCaptureDevice *)getAvaliableDeviceWithMediaType:(NSString *)mediaType cameraPosition:(MCameraPosition)position {
#warning 适配
    NSArray *avaliableDevicearray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDevicePosition devicePosition = AVCaptureDevicePositionUnspecified;
    
    switch (position) {
        case MCameraPositionBack:
            devicePosition = AVCaptureDevicePositionBack;
            break;
            
        case MCameraPositionFront:
            devicePosition = AVCaptureDevicePositionFront;
            break;
    }
    
    AVCaptureDevice *device = nil;
    
    for (AVCaptureDevice *captureDevice in avaliableDevicearray) {
        if (captureDevice.position == devicePosition) {
            device = captureDevice;
            break;
        }
    }
    return device;
}

- (void)addOuput {

    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
}


#pragma mark - public setCallBack
- (void)setCameraPhotoNotAuthorizedCallBackBlock:(MCameraNotAuthorizedBlock)callBackBlock {
    self.notAuthorizedBlock = callBackBlock;
}

- (void)setCameraPhotoAddVideoLayerCallBackBlock:(MCameraAddVideoLayerBlock)callBackBlock {
    self.addVideoLayerBlock = callBackBlock;
}

- (void)setCameraCapturePictureCallBackBlock:(MCameraCapturePictureBlock)callBackBlock {
    self.capturePictureBlock = callBackBlock;
}

#pragma mark - private callBack

- (void)cameraNotAuthorizedCallBack {
    MemoryWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        !weakSelf.notAuthorizedBlock ? : weakSelf.notAuthorizedBlock();
    });
}

- (void)cameraAddVideoLayerCallBack:(AVCaptureVideoPreviewLayer *)videoLayer {
    MemoryWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        !weakSelf.addVideoLayerBlock ? : weakSelf.addVideoLayerBlock(videoLayer);
    });
}

- (void)cameraCapturePictureCallBack {
    MemoryWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        !weakSelf.capturePictureBlock ? : weakSelf.capturePictureBlock(weakSelf.resultImage);
    });
}

#pragma mark - getter
- (dispatch_queue_t)sessionQueue {
    if (nil == _sessionQueue) {
        _sessionQueue = dispatch_queue_create( "com.memorycamera.sessionqueue", DISPATCH_QUEUE_SERIAL );
    }
    return _sessionQueue;
}

- (AVCaptureStillImageOutput *)stillImageOutput {
    if (nil == _stillImageOutput) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSetting = @{AVVideoCodecKey : AVVideoCodecJPEG};
        _stillImageOutput.outputSettings = outputSetting;
    }
    return _stillImageOutput;
}
#warning 适配
- (AVCapturePhotoOutput *)photoOutPut {
    if (nil == _photoOutPut) {
        _photoOutPut = [[AVCapturePhotoOutput alloc] init];
    }
    return _photoOutPut;
}

- (AVCaptureSession *)session {
    if (nil == _session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

@end
