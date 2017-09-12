//
//  MImageCropDelegateModel.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MImageCropDelegateModel.h"
#import "RSKImageCropper.h"

@interface MImageCropDelegateModel() <RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

@property (nonatomic, copy) MImageCropCompleteBlock completeBlock;

@property (nonatomic, assign) MImagePickerCropMode cropMode;

@end

@implementation MImageCropDelegateModel

#pragma mark - init
- (instancetype)initWithCropMode:(MImagePickerCropMode)cropMode {
    if (self = [super init]) {
        _cropMode = cropMode;
    }
    return self;
}

#pragma mark - setter
- (void)setImageCropMode:(MImagePickerCropMode)cropMode {
    _cropMode = cropMode;
}

#pragma mark - startCrop
- (void)startCropImage:(UIViewController *)presentVc image:(UIImage *)iamge {
    
    RSKImageCropMode mode = RSKImageCropModeCircle;
    
    BOOL isReturn = NO;
    
    switch (self.cropMode) {
        case MImagePickerCropModeNone: {
            [self completeCallBackBlockWithImage:iamge];
            isReturn = YES;
            break;
        }
            
        case MImagePickerCropModeRect: {
            mode = RSKImageCropModeCustom;
            break;
        }
            
        case MImagePickerCropModeCircle: {
            mode = RSKImageCropModeCircle;
            break;
        }
            
        case MImagePickerCropModeSquare: {
            mode = RSKImageCropModeSquare;
            break;
        }
            
        default: {
            isReturn = YES;
        }
            break;
    }
    
    if (isReturn) {
        return;
    }
    
    [self cropImageWithPresentVc:presentVc image:iamge cropMode:mode];
}

- (void)cropImageWithPresentVc:(UIViewController *)presentVc image:(UIImage *)image cropMode:(RSKImageCropMode)mode {
    
    RSKImageCropViewController *vc = [[RSKImageCropViewController alloc] initWithImage:image cropMode:mode];
    
    vc.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    
    if (mode == RSKImageCropModeSquare) {
        vc.portraitSquareMaskRectInnerEdgeInset = 2.0;
    }
    
    vc.delegate = self;
    vc.dataSource = self;
    
    [presentVc presentViewController:vc animated:NO completion:nil];
}

#pragma mark - public callBackBlock
- (void)setImageCropCompleteCallBackBlock:(MImageCropCompleteBlock)callBackBlock {
    self.completeBlock = callBackBlock;
}


#pragma mark - private callBackBlock
- (void)completeCallBackBlockWithImage:(UIImage *)image {
    !self.completeBlock ? : self.completeBlock(image);
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller {
    [controller dismissViewControllerAnimated:NO completion:nil];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect {
    WeakSelf
    [controller dismissViewControllerAnimated:NO completion:^{
        [weakSelf completeCallBackBlockWithImage:croppedImage];
    }];
}

#pragma mark - RSKImageCropViewControllerDataSource
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller {

    CGRect rect = CGRectZero;
    
    switch (self.cropMode) {

        case MImagePickerCropModeRect: {
            rect = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
            break;
        }
            
        case MImagePickerCropModeCircle: {

            CGFloat maskW = SCREEN_W - 1.0;
            CGFloat maskH = maskW;
            rect = CGRectMake((SCREEN_H - maskH) / 2.0, (SCREEN_W - maskH) / 2.0, maskW, maskH);
            break;
        }
        default:
            break;
    }
    
    return rect;
}

- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller {
    return CGRectMake(0, 0, SCREEN_W, SCREEN_H);
}

- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller {

    
    CGRect rect = controller.maskRect;
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    
    
    switch (self.cropMode) {
            
        case MImagePickerCropModeRect: {
            CGFloat f1 = CGRectGetMinX(rect);
            CGFloat f2 = CGRectGetMaxX(rect);
            CGFloat f3 = CGRectGetMinY(rect);
            CGFloat f4 = CGRectGetMaxY(rect);
            
            CGPoint point1 = CGPointMake(f1, f3);
            CGPoint point2 = CGPointMake(f2, f3);
            CGPoint point3 = CGPointMake(f2, f4);
            CGPoint point4 = CGPointMake(f1, f4);
            
            [bezierPath moveToPoint:point1];
            [bezierPath addLineToPoint:point2];
            [bezierPath addLineToPoint:point3];
            [bezierPath addLineToPoint:point4];

            [bezierPath closePath];
            break;
        }
            
        case MImagePickerCropModeCircle: {
            
            CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
            CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
            CGPoint point3 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            
            [bezierPath moveToPoint:point1];
            [bezierPath addLineToPoint:point2];
            [bezierPath addLineToPoint:point3];

            [bezierPath closePath];
            break;
        }
        default:
            break;
    }
    
    return bezierPath;
}

#pragma mark - dealloc
- (void)dealloc {
    _completeBlock = nil;
}

@end
