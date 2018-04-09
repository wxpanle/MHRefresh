//
//  MDeviceOrientationModel.h
//  MHRefresh
//
//  Created by developer on 2017/9/6.
//  Copyright © 2017年 developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ MDeviceOrientationBlock) (UIDeviceOrientation deviceOrientation);

@interface MDeviceOrientationModel : NSObject

- (void)setDeviceOrientationCallBackBlock:(MDeviceOrientationBlock)callcBackBlock;

@end
