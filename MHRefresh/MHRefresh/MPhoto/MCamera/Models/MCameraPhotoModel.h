//
//  MCameraPhotoModel.h
//  MHRefresh
//
//  Created by developer on 2017/9/6.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MCameraHeader.h"

typedef void (^ MCameraNotAuthorizedBlock) ();

typedef void (^ MCameraAddVideoLayerBlock) (CALayer *videoLayer);

typedef void (^ MCameraCapturePictureBlock) (UIImage *image);

@interface MCameraPhotoModel : NSObject

- (void)setCameraPhotoNotAuthorizedCallBackBlock:(MCameraNotAuthorizedBlock)callBackBlock;

- (void)setCameraPhotoAddVideoLayerCallBackBlock:(MCameraAddVideoLayerBlock)callBackBlock;

- (void)setCameraCapturePictureCallBackBlock:(MCameraCapturePictureBlock)callBackBlock;

- (void)startConfigurationCamera;

- (void)startCapturePicture;

- (void)startSwitchCameraPosition:(MCameraPosition)position;

- (void)startSwitchFlashMode:(MCameraFlashMode)flashMode;

- (void)updateCaptureVideoOrientationWithdeviceOrientation:(UIDeviceOrientation)orientation;

@end
