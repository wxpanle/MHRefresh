//
//  MImageCropDelegateModel.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MImagePickerHeader.h"

typedef void (^ MImageCropCompleteBlock) (UIImage *image);

@interface MImageCropDelegateModel : NSObject

- (void)setImageCropMode:(MImagePickerCropMode)cropMode;

- (void)setImageCropCompleteCallBackBlock:(MImageCropCompleteBlock)callBackBlock;

- (void)startCropImage:(UIViewController *)presentVc image:(UIImage *)iamge;

@end
