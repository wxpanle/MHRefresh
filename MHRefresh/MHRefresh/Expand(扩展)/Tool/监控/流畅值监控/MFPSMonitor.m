//
//  MFPSMonitor.m
//  Memory
//
//  Created by developer on 2017/7/25.
//  Copyright © 2017年 blueliveMBB. All rights reserved.
//

#import "MFPSMonitor.h"
#import "MFPSMonitorLabel.h"
#import "MFPSMonitorWindow.h"
#import <mach/mach.h>

#if M_MONITOR_ENABLED

@interface MFPSMonitor()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) MFPSMonitorWindow *monitorWindow;

@property (nonatomic, strong) MFPSMonitorLabel *monitorLabel;

@property (nonatomic) int screenUpdatesCount;

@property (nonatomic) CFTimeInterval screenUpdatesBeginTime;          //屏幕开始更新时间

@property (nonatomic) CFTimeInterval averageScreenUpdatesTime;        //屏幕刷新比例

@end

@implementation MFPSMonitor

+ (void)load {
//    [MFPSMonitor sharedMFPSMonitor];
}

+ (instancetype)sharedMFPSMonitor {
    static dispatch_once_t onceToken;
    static MFPSMonitor *fpsMonitor = nil;
    dispatch_once(&onceToken, ^{
        fpsMonitor = [[self alloc] init];
    });
    return fpsMonitor;
}

- (instancetype)init {
    if (self = [super init]) {
        [self layoutUIOfObserves];
    }
    return self;
}

- (void)layoutUI {
    [self layoutUIOfSelf];
    [self layoutUIOfMonitorWindow];
    [self layoutUIOfMonitorLabel];
    [self layoutUIOfDisplayLink];
}

- (void)layoutUIOfSelf {
    self.screenUpdatesCount = 0;
    self.screenUpdatesBeginTime = 0.0f;
    self.averageScreenUpdatesTime = 0.017f;
}

- (void)layoutUIOfMonitorWindow {
    [self.monitorWindow class];
}

- (void)layoutUIOfMonitorLabel {
    [self.monitorWindow addSubview:self.monitorLabel];
}

- (void)layoutUIOfDisplayLink {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)layoutUIOfObserves {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunchingNotification) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

#pragma mark - Notifications
- (void)applicationDidBecomeActiveNotification {
    _displayLink.paused = NO;
}

- (void)applicationWillResignActiveNotification {
    _displayLink.paused = YES;
}

- (void)applicationDidFinishLaunchingNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf layoutUI];
        });
    } else {
        [self layoutUI];
    }
}

#pragma mark - displayLink
- (void)displayLinkTick {
    if (self.screenUpdatesBeginTime == 0.0f) {
        self.screenUpdatesBeginTime = _displayLink.timestamp;
    } else {
        self.screenUpdatesCount += 1;
        
        CFTimeInterval screenUpdatesTime = self.displayLink.timestamp - self.screenUpdatesBeginTime;
        
        if (screenUpdatesTime >= 1.0) {
            CFTimeInterval updatesOverSecond = screenUpdatesTime - 1.0f;
            int framesOverSecond = updatesOverSecond / self.averageScreenUpdatesTime;
            
            self.screenUpdatesCount -= framesOverSecond;
            if (self.screenUpdatesCount < 0) {
                self.screenUpdatesCount = 0;
            }
            
            [self takeReadings];
        }
    }
}

- (void)takeReadings {
    int fps = self.screenUpdatesCount;
    float cpu = [self cpuUsage];
    
    self.screenUpdatesCount = 0;
    self.screenUpdatesBeginTime = 0.0f;
    
    [self.monitorLabel updateTextWithFPS:fps CPU:cpu];
}

- (float)cpuUsage {
    kern_return_t kern;
    
    thread_array_t threadList;
    mach_msg_type_number_t threadCount;
    
    thread_info_data_t threadInfo;
    mach_msg_type_number_t threadInfoCount;
    
    thread_basic_info_t threadBasicInfo;
    uint32_t threadStatistic = 0;
    
    kern = task_threads(mach_task_self(), &threadList, &threadCount);
    if (kern != KERN_SUCCESS) {
        return -1;
    }
    if (threadCount > 0) {
        threadStatistic += threadCount;
    }
    
    float totalUsageOfCPU = 0;
    
    for (int i = 0; i < threadCount; i++) {
        threadInfoCount = THREAD_INFO_MAX;
        kern = thread_info(threadList[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount);
        if (kern != KERN_SUCCESS) {
            return -1;
        }
        
        threadBasicInfo = (thread_basic_info_t)threadInfo;
        
        if (!(threadBasicInfo -> flags & TH_FLAGS_IDLE)) {
            totalUsageOfCPU = totalUsageOfCPU + threadBasicInfo -> cpu_usage / (float)TH_USAGE_SCALE * 100.0f;
        }
    }
    
    kern = vm_deallocate(mach_task_self(), (vm_offset_t)threadList, threadCount * sizeof(thread_t));
    
    return totalUsageOfCPU;
}

#pragma mark - private
- (void)dealloc {
    [self endDisplayLink];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)endDisplayLink {
    _displayLink.paused = YES;
    [_displayLink invalidate];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    _displayLink = nil;
}

#pragma mark - lazy
- (MFPSMonitorWindow *)monitorWindow {
    if (nil == _monitorWindow) {
        _monitorWindow = [[MFPSMonitorWindow alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 20.0)];
    }
    return _monitorWindow;
}

- (MFPSMonitorLabel *)monitorLabel {
    if (nil == _monitorLabel) {
        _monitorLabel = [[MFPSMonitorLabel alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width - 45) / 2.0 + 40, 0, 50, 20)];
    }
    return _monitorLabel;
}


@end
#endif
