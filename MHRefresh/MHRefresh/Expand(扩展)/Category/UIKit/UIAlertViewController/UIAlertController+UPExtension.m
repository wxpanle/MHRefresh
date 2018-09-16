//
//  UIAlertController+UPExtension.m
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "UIAlertController+UPExtension.h"
#import "UIViewController+QYVisible.h"
#import "UIAlertAction+UPFactory.h"

@implementation UIAlertController (UPExtension)

+ (void)up_alertVcWithVc:(nullable UIViewController *)vc
                   title:(nullable NSString *)title
                 message:(nullable NSString *)message
            confirmBlock:(nullable dispatch_block_t)confirmBlock
             cancelBlock:(nullable dispatch_block_t)cancelBlock {

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitleType:UPAlertActionTitleTypeCancel handle:^(UIAlertAction *action) {
        !cancelBlock?:cancelBlock();
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitleType:UPAlertActionTitleTypeDone handle:^(UIAlertAction *action) {
        !confirmBlock?:confirmBlock();
    }];
    
    [self up_alertVcWithVc:vc title:title message:message actionArray:@[cancelAction, confirmAction]];
}

+ (void)up_settingAlertWithVc:(nullable UIViewController *)vc
                        titke:(nullable NSString *)title
                      message:(nullable NSString *)message
                 settingBlock:(nullable dispatch_block_t)settingBlock
                  cancelBlock:(nullable dispatch_block_t)cancelBlock {
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitleType:UPAlertActionTitleTypeCancel handle:^(UIAlertAction *action) {
        !cancelBlock?:cancelBlock();
    }];
    
    UIAlertAction *setAction = [UIAlertAction actionWithTitleType:UPAlertActionTitleTypeSet handle:^(UIAlertAction *action) {
        !settingBlock?:settingBlock();
    }];
    
    [self up_alertVcWithVc:vc title:title message:message actionArray:@[cancelAction, setAction]];
}

+ (void)up_alertVcWithVc:(nullable UIViewController *)vc
                   title:(nullable NSString *)title
                 message:(nullable NSString *)message
             actionArray:(nullable NSArray <UIAlertAction *>*)actionArray {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (UIAlertAction *action in actionArray) {
        [alert addAction:action];
    }
    
    if (!vc) {
//        vc = [self topViewController];
    }
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)up_alertSheetVcWithVc:(nullable UIViewController *)vc
                        title:(nullable NSString *)title
                      message:(nullable NSString *)message
                  actionArray:(nullable NSArray <UIAlertAction *>*)actionArray {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (UIAlertAction *action in actionArray) {
        [alert addAction:action];
    }
    
    if (!vc) {
//        vc = [self topViewController];
    }
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void)up_alertWithPickImageWithVc:(nullable UIViewController *)vc
                  takePhotoCallBack:(void (^ __nullable)(UIAlertAction *action))takePhotoCallback
                 photoAlbumCallBack:(void (^ __nullable)(UIAlertAction *action))photoAlbumCallBack {
    
    UIAlertAction *takeAction = [UIAlertAction actionWithTitle:LocalizedString(@"alert.meinfo.picture.camera.action") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (takePhotoCallback) {
            takePhotoCallback(action);
        }
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:LocalizedString(@"alert.meinfo.picture.photo.action") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (photoAlbumCallBack) {
            photoAlbumCallBack(action);
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitleType:UPAlertActionTitleTypeCancel handle:nil];
    
    [self up_alertSheetVcWithVc:vc title:nil message:nil actionArray:@[takeAction, photoAction, cancelAction]];
}

@end
