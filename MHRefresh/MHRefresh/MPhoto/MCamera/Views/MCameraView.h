//
//  MCameraView.h
//  MHRefresh
//
//  Created by developer on 2017/9/6.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCarmraEnumHeader.h"

@protocol MCameraViewDelegate  <NSObject>

- (void)cameraViewSwicthFlashMode:(MCameraFlashMode)flashMode;

- (void)cameraViewCancel;

- (void)cameraViewSwitchPreOrPostPosition:(MCameraPosition)position;

- (void)cameraViewTakePicture;

@end

@interface MCameraView : UIView

@property (nonatomic, weak) id <MCameraViewDelegate> delegate;

- (void)updateViewTransformWithDeviewOrientation:(UIDeviceOrientation)orientation;

- (void)addVideoPreviewLayer:(CALayer *)layer;

@end
