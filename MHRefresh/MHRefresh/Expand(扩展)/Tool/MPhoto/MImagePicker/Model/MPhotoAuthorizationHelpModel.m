//
//  MPhotoAuthorizationHelpModel.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MPhotoAuthorizationHelpModel.h"
#import <Photos/Photos.h>

@implementation MPhotoAuthorizationHelpModel

+ (BOOL)isAlreadyAuthorizedOfCamera {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    BOOL isCanUse = NO;
    
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
        case AVAuthorizationStatusAuthorized:
            isCanUse = YES;
            break;
            
        default:
            break;
    }
    
    return isCanUse;
}

+ (BOOL)isAlreadyAuthorizedOfPhotoAlbum {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    BOOL isCanUse = NO;
    
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
        case PHAuthorizationStatusAuthorized:
            isCanUse = YES;
            break;
            
        default:
            break;
    }
    
    return isCanUse;
}


+ (void)alertCameraNotAllowedWithPresentVc:(UIViewController *)presentVc {
    [self showSettingAlertInVc:presentVc withTitle:@"相机无法启动" message:@"只有在设置中打开相机，我们才能继续\n使用相机功能" settingBlock:^{
        [self leaveForSettingView];
    } cancelBlock:nil];
}

+ (void)alertPhotoAlbumNotAllowWithPresentVc:(UIViewController *)presentVc {
    [self showSettingAlertInVc:presentVc withTitle:@"相册无法启动" message:@"只有在设置中打开相册，我们才能继续\n使用相册功能" settingBlock:^{
        [self leaveForSettingView];
    } cancelBlock:nil];
}

+ (void)leaveForSettingView {
    
    NSURL *url = [[NSURL alloc] initWithString:UIApplicationOpenSettingsURLString];
    
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        return;
    }
    
    if (IS_iOS_10_Later) {
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)showSettingAlertInVc:(UIViewController *)vc withTitle:(NSString *)title message:(NSString *)message settingBlock:(void (^)(void))settingBlock cancelBlock:(void (^)(void))cancelBlock {
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !cancelBlock?:cancelBlock();
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        !settingBlock?:settingBlock();
    }];
    
    [alertVc addAction:cancelAction];
    [alertVc addAction:confirmAction];
    
    if (!vc) {
        vc = [self topVc];
    }
    [vc presentViewController:alertVc animated:YES completion:nil];
}

+ (UIViewController *)topVc {
    
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if(tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0) {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            activityViewController = nextResponder;
        }
        else {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
    
}

@end
