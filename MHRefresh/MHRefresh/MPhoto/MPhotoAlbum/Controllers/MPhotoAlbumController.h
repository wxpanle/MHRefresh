//
//  MPhotoAlbumController.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MImagePickerHeader.h"

@interface MPhotoAlbumController : UIViewController

@property (nonatomic, weak) id <MImagePickerControllerDelegate> delegate;

- (instancetype)initWithIsShowCamera:(BOOL)isShowCamera;

@end
