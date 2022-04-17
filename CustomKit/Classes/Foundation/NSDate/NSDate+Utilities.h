/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook 3.x and beyond
 BSD License, Use at your own risk
 https://github.com/erica/NSDate-Extensions
 */

#import <Foundation/Foundation.h>

#define D_MINUTE 60
#define D_HOUR   3600
#define D_DAY    86400
#define D_WEEK   604800
#define D_YEAR   31556926

@interface NSDate (Utilities)

+ (NSCalendar *)currentCalendar;  // avoid bottlenecks

#pragma mark Relative dates from the current date
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateWithDaysAfterNow:(NSInteger)days; //返回 当前时间 + days 的日期
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days; //返回 当前时间 - days 的日期
+ (NSDate *)dateWithHoursAfterNow:(NSInteger)dHours;
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours;
+ (NSDate *)dateWithMinutesAfterNow:(NSInteger)dMinutes;
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes;

#pragma mark Adjusting dates
- (NSDate *)dateByAddingYears:(NSInteger)dYears;   //返回 self + dYears的时间
- (NSDate *)dateBySubtractingYears:(NSInteger)dYears; //返回 self - dYears的时间
- (NSDate *)dateByAddingMonths:(NSInteger)dMonths;
- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonths;
- (NSDate *)dateByAddingDays:(NSInteger)dDays;
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;
- (NSDate *)dateByAddingHours:(NSInteger)dHours;
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours;
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes;

#pragma mark Date extremes
- (NSDate *)cm_dateAtStartOfDay; //获取当天的00：00：00
- (NSDate *)cm_dateAtEndOfDay;   //获取当天的23：59：59
- (NSDate *)cm_dateAtStartOfWeak; //获取当星期一的00：00：00
- (NSDate *)cm_dateAtEndOfWeak;   //获取当星期天的23：59：59
- (NSDate *)cm_dateAtStartOfMonth; //获取当月初的00：00：00
- (NSDate *)cm_dateAtEndOfMonth;   //获取当月末的23：59：59
- (NSDate *)cm_beginDate:(NSCalendarUnit)unit interval:(NSTimeInterval *)interval;

#pragma mark 比较日期
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate; //self 是否和aDate 是同一天
- (BOOL)isToday; //self 是否是今天
- (BOOL)isTomorrow; //self 是否是明天
- (BOOL)isYesterday; //self 是否是昨天

- (BOOL)isSameWeekAsDate:(NSDate *)aDate; //self 是否和aDate 是同一星期
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;

- (BOOL)isSameMonthAsDate:(NSDate *)aDate; //self 是否和aDate 是同一月
- (BOOL)isThisMonth;
- (BOOL)isNextMonth;
- (BOOL)isLastMonth;

- (BOOL)isSameYearAsDate:(NSDate *)aDate; //self 是否和aDate 是同一年
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;

- (BOOL)isEarlierThanDate:(NSDate *)aDate; //self 早于 aDate
- (BOOL)isLaterThanDate:(NSDate *)aDate;  //self 晚于 aDate

- (BOOL)isInFuture; //self 晚于 now
- (BOOL)isInPast; // self 早于 now

#pragma mark 日期角色
- (BOOL)isTypicallyWorkday; //是否是工作日
- (BOOL)isTypicallyWeekend; //是否是周末

#pragma mark 相对日期 的 时间间隔

/// 返回 指定时间 到 self 的时间间隔的分钟数
/// @param aDate 指定时间
- (NSInteger)minutesAfterDate:(NSDate *)aDate;
/// 返回 self 到 指定时间 的时间间隔的分钟数
/// @param aDate 指定时间
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
- (NSInteger)daysAfterDate:(NSDate *)aDate;
- (NSInteger)daysBeforeDate:(NSDate *)aDate;

/// 返回 指定时间 到 self 的时间间隔的 NSDateComponents
/// @param anotherDate 指定时间
- (NSDateComponents *)distanceAfterDate:(NSDate *)anotherDate;
/// 返回 self 到 指定时间 的时间间隔的分钟数
/// @param anotherDate 指定时间
- (NSDateComponents *)distanceBeforeDate:(NSDate *)anotherDate;

#pragma mark 结构日期

- (NSDateComponents *)cm_dateComponents;

@property (readonly) NSInteger cm_nearestHour; //最接近的小时 eg: 3:30返回4， 3:29返回3
@property (readonly) NSInteger cm_hour; //时
@property (readonly) NSInteger cm_minute; //分
@property (readonly) NSInteger cm_seconds; //秒
@property (readonly) NSInteger cm_day;  //月中的第几天
@property (readonly) NSInteger cm_month; //月份
@property (readonly) NSInteger cm_week; //一年中第几个星期
@property (readonly) NSInteger cm_weekday; //星期几
@property (readonly) NSInteger cm_nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger cm_year; //年份

//星座
- (NSString *)cm_constellation;

#pragma mark - 东八区北京时间

+ (NSCalendar *)cm_pekingCalendar;

- (NSDate *)cm_pekingDate; // 把世界时间转换为北京时间

@property (readonly) NSInteger cm_pekingDay;
@property (readonly) NSInteger cm_pekingHour;
@property (readonly) NSInteger cm_pekingMinute;
@property (readonly) NSInteger cm_pekingSeconds;

@end
