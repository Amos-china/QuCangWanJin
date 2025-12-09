//
//  ThreadUtils.m
//  Mudcon
//
//  Created by 陈志远 on 2025/6/26.
//

#import "ThreadUtils.h"

@implementation ThreadUtils

+ (void)onUiThreadDelay:(float)delay onCompletion:(dispatch_block_t)onCompletion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(),onCompletion);
}

+ (void)onUiThreadCompletion:(dispatch_block_t)onCompletion {
    dispatch_async(dispatch_get_main_queue(), onCompletion);
}

+ (void)onAsyncGlobalQueueDelay:(float)delay onCompletion:(dispatch_block_t)onCompletion {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)); // 延迟3秒
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); // 获取一个全局并发队列，也可以使用串行队列
    dispatch_after(time, queue, onCompletion);
}

@end
