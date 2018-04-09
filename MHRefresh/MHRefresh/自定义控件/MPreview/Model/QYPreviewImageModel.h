//
//  QYPreviewImageModel.h
//  MHRefresh
//
//  Created by developer on 2017/9/14.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYPreviewImageModel : NSObject

/** 缩略图 url */
@property (nonatomic, copy) NSString *thumbnailUrl;
/** 原图 url */
@property (nonatomic, copy) NSString *originUrl;
/** 缩略图 */
@property (nonatomic, strong) UIImage *thumbnailImage;
/** 原图 */
@property (nonatomic, strong) UIImage *originImage;
/** 图片原始尺寸 */
@property (nonatomic, assign) CGSize originalSize;

+ (instancetype)previewImageModelWithThumbnailUrl:(NSString *)urlString;

+ (instancetype)previewImageModelWithOriginUrl:(NSString *)urlString;


@end
