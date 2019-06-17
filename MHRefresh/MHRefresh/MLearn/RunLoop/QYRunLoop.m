//
//  QYRunLoop.m
//  MHRefresh
//
//  Created by panle on 2019/6/17.
//  Copyright © 2019 developer. All rights reserved.
//

#import "QYRunLoop.h"

@implementation QYRunLoop

/**
  事件循环
 
  runloop 做的事 就是事件的循环
 
 1 让程序一直运行并接受用户输入
 2 决定程序在何时该处理哪些event
 3 调用解耦
 4 节省CPU时间
 
 NSRunLoop -  CFRunloop（C 语言 开源 ）
 底层  -- GCD、mach kerner(苹果内核)、block、pthread...
 
 NSTimer UIEvent Autorelease NSObject(perfrom、Addition)  CADisplayLink CATransition CAAnimation dispatch_get_main_queue()  NSURLConnection AFNetworking
 
 CFRunLoopSource 抽象数据源  source0:处理app内部事件、App自己负责管理(触发)UIEvent、CFSocket  source1:mach port （进程间的轻量级通信系统）
 
 RunLoop 在同一时段只能且必须在一种特定的Mode Run
 更换Mode时，需要停止当前Loop,然后重启Loop  不识线程的销毁，是单纯的对while进行重新条件循环
 Mode是iOS App滑动顺畅的关键
 可以定制自己的Mode
 NSDefaultRunLoopMode  一个空闲的状态，默认状态
 UITrackingRunLoopMode  滑动中的mode
 UIIniaialiazationRunLoopModel   私有，App启动时
 NSRunLoopCommondModes  一个Mode的集合
 
 若不希望Timer被scrollView影响，需要添加到NSRunLoopCommentModes状态下
 
 GCD会用runloop调起主线程  GCD中的dispatch到main queue的block被分发到main RunLoop中执行
 
 CPU空闲时暂停程序
 1 指定用于唤醒的mach_port端口
 2 调用mach_msg监听唤醒端口，被唤醒前，系统内核将这个线程挂起，停留在mach_msg_trap状态
 3 另一个线程向内核发送这个端口的msg后，trap状态被唤醒，RunLoop继续开始干活
 
 接到Crash的Singnal后手动重启RunLoop
 
 
 */

@end
