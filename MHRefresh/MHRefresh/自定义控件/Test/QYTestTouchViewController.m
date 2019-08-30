//
//  QYTestTouchViewController.m
//  MHRefresh
//
//  Created by panle on 2019/3/15.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYTestTouchViewController.h"
#import "QYTestTouchTableViewCell.h"

void p_runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    switch (activity) {
        case kCFRunLoopAfterWaiting:
            NSLog(@"kCFRunLoopAfterWaiting");
            break;
            
        case kCFRunLoopBeforeSources:
            NSLog(@"kCFRunLoopBeforeSources");
            break;
            
        case kCFRunLoopBeforeWaiting:
            NSLog(@"kCFRunLoopBeforeWaiting");
            break;
            
        case kCFRunLoopBeforeTimers:
            NSLog(@"kCFRunLoopBeforeTimers");
            break;
            
        default:
            break;
    }
}

@interface QYTestTouchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CFRunLoopObserverRef observes;

@end

@implementation QYTestTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
    _observes = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, &p_runLoopObserverCallBack, &context);
    
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observes, kCFRunLoopCommonModes);
    
//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
//
//    _tableView.rowHeight = 60.0;
//
//    [_tableView registerClass:[QYTestTouchTableViewCell class] forCellReuseIdentifier:[QYTestTouchTableViewCell reuseIdentifier]];
//
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//
//    [self.view addSubview:_tableView];
//
//    [_tableView reloadData];
}

//- (void)testrunloop
//{
//    /// 1. 通知Observers，即将进入RunLoop
//    /// 此处有Observer会创建AutoreleasePool: _objc_autoreleasePoolPush();
//    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopEntry);
//    do {
//
//        /// 2. 通知 Observers: 即将触发 Timer 回调。
//        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeTimers);
//        /// 3. 通知 Observers: 即将触发 Source (非基于port的,Source0) 回调。
//        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeSources);
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);
//
//        /// 4. 触发 Source0 (非基于port的) 回调。
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE0_PERFORM_FUNCTION__(source0);
//
//        /// 5. GCD处理main block
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_BLOCK__(block);
//
//        /// 6. 通知Observers，即将进入休眠
//        /// 此处有Observer释放并新建AutoreleasePool: _objc_autoreleasePoolPop(); _objc_autoreleasePoolPush();
//        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopBeforeWaiting);
//
//        /// 7. sleep to wait msg.
//        mach_msg() -> mach_msg_trap();
//
//
//        /// 8. 通知Observers，线程被唤醒
//        __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopAfterWaiting);
//
//        /// 9. 如果是被Timer唤醒的，回调Timer
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_TIMER_CALLBACK_FUNCTION__(timer);
//
//        /// 9. 如果是被dispatch唤醒的，执行所有调用 dispatch_async 等方法放入main queue 的 block
//        __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(dispatched_block);
//
//        /// 9. 如果如果Runloop是被 Source1 (基于port的) 的事件唤醒了，处理这个事件
//        __CFRUNLOOP_IS_CALLING_OUT_TO_A_SOURCE1_PERFORM_FUNCTION__(source1);
//
//
//    } while (YES);
//
//    /// 10. 通知Observers，即将退出RunLoop
//    /// 此处有Observer释放AutoreleasePool: _objc_autoreleasePoolPop();
//    __CFRUNLOOP_IS_CALLING_OUT_TO_AN_OBSERVER_CALLBACK_FUNCTION__(kCFRunLoopExit);
//}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYTestTouchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QYTestTouchTableViewCell reuseIdentifier] forIndexPath:indexPath];
    cell.up_indexPath = indexPath;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

@end
