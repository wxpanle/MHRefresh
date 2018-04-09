//
//  MMonitor.h
//  Memory
//
//  Created by zyx on 2016/10/24.
//  Copyright © 2016年 blueliveMBB. All rights reserved.
//

#ifndef MMonitor_h
#define MMonitor_h

/**
 *
 当应用监测到发生 pop 或者 dismiss 操作的时候，之后很短的时间内对应的 viewController view 应该清除，此时建立一个 weak 属性的对象，间隔一段时间调用方法，如果该方法调用，发生内存泄露。
 
 通过关联对象的手段，绑定一个BOOL值，当发生 pop dismiss 操作的时候，使该BOOL值为YES，在viewDidDisappear中，调用检测方法。
 */


#ifdef DEBUG
#define M_MONITOR_ENABLED 1

#else
#define M_MONITOR_ENABLED 0
#endif

#endif /* MMonitor_h */


