//
//  QYPreviewImageModel.m
//  MHRefresh
//
//  Created by developer on 2017/9/14.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "QYPreviewImageModel.h"

@implementation QYPreviewImageModel

- (instancetype)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setOriginImage:(UIImage *)originImage {
    _originImage = originImage;
    self.originalSize = originImage.size;
}

+ (instancetype)previewImageModelWithThumbnailUrl:(NSString *)urlString {
    
    QYPreviewImageModel *model = [[self alloc] init];
    model.thumbnailUrl = urlString;
    return model;
}

+ (instancetype)previewImageModelWithOriginUrl:(NSString *)urlString {
    
    QYPreviewImageModel *model = [[self alloc] init];
    model.originUrl = urlString;
    return model;
}

@end
