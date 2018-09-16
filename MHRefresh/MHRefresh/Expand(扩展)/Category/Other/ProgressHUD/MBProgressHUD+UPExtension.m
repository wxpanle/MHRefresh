//
//  MBProgressHUD+UPExtension.m
//  Up
//
//  Created by panle on 2018/4/10.
//  Copyright © 2018年 LanguoNetwork. All rights reserved.
//

#import "MBProgressHUD+UPExtension.h"

@implementation MBProgressHUD (UPExtension)

+ (void)showMessage:(NSString *)message {
    [self showMessage:message duration:UPHUDDuration];
}

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration {
    [self showMessage:message duration:UPHUDDuration aimView:nil];
}

+ (void)showMessage:(NSString *)message aimView:(UIView *)aimView {
    [self showMessage:message duration:UPHUDDuration aimView:aimView];
}

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration aimView:(UIView *)aimView {
    [MBProgressHUD hideHUD];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aimView ? aimView : [UIApplication sharedApplication].windows.lastObject animated:YES];
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hideAnimated:YES afterDelay:duration];
}

+ (void)showLoadingMessage:(NSString *)message {
    [self showLoadingMessage:message aimView:nil];
}

+ (void)showLoadingMessage:(NSString *)message aimView:(UIView *)aimView {
    
    UIView *showView = aimView == nil ? [UIApplication sharedApplication].windows.lastObject : aimView;
    
    if ([self HUDForView:aimView]) {
        [self hideHUDAimView:aimView];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:showView animated:YES];
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.removeFromSuperViewOnHide = YES;
}

+ (void)hideHUD {
    [self hideHUDAimView:[self p_lastWindowWithIncludeProgressHUD]];
}

+ (void)hideHUDAimView:(UIView *)aimView {
    [MBProgressHUD hideHUDForView:aimView != nil ? aimView : [self p_lastWindowWithIncludeProgressHUD] animated:YES];
}

+ (void)showMessageNewworkNotEnable {
    [self showMessageNewworkNotEnable:nil];
}

+ (void)showMessageNewworkNotEnable:(UIView *)aimView {
    [self showMessage:LocalizedString(@"MBProgressHUD.extension.netAvailable") aimView:aimView];
}

+ (void)showMessageUnKnowError {
    [self showMessageUnKnowErrorAimView:nil];
}

+ (void)showMessageUnKnowErrorAimView:(UIView *)aimView {
    [self showMessage:LocalizedString(@"MBProgressHUD.unknowerror.title") aimView:aimView];
}

+ (void)showMessageDownloadFail {
    [self showMessageDownloadFail:nil];
}

+ (void)showMessageDownloadFail:(UIView *)aimView {
    [self showMessage:LocalizedString(@"MBProgressHUD.extension.donwloadFail") aimView:aimView];
}


#pragma mark - help

#pragma mark - ======== private ========

+ (UIWindow *)p_lastWindowWithIncludeProgressHUD {
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:window];
        if (nil != hud) {
            return window;
        }
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

@end
