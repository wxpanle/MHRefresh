//
//  MPhotoModel.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MPhotoModel.h"

@implementation MPhotoModel

- (instancetype)initWithImage:(UIImage *)image type:(MPhotoType)type {
    if (self = [super init]) {
        self.image = image;
        self.type = type;
    }
    return self;
}

@end
