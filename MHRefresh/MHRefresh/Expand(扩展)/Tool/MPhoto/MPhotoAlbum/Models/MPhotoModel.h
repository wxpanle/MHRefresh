//
//  MPhotoModel.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MPhotoType) {
    MPhotoTypeDefault = 0,
    MPhotoTypeGIF
};

@interface MPhotoModel : NSObject

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) MPhotoType type;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithImage:(UIImage *)image type:(MPhotoType)type;

@end
