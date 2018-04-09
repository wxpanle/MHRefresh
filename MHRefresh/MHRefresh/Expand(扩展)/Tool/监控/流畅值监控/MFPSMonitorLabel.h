//
//  MFPSMonitorLabel.h
//  Memory
//
//  Created by developer on 2017/7/25.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMonitor.h"
#if M_MONITOR_ENABLED
@interface MFPSMonitorLabel : UILabel

- (void)updateTextWithFPS:(int)fpsValue CPU:(float)cpuValue;

@end
#endif
