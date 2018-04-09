//
//  MImagePickerHeader.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#ifndef MImagePickerHeader_h
#define MImagePickerHeader_h

@protocol MImagePickerControllerDelegate <NSObject>

- (void)finishImagePickerController:(UIViewController *)vc image:(UIImage *)image;

- (void)cancelImagePickerController:(UIViewController *)vc;

- (void)occurErrorImagePickerController:(UIViewController *)vc;

- (void)startShowCamera:(UIViewController *)vc;

@end

typedef NS_ENUM(NSInteger, MImagePickerCropMode) {
    MImagePickerCropModeNone,
    MImagePickerCropModeCircle,
    MImagePickerCropModeRect,
    MImagePickerCropModeSquare
};

typedef NS_ENUM(NSInteger, MImagePickerSourceType) {
    MImagePickerSourceTypeDefault,
    MImagePickerSourceTypeCamera,
    MImagePickerSourceTypePhotoAlbum
};


#endif /* MImagePickerHeader_h */
