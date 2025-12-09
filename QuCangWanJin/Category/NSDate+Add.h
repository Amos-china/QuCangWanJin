//
//  NSDate+Add.h
//  MelonTheater
//
//  Created by 陈志远 on 2024/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Add)

+ (NSString *)getYesterdayDateString;
+ (NSString *)getCurrentDayYearMonthDay;
+ (NSString *)getCurrentTime;
+ (BOOL)isCurrentTimeRangestartTime:(NSString *)startTime endTime:(NSString *)endTime;
+ (BOOL)determineSizeEndTime:(NSString *)endTime;
+ (NSString *)getMMddHHmmDate;
+ (NSString *)formatCurrentTime;
+ (NSString *)getCurrentHHmmTime;
+ (NSString *)getCurrentTimestamp;
+ (NSString *)convertSeconds:(NSInteger)totalSeconds;

@end

NS_ASSUME_NONNULL_END
