//
//  UIAlertController+UPExtension.h
//  Up
//
//  Created by panle on 2018/3/21.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (UPExtension)

+ (void)up_alertVcWithVc:(nullable UIViewController *)vc
                   title:(nullable NSString *)title
                 message:(nullable NSString *)message
            confirmBlock:(nullable dispatch_block_t)confirmBlock
             cancelBlock:(nullable dispatch_block_t)cancelBlock;

+ (void)up_settingAlertWithVc:(nullable UIViewController *)vc
                        titke:(nullable NSString *)title
                      message:(nullable NSString *)message
                 settingBlock:(nullable dispatch_block_t)settingBlock
                  cancelBlock:(nullable dispatch_block_t)cancelBlock;

+ (void)up_alertVcWithVc:(nullable UIViewController *)vc
                   title:(nullable NSString *)title
                 message:(nullable NSString *)message
             actionArray:(nullable NSArray <UIAlertAction *>*)actionArray;

+ (void)up_alertSheetVcWithVc:(nullable UIViewController *)vc
                        title:(nullable NSString *)title
                      message:(nullable NSString *)message
                  actionArray:(nullable NSArray <UIAlertAction *>*)actionArray;

+ (void)up_alertWithPickImageWithVc:(nullable UIViewController *)vc
                  takePhotoCallBack:(void (^ __nullable)(UIAlertAction *action))takePhotoCallback
                 photoAlbumCallBack:(void (^ __nullable)(UIAlertAction *action))photoAlbumCallBack;

@end

NS_ASSUME_NONNULL_END
