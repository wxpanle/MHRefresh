//
//  MPhotoAlbumModel.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAssetCollection, MPhotoModel;

typedef void (^ MGetPhotoSuccessBlock) (MPhotoModel *model);

typedef void (^ MPhotoGetImageBlock) (UIImage *image);

@interface MPhotoAlbumModel : NSObject

@property (nonatomic, strong) NSString *albumName;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithName:(NSString *)name collection:(PHAssetCollection *)assetCollection;

- (NSInteger)getPictureNumber;

- (void)getAlbumPhotoIndex:(NSInteger)index width:(CGFloat)width flag:(BOOL)flag callBlock:(MGetPhotoSuccessBlock)callBackBlock;

- (void)getOriginPhoto:(NSInteger)index handle:(MPhotoGetImageBlock)callBackBlock;

+ (instancetype)getPhotoAlbumModel;

@end
