//
//  MTServiceUtils.h
//  MelonTheater
//
//  Created by 陈志远 on 2023/12/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QCServiceUtils : NSObject

+ (NSString *)getRequestSignatureWithParam:(NSDictionary *)param timestamp:(NSString *)timestamp;
+ (NSData *)requestParamToRSAData:(NSDictionary *)param;
+ (NSData *)requestParamToData:(NSDictionary *)param;
+ (NSDictionary *)requestDefaultParam;
+ (NSDictionary *)mergeRequestParameters:(NSDictionary *)param;
+ (NSString *)nowTimeInterval;
+ (NSString *)requestParamToRSAJson:(NSDictionary *)param ;


@end

NS_ASSUME_NONNULL_END
