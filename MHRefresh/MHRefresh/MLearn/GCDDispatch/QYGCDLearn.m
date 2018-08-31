//
//  QYGCDLearn.m
//  MHRefresh
//
//  Created by panle on 2018/7/5.
//  Copyright © 2018年 developer. All rights reserved.
//

#import "QYGCDLearn.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation QYGCDLearn

+ (void)test {
//    [self serialQueue];
//    [self dispatch_set_target_queuetest];
//    [self disptch_grouptest];
    [self dispatch_semphoretest];
}

+ (void)serialQueue {
    
//    dispatch_queue_t queue = dispatch_queue_create("serial queue", NULL);
    dispatch_queue_t queue = dispatch_queue_create("serial queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"1");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"2");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"3");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"4");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"5");
    });
}

+ (void)dispatch_set_target_queuetest {
    dispatch_queue_t queue1 = dispatch_queue_create("serial queue", NULL);
    dispatch_queue_t queue2 = dispatch_queue_create("serial queue", NULL);
    dispatch_queue_t queue3 = dispatch_queue_create("serial queue", NULL);
    dispatch_queue_t queue4 = dispatch_queue_create("serial queue", NULL);
    dispatch_queue_t queue5 = dispatch_queue_create("serial queue", NULL);
    dispatch_queue_t queue6 = dispatch_queue_create("serial queue", NULL);
    
    dispatch_set_target_queue(queue1, dispatch_get_main_queue());
    dispatch_set_target_queue(queue2, dispatch_get_main_queue());
    dispatch_set_target_queue(queue3, dispatch_get_main_queue());
    dispatch_set_target_queue(queue4, dispatch_get_main_queue());
    dispatch_set_target_queue(queue5, dispatch_get_main_queue());
    dispatch_set_target_queue(queue6, dispatch_get_main_queue());
    
    dispatch_async(queue1, ^{
        NSLog(@"1");
    });
    dispatch_async(queue2, ^{
        NSLog(@"2");
    });
    dispatch_async(queue3, ^{
        NSLog(@"3");
    });
    dispatch_async(queue4, ^{
        NSLog(@"4");
    });
    dispatch_async(queue5, ^{
        NSLog(@"5");
    });
    dispatch_async(queue6, ^{
        NSLog(@"6");
    });
}

+ (void)disptach_aftertest {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
}

+ (void)disptch_grouptest {
    dispatch_queue_t queue = dispatch_queue_create("serial queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("serial queue", NULL);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"1");
    });
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"2");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"3");
    });
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"4");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"5");
    });
    
    dispatch_group_async(group, queue1, ^{
        NSLog(@"6");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"done");
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"test");
}

+ (void)dispatch_semphoretest {
    
    dispatch_queue_t queue = dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    __block NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 10000; i++) {
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        
        dispatch_async(queue, ^{
            [array addObject:[NSNumber numberWithInteger:i]];
            dispatch_semaphore_signal(semaphore);
        });

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSLog(@"%d", i);
    }
    
    NSLog(@"%@", array);
    
}

+ (void)dispatchiotest {
    
    dispatch_queue_t pipe_q = dispatch_queue_create("queue", NULL);
    
    dispatch_fd_t fd;
    
    int *out_fd;
    
    int fdpair[2];
    
    dispatch_io_t pipe_channel = dispatch_io_create(DISPATCH_IO_STREAM, fd, pipe_q, ^(int error) {
        close(fd);
    });
    
    *out_fd = fdpair[1];
    
//    // 该函数设定一次读取的大小（分割大小）
//    dispatch_io_set_low_water(pipe_channel, SIZE_MAX);
//    //
//    dispatch_io_read(pipe_channel, 0, SIZE_MAX, pipe_q, ^(bool done, dispatch_data_t pipedata, int err){
//        if (err == 0) // err等于0 说明读取无误
//        {
//            // 读取完“单个文件块”的大小
//            size_t len = dispatch_data_get_size(pipedata);
//            if (len > 0)
//            {
//                // 定义一个字节数组bytes
//                const char *bytes = NULL;
//                char *encoded;
//
//                dispatch_data_t md = dispatch_data_create_map(pipedata, (const void **)&bytes, &len);
//                encoded = asl_core_encode_buffer(bytes, len);
//                asl_set((aslmsg)merged_msg, ASL_KEY_AUX_DATA, encoded);
//                free(encoded);
//                _asl_send_message(NULL, merged_msg, -1, NULL);
//                asl_msg_release(merged_msg);
//                dispatch_release(md);
//            }
//        }
//
//        if (done)
//        {
//            dispatch_semaphore_signal(sem);
//            dispatch_release(pipe_channel);
//            dispatch_release(pipe_q);
//        }
//    });
}

+ (void)dispatchsourcequeuetest {
    
    __block size_t total = 0;
    size_t size = 1024;
    char *buff = (char *)malloc(size);
    
    int sockfd;
    
    /* 设定为异步映像 */
    fcntl(sockfd, 100, O_NONBLOCK);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, sockfd, 0, queue);
    
    dispatch_source_set_event_handler(queue, ^{
       
        //获取可读取的字节数
        size_t available = dispatch_source_get_data(source);
        
        //从映像中读取
        int length = read(sockfd, buff, available);
        
        //发生错误时取消
        if (length < 0) {
            
            dispatch_source_cancel(source);
        }
        
        total += length;
        
        if (total == size) {
            
            //code
            
            dispatch_source_cancel(source);
        }
        
    });
    
    dispatch_source_set_cancel_handler(source, ^{
        //code
    });
    
    dispatch_resume(source);
}

+ (void)dispatchsourcequeuetest1 {
    
    
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(source, dispatch_time(DISPATCH_TIME_NOW, 15ull * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1ull * NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(source, ^{
       
        //code
        
        dispatch_source_cancel(source);
    });
    
    dispatch_source_set_cancel_handler(source, ^{
       //code
    });
    dispatch_resume(source);
}

@end
