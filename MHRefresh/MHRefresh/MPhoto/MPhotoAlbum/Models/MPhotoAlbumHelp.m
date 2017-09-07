//
//  MPhotoAlbumHelp.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MPhotoAlbumHelp.h"
#import <Photos/Photos.h>
#import "MPhotoModel.h"
#import "MPhotoAlbumModel.h"

@implementation MPhotoAlbumHelp

+ (BOOL)getAlbumAuthorizationStatusAuthorized {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    BOOL isAuthorized = NO;

    switch (status) {
        case PHAuthorizationStatusAuthorized: {
            isAuthorized = YES;
            break;
        }
            
        default:
            break;
    }
    return isAuthorized;
}

+ (NSArray *)getAllAlbumPhoto {
    
    NSMutableArray *array = [NSMutableArray array];
    __block NSInteger number = 0;
    
    PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    
    [result enumerateObjectsUsingBlock:^(PHAssetCollection *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *name = obj.localizedTitle;
        MPhotoAlbumModel *model = [[MPhotoAlbumModel alloc] initWithName:name collection:obj];
        
        NSInteger pictureNumber = [model getPictureNumber];
        
        if (pictureNumber == 0) {
            return;
        }
        
        if (pictureNumber > number) {
            [array insertObject:model atIndex:0];
            number = pictureNumber;
        } else {
            [array addObject:model];
        }
        
    }];
    
    return [[NSArray alloc] initWithArray:array];
}

+ (void)getPhoto:(PHAsset *)asset width:(CGFloat)width flag:(BOOL)flag completeBlock:(MGetPhotoSuccessBlock)callBackblock {
    
    PHImageManager *manager =[PHImageManager defaultManager];
    
    CGFloat screenWidth = WIDTH;
    CGFloat imageWidth = screenWidth < width ? screenWidth : width;
    CGFloat multiple = [UIScreen mainScreen].scale;
    CGFloat scaleW = asset.pixelHeight * 1.0 / asset.pixelWidth;
    CGFloat imageHeight = scaleW * imageWidth;
    
    CGSize size = CGSizeMake(imageWidth * multiple, imageHeight * multiple);
    
    PHImageRequestOptions *requestOptions = nil;
    
    if (flag) {
        requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.synchronous = YES;
    }
    
    [manager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if (callBackblock) {
            NSString *identifier = [asset valueForKey:@"uniformTypeIdentifier"];
            MPhotoType type = [identifier containsString:@".gif"] ? MPhotoTypeGIF : MPhotoTypeDefault;
            MPhotoModel *model = [[MPhotoModel alloc] initWithImage:result type:type];
            callBackblock(model);
        }
        
    }];
}



@end
