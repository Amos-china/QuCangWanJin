//
//  MTCachManager.h
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTCachManager : NSObject

+ (NSString *)getCachSize;
+ (void)cleanCach;

+ (NSString *)getSDWebImageCache;
+ (void)clearSDWebImageCache:(void(^)(void))clearBlock;

@end

NS_ASSUME_NONNULL_END
