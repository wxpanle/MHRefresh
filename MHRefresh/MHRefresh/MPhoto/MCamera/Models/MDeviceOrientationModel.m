//
//  MDeviceOrientationModel.m
//  MHRefresh
//
//  Created by developer on 2017/9/6.
//  Copyright © 2017年 developer. All rights reserved.
//

#import "MDeviceOrientationModel.h"
#import <CoreMotion/CoreMotion.h>

@interface MDeviceOrientationModel()

@property (nonatomic, strong) CMMotionManager *motionManager;

@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;

@property (nonatomic, copy) MDeviceOrientationBlock deviceOrientationBlock;

@end

@implementation MDeviceOrientationModel

- (instancetype)init {
    if (self = [super init]) {
        [self layoutOfMotionManager];
    }
    return self;
}

- (void)layoutOfMotionManager {
    
    self.deviceOrientation = UIDeviceOrientationPortrait;
    
    if (self.motionManager.isAccelerometerAvailable) {
        self.motionManager.accelerometerUpdateInterval = 0.01;
        
        MemoryWeakSelf
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            if (nil != accelerometerData) {
                
                CMAcceleration acceleration = accelerometerData.acceleration;
                
                double x = acceleration.x;
                double y = acceleration.y;
                
                UIDeviceOrientation orientation = UIDeviceOrientationPortrait;
                
                if (x < -0.5) {
                    orientation = UIDeviceOrientationLandscapeLeft;
                } else if (x > 0.5) {
                    orientation = UIDeviceOrientationLandscapeRight;
                } else if (y > 0.5) {
                    orientation = UIDeviceOrientationPortraitUpsideDown;
                } else if (y < -0.5) {
                    orientation = UIDeviceOrientationPortrait;
                } else {
                    //z < -0.75  faceUp   z > -0.75 faceDown
                    return;
                }
                
                [weakSelf callBackWithOrientation:orientation];
            }
        }];

    } else {

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveDeviceOrientationDidChangeNotification) name:UIDeviceOrientationDidChangeNotification object:nil];
        _motionManager = nil;
    }

}

#pragma mark - notification
- (void)reciveDeviceOrientationDidChangeNotification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (self.deviceOrientation != orientation) {
        self.deviceOrientation = orientation;
        [self callBackWithOrientation:orientation];
    }
}

#pragma mark - public callBack
- (void)setDeviceOrientationCallBackBlock:(MDeviceOrientationBlock)callcBackBlock {
    self.deviceOrientationBlock = callcBackBlock;
}

#pragma mark - callBack
- (void)callBackWithOrientation:(UIDeviceOrientation)orientation {
    MemoryWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        !weakSelf.deviceOrientationBlock ? : weakSelf.deviceOrientationBlock(orientation);
    });
}

#pragma mark - help motionManager
- (void)stopMotionManager {
    if (_motionManager && _motionManager.isAccelerometerAvailable) {
        [_motionManager stopAccelerometerUpdates];
    }
    _motionManager = nil;
}

#pragma mark - getter
- (CMMotionManager *)motionManager {
    if (nil == _motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}

#pragma mark - dealloc
- (void)dealloc {
    [self stopMotionManager];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc", self);
}

@end
