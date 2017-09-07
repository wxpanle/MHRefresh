//
//  MImagePickerController.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MImagePickerHeader.h"

typedef void (^ MImagePickHandleBlock) (UIViewController *vc, UIImage *image);

@interface MImagePickerController : UINavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController NS_UNAVAILABLE;

+ (void)pickPictureWithPresentVc:(UIViewController *)presentVc
                      sourceType:(MImagePickerSourceType)sourceType
                        cropMode:(MImagePickerCropMode)cropMode
                     handleBlock:(MImagePickHandleBlock)handleBlock;


@end
