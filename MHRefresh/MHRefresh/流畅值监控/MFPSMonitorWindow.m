//
//  MFPSMonitorWindow.m
//  Memory
//
//  Created by developer on 2017/7/25.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "MFPSMonitorWindow.h"

#if M_MONITOR_ENABLED
@implementation MFPSMonitorWindow

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUIOfSelf];
    }
    return self;
}

- (void)layoutUIOfSelf {
    self.windowLevel = UIWindowLevelStatusBar + 1.0;
    self.backgroundColor = [UIColor clearColor];
    self.tag = 1000;
    self.hidden = NO;
    self.userInteractionEnabled = NO;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        self.rootViewController = [[UIViewController alloc] init];
    }
}

@end
#endif
