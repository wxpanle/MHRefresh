//
//  MPhotoAlbumHelp.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPhotoModel, PHAsset;

typedef void (^ MGetPhotoSuccessBlock) (MPhotoModel *model);

@interface MPhotoAlbumHelp : NSObject

+ (BOOL)getAlbumAuthorizationStatusAuthorized;

+ (NSArray *)getAllAlbumPhoto;

+ (void)getPhoto:(PHAsset *)asset width:(CGFloat)width flag:(BOOL)flag completeBlock:(MGetPhotoSuccessBlock)callBackblock;

@end
