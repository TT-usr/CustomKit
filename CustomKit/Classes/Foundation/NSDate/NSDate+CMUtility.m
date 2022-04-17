//
//  NSDate+CMUtility.m
//  MMBaseFoundation
//
//  Created by zhangzhenwei on 2021/8/21.
//

#import "NSDate+CMUtility.h"
#import "NSDate+Utilities.h"
#import "NSDate+CMFormat.h"

#define TEXT_N_MIN_AGO          @"%d分钟前"
#define TEXT_N_HOUR_AGO         @"%d小时前"
#define TEXT_N_DAY_AGO          @"%d天前"
#define TEXT_CHATCELL_YESTODAY  @"昨天"

#define MaxLoginInterval 30 * 24 * 60 * 60

@implementation NSDate (CMUtility)

+ (NSString *)dateIntervalFriendly:(NSDate *)date
{
    NSTimeInterval timesec = [date timeIntervalSince1970];
    if (timesec <= 1) {
        return @"";
    }
    
    NSDate *now = [NSDate date];
    NSDateComponents *compsNow = [now cm_dateComponents];
    NSDateComponents *compsDate = [date cm_dateComponents];
    NSInteger seconds = [now timeIntervalSinceDate:date];
    
    if (seconds < 60 * 60 && seconds > 0) {
        //一个小时内
        NSInteger mins = MAX(1, seconds/60);
        return [NSString stringWithFormat:TEXT_N_MIN_AGO, (int)mins];
    } else if (compsDate.day == compsNow.day && compsDate.month == compsNow.month && compsDate.year == compsNow.year) {
        //同一天内
        return [date cm_stringWithDateFormatString:@"HH:mm"];
    } else if (compsNow.day - compsDate.day == 1 && compsDate.month == compsNow.month && compsDate.year == compsNow.year) {
        //昨天
        return [NSString stringWithFormat:@"%@ %@", TEXT_CHATCELL_YESTODAY, [date cm_stringWithDateFormatString:@"HH:mm"]];
    } else {
        if (compsDate.year == compsNow.year) {
            return [date cm_stringWithDateFormatString:@"MM-dd"];
        } else {
            return [date cm_stringWithDateFormatString:@"yyyy-MM-dd"];
        }
    }
}

+ (NSString *)dateIntervalSinceNow:(NSDate *)date
{
    if (!date) {
        return @"未知";
    }
    NSInteger seconds = [[NSDate date] timeIntervalSinceDate:date];
    if (seconds < 3600 && seconds >= 0) {
        //1h
        NSInteger mins = MAX(1, seconds/60);
        return [NSString stringWithFormat:TEXT_N_MIN_AGO, (int)mins];
    } else if (seconds < 86400) {
        return [NSString stringWithFormat:TEXT_N_HOUR_AGO, (int)seconds/3600];
    } else if (seconds >= 86400 && seconds <= MaxLoginInterval) {
        //86400 == 1d, 86400*15000 means the 1970-1-1, which is default invalid value
        return [NSString stringWithFormat:TEXT_N_DAY_AGO, (int)seconds/86400];
    } else if (seconds > MaxLoginInterval && seconds <= (86400 * 15000) ) {
        return [NSString stringWithFormat:TEXT_N_DAY_AGO, 30];
    } else {
        return @"未知";
    }
}

+ (NSString *)dateIntervalSinceNowWithoutUnknow:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    NSInteger seconds = 0 - (NSInteger)[date timeIntervalSinceNow];
    if (seconds <= 60) {
        //1min
        return [NSString stringWithFormat:TEXT_N_MIN_AGO, 1];
    } else if (seconds < 3600) {
        //1h
        return [NSString stringWithFormat:TEXT_N_MIN_AGO, (int)seconds / 60];
    } else if (seconds < 86400) {
        return [NSString stringWithFormat:TEXT_N_HOUR_AGO, (int)seconds / 3600];
    } else if (seconds >= 86400 && seconds <= MaxLoginInterval) {
        //86400 == 1d, 86400*15000 means the 1970-1-1, which is default invalid value
        return [NSString stringWithFormat:TEXT_N_DAY_AGO, (int)seconds / 86400];
    } else if (seconds > MaxLoginInterval && seconds <= (86400 * 15000) ) {
        return [NSString stringWithFormat:TEXT_N_DAY_AGO, 30];
    } else {
        return nil;
    }
}

+ (NSString *)dataForChat:(NSDate *)date
{
    // 聊天帧显示规则（8.18C线）
    NSTimeInterval timesec = [date timeIntervalSince1970];
    if (timesec <= 1) {
        return @"";
    }
    
    NSDate *now = [NSDate date];
    NSDateComponents *compsNow = [now cm_dateComponents];
    NSDateComponents *compsDate = [date cm_dateComponents];
    NSInteger seconds = [now timeIntervalSinceDate:date];

    if (seconds < 60 * 60 && seconds > 0) {
        //一个小时内
        NSInteger mins = MAX(1, seconds/60);
        return [NSString stringWithFormat:TEXT_N_MIN_AGO, (int)mins];
    } else if (compsDate.day == compsNow.day && compsDate.month == compsNow.month && compsDate.year == compsNow.year) {
        //同一天内
        return [date cm_stringWithDateFormatString:@"HH:mm"];
    } else if (compsNow.day - compsDate.day == 1 && compsDate.month == compsNow.month && compsDate.year == compsNow.year) {
        //昨天
        return [NSString stringWithFormat:@"%@ %@", TEXT_CHATCELL_YESTODAY, [date cm_stringWithDateFormatString:@"HH:mm"]];
    } else {
        if (compsDate.year == compsNow.year) {
            return [date cm_stringWithDateFormatString:@"MM-dd HH:mm"];
        } else {
            return [date cm_stringWithDateFormatString:@"yyyy-MM-dd HH:mm"];
        }
    }
}

+ (NSString *)sessionUsedTimeStringFromDate:(NSDate *)date
{
    NSTimeInterval interval = [date timeIntervalSince1970];
    if (interval <= 1) {
        return @"";
    }
    
    NSDate *now = [NSDate date];
    NSDateComponents *compsNow = [now cm_dateComponents];
    NSDateComponents *compsDate = [date cm_dateComponents];
    
    if (compsNow.year == compsDate.year) {
        if (compsNow.month == compsDate.month) {
            if (compsNow.day == compsDate.day) {
                return [date cm_stringWithDateFormatString:@"HH:mm"];
            } else if (compsNow.day == (compsDate.day+1)) {
                return @"昨天";
            } else if (compsNow.day == (compsDate.day+2)) {
                return @"前天";
            } else {
                return [date cm_stringWithDateFormatString:@"M-d"];;
            }
        } else {
            return [date cm_stringWithDateFormatString:@"M-d"];
        }
    } else {
        return [date cm_stringWithDateFormatString:@"yyyy-M-d"];
    }
}

+ (NSTimeInterval)intervalFromYear:(NSInteger)year
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    NSDate *newDate =  [[NSDate currentCalendar] dateFromComponents:dateComponents];
    return [newDate timeIntervalSince1970];
}

@end
