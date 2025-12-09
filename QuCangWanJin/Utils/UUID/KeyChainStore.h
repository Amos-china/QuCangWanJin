//
//  KeyChainStore.h
//  XiaoGongJiang
//
//  Created by 健健 on 2019/7/5.
//  Copyright © 2019年 JianJian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainStore : NSObject
+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;
@end

NS_ASSUME_NONNULL_END
