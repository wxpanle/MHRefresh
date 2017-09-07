//
//  MPhotoAuthorizationHelpModel.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPhotoAuthorizationHelpModel : NSObject

+ (BOOL)isAlreadyAuthorizedOfCamera;

+ (BOOL)isAlreadyAuthorizedOfPhotoAlbum;

+ (void)alertCameraNotAllowedWithPresentVc:(UIViewController *)presentVc;

+ (void)alertPhotoAlbumNotAllowWithPresentVc:(UIViewController *)presentVc;

@end
