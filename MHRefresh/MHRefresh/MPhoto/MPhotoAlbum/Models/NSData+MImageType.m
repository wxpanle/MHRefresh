//
//  NSData+MImageType.m
//  MHRefresh
//
//  Created by developer on 2017/9/7.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "NSData+MImageType.h"

@implementation NSData (MImageType)

+ (MImageType)imageTypeWithData:(NSData *)data {
    
    uint8_t c;
    [data getBytes:&c length:1];
    
    MImageType type = MImageTypeOther;
    
    switch (c) {
        case 0xFF:
            type = MImageTypeJPEG;
            break;
            
        case 0x89:
            type = MImageTypePNG;
            break;
            
        case 0x47:
            type = MImageTypeGIF;
            break;
            
        default:
            break;
    }
    
    return type;
}

@end
