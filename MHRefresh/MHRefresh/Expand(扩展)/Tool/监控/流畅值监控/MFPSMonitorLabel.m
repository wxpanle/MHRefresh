//
//  MFPSMonitorLabel.m
//  Memory
//
//  Created by developer on 2017/7/25.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "MFPSMonitorLabel.h"

#if M_MONITOR_ENABLED
@interface MFPSMonitorLabel()

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation MFPSMonitorLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self layoutUIOfSelf];
    }
    return self;
}

#pragma mark - public
- (void)updateTextWithFPS:(int)fpsValue CPU:(float)cpuValue {
    if (fpsValue >= 45) {
        self.textColor = [UIColor colorWithRed:0.0 green:128 / 255.0 blue:0.0 alpha:1.0];
    } else if (fpsValue >= 30) {
        self.textColor = [UIColor colorWithRed:255/255.0 green:215/255.0 blue:0/255.0 alpha:1];
    } else {
        self.textColor = [UIColor redColor];
    }
    
    self.text = [NSString stringWithFormat:@"FPS-%d\nCPU-%.1f", fpsValue, cpuValue];
}

#pragma mark - layoutUI
- (void)layoutUIOfSelf {
    self.edgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
    self.textAlignment = NSTextAlignmentCenter;
    self.numberOfLines = 2.0;
    self.font = [UIFont systemFontOfSize:8.0];
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.width += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.width += self.edgeInsets.left + self.edgeInsets.right;
    sizeThatFits.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return sizeThatFits;
}

@end
#endif
