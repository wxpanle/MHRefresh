//
//  MBProgressHUD+UPExtension.h
//  Up
//
//  Created by panle on 2018/4/10.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (UPExtension)

/**
 显示纯文本信息 默认时间

 @param message message
 */
+ (void)showMessage:(NSString *)message;

/**
 显示自定义事件的纯文本信息

 @param message message
 @param duration duration
 */
+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration;

/**
 在特定view上显示纯文本信息 默认时间

 @param message message
 @param aimView aimView
 */
+ (void)showMessage:(NSString *)message aimView:(UIView *)aimView;

/**
 在特定view上显示纯文本信息 自定义时间

 @param message message
 @param duration duration
 @param aimView aimView
 */
+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration aimView:(UIView *)aimView;


#pragma mark - ======== loading ========
/**
 加载中显示纯文本信息

 @param message message
 */
+ (void)showLoadingMessage:(NSString *)message;

/**
 加载中显示纯文本信息 目标view

 @param message message
 @param aimView aimView
 */
+ (void)showLoadingMessage:(NSString *)message aimView:(UIView *)aimView;

/**
 隐藏HUD
 */
+ (void)hideHUD;

/**
 隐藏指定view里的HUD

 @param aimView aimView
 */
+ (void)hideHUDAimView:(UIView *)aimView;

/**
 显示信息 网络不可用
 */
+ (void)showMessageNewworkNotEnable;

/**
 显示信息 网络不可用

 @param aimView aimView
 */
+ (void)showMessageNewworkNotEnable:(UIView *)aimView;

/**
 显示信息 未知错误
 */
+ (void)showMessageUnKnowError;

/**
 显示信息 未知错误

 @param aimView aimView 
 */
+ (void)showMessageUnKnowErrorAimView:(UIView *)aimView;

/**
 显示信息 下载失败
 */
+ (void)showMessageDownloadFail;

/**
 显示信息 下载失败

 @param aimView aimView
 */
+ (void)showMessageDownloadFail:(UIView *)aimView;

@end
