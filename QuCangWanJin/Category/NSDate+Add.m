//
//  NSDate+Add.m
//  MelonTheater
//
//  Created by 陈志远 on 2024/1/5.
//

#import "NSDate+Add.h"

@implementation NSDate (Add)

+ (NSString *)getYesterdayDateString {
    // 获取当前日期
    NSDate *currentDate = [NSDate date];
    
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 计算前一天
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1]; // 减去1天
    NSDate *yesterday = [calendar dateByAddingComponents:components toDate:currentDate options:0];
    
    // 格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *yesterdayString = [formatter stringFromDate:yesterday];
    
    return yesterdayString;
}

+ (NSString *)getCurrentDayYearMonthDay {
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    
    // 创建日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; // 设置日期格式为年-月
    
    // 获取年月字符串
    NSString *yearMonth = [dateFormatter stringFromDate:currentDate];
    return yearMonth;
}

+ (NSString *)getCurrentHHmmTime {
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    
    // 创建日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    // 获取年月字符串
    NSString *yearMonth = [dateFormatter stringFromDate:currentDate];
    return yearMonth;
}

+ (NSString *)getCurrentTime {
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    
    // 创建日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    // 获取年月字符串
    NSString *yearMonth = [dateFormatter stringFromDate:currentDate];
    return yearMonth;
}

+ (NSString *)getMMddHHmmDate {
    NSDate *currentDate = [NSDate date];
    
    // 创建日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    // 获取年月字符串
    NSString *yearMonth = [dateFormatter stringFromDate:currentDate];
    return yearMonth;
}

+ (BOOL)isCurrentTimeRangestartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSString *timeString = [self getCurrentTime];
    
    // 创建日期格式器
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; // 设置时间格式为小时:分钟
    
    // 解析时间字符串
    NSDate *time = [dateFormatter dateFromString:timeString];
    NSDate *start = [dateFormatter dateFromString:startTime];
    NSDate *end = [dateFormatter dateFromString:endTime];

    
    // 判断当前时间是否在指定时间区间内
    NSTimeInterval timeInterval = [time timeIntervalSince1970];
    NSTimeInterval startInterval = [start timeIntervalSince1970];
    NSTimeInterval endInterval = [end timeIntervalSince1970];
    if (timeInterval >= startInterval && timeInterval <= endInterval) {
        return YES;
    }
    return NO;
}

+ (BOOL)determineSizeEndTime:(NSString *)endTime {
    // 创建两个日期对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"]; // 设置日期格式为年-月-日 时:分:秒
    
    NSString *timeString = [self getCurrentTime];
    
    NSDate *date1 = [dateFormatter dateFromString:timeString];
    NSDate *date2 = [dateFormatter dateFromString:endTime];
    
    // 比较两个日期对象的大小
    if ([date1 compare:date2] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}



+ (NSString *)formatCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)getCurrentTimestamp {
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timestamp = [currentDate timeIntervalSince1970];
    return SF(@"%.0f",timestamp);
}

+ (NSString *)convertSeconds:(NSInteger)totalSeconds {
    NSInteger minutes = totalSeconds / 60;
    NSInteger seconds = totalSeconds % 60;
    
    // 或者使用字符串格式化
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    return timeString;
}



@end
