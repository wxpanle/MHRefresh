//
//  MPhotoAlbumModel.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MPhotoAlbumModel.h"
#import <Photos/Photos.h>
#import "NSData+MImageType.h"
#import "MPhotoAlbumHelp.h"
#import "MGifDataCache.h"

@interface MPhotoAlbumModel()

@property (nonatomic, strong) PHAssetCollection *assetCollection;

@property (nonatomic, strong) PHFetchResult <PHAsset *> *result;

@end

@implementation MPhotoAlbumModel

+ (instancetype)getPhotoAlbumModel {
    NSArray *array = [MPhotoAlbumHelp getAllAlbumPhoto];
    
    if (array.count) {
        return array.firstObject;
    }
    
    return nil;
}

- (instancetype)initWithName:(NSString *)name collection:(PHAssetCollection *)assetCollection {

    if (self = [super init]) {
        self.albumName = name;
        self.assetCollection = assetCollection;
        [self startFetchResult];
    }
    return self;
}

- (NSInteger)getPictureNumber {
    return self.result.count;
}

- (void)startFetchResult {
    
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %ld", PHAssetMediaTypeImage];
    fetchOptions.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
    self.result = [PHAsset fetchAssetsWithOptions:fetchOptions];
}

- (void)getAlbumPhotoIndex:(NSInteger)index width:(CGFloat)width flag:(BOOL)flag callBlock:(MGetPhotoSuccessBlock)callBackBlock {
    [MPhotoAlbumHelp getPhoto:[self.result objectAtIndex:index] width:width flag:flag completeBlock:^(MPhotoModel *model) {
        !callBackBlock ? : callBackBlock(model);
    }];
}

- (void)getOriginPhoto:(NSInteger)index handle:(MPhotoGetImageBlock)callBackBlock {
    [[PHImageManager defaultManager] requestImageDataForAsset:[self.result objectAtIndex:index] options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        if (imageData) {
            UIImage *image = [UIImage imageWithData:imageData];
            if ([NSData imageTypeWithData:imageData] == MImageTypeGIF) {
                [[MGifDataCache sharedGifDataCache] cacheData:imageData image:image];
            }
            
            !callBackBlock ? : callBackBlock(image);
        }
    }];
}


@end
