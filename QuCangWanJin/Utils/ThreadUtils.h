//
//  ThreadUtils.h
//  Mudcon
//
//  Created by 陈志远 on 2025/6/26.
//

#import "QCBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThreadUtils : QCBaseModel

+ (void)onUiThreadDelay:(float)delay onCompletion:(dispatch_block_t)onCompletion;

+ (void)onUiThreadCompletion:(dispatch_block_t)onCompletion;

+ (void)onAsyncGlobalQueueDelay:(float)delay onCompletion:(dispatch_block_t)onCompletion;

@end

NS_ASSUME_NONNULL_END
