//
//  NSData+MImageType.h
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MImageType) {
    MImageTypeGIF,
    MImageTypePNG,
    MImageTypeJPEG,
    MImageTypeOther
};

@interface NSData (MImageType)

+ (MImageType)imageTypeWithData:(NSData *)data;

@end
