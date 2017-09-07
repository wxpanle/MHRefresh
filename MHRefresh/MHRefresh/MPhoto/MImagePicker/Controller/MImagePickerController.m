//
//  MImagePickerController.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MImagePickerController.h"
#import "MPhotoAuthorizationHelpModel.h"
#import "MImageCropDelegateModel.h"
#import "MCameraController.h"
#import "MPhotoAlbumController.h"

@interface MImagePickerController () <MImagePickerControllerDelegate>

@property (nonatomic, strong) MImageCropDelegateModel *cropDelegateModel;

@property (nonatomic, assign) MImagePickerCropMode cropMode;

@property (nonatomic, copy) MImagePickHandleBlock handleBlock;

@end

@implementation MImagePickerController

+ (void)pickPictureWithPresentVc:(UIViewController *)presentVc
                      sourceType:(MImagePickerSourceType)sourceType
                        cropMode:(MImagePickerCropMode)cropMode
                     handleBlock:(MImagePickHandleBlock)handleBlock {
    
    switch (sourceType) {

        case MImagePickerSourceTypeDefault: {
            
            if (![MPhotoAuthorizationHelpModel isAlreadyAuthorizedOfPhotoAlbum]) {
                [MPhotoAuthorizationHelpModel alertPhotoAlbumNotAllowWithPresentVc:presentVc];
            } else {
                MPhotoAlbumController *vc = [[MPhotoAlbumController alloc] initWithIsShowCamera:YES];
                MImagePickerController *nav = [[MImagePickerController alloc] initWithRootViewController:vc cropMode:cropMode];
                nav.cropMode = cropMode;
                nav.handleBlock = handleBlock;
                vc.delegate = nav;
                [presentVc presentViewController:nav animated:YES completion:nil];
            }
            
            break;
        }
            
        case MImagePickerSourceTypeCamera: {
            
            if (![MPhotoAuthorizationHelpModel isAlreadyAuthorizedOfCamera]) {
                [MPhotoAuthorizationHelpModel alertCameraNotAllowedWithPresentVc:presentVc];
            } else {
                MCameraController *vc = [[MCameraController alloc] init];
                MImagePickerController *nav = [[MImagePickerController alloc] initWithRootViewController:vc cropMode:cropMode];
                
                vc.delegate = nav;
                nav.cropMode = cropMode;
                nav.handleBlock = handleBlock;
                
                [presentVc presentViewController:nav animated:YES completion:nil];
            }
            
            break;
        }
            
        case MImagePickerSourceTypePhotoAlbum: {
            
            if (![MPhotoAuthorizationHelpModel isAlreadyAuthorizedOfPhotoAlbum]) {
                [MPhotoAuthorizationHelpModel alertPhotoAlbumNotAllowWithPresentVc:presentVc];
            } else {
                MPhotoAlbumController *vc = [[MPhotoAlbumController alloc] initWithIsShowCamera:NO];
                MImagePickerController *nav = [[MImagePickerController alloc] initWithRootViewController:vc cropMode:cropMode];
                nav.cropMode = cropMode;
                nav.handleBlock = handleBlock;
                vc.delegate = nav;
                [presentVc presentViewController:nav animated:YES completion:nil];
            }
            break;
        }
            
        default:
            break;
    }
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController cropMode:(MImagePickerCropMode)mode {
    
    if (self = [super initWithRootViewController:rootViewController]) {
        _cropMode = mode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutOfCropDelegateMode];
}

- (void)layoutOfCropDelegateMode {
    MemoryWeakSelf
    [self.cropDelegateModel setImageCropCompleteCallBackBlock:^(UIImage *image) {
        !weakSelf.handleBlock ? : weakSelf.handleBlock(weakSelf, image);
    }];
}

#pragma mark - MImagePickerControllerDelegate
- (void)finishImagePickerController:(UIViewController *)vc image:(UIImage *)image {
    
    [self.cropDelegateModel startCropImage:vc image:image];
}

- (void)cancelImagePickerController:(UIViewController *)vc {
    [vc dismissViewControllerAnimated:YES completion:nil];
}

- (void)occurErrorImagePickerController:(UIViewController *)vc {
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter
- (MImageCropDelegateModel *)cropDelegateModel {
    if (nil == _cropDelegateModel) {
        _cropDelegateModel = [[MImageCropDelegateModel alloc] init];
    }
    return _cropDelegateModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    NSLog(@"%@ dealloc", self);
}

@end
