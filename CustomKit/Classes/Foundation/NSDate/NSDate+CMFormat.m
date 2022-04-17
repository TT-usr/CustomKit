//
//  NSDate+CMFormat.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSDate+CMFormat.h"

NSString * getFormatString(CMDateFormatType formatType);

@implementation NSDate (CMFormat)

- (NSDateFormatter *)cm_dateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *_dateFormatter2 = nil;
    dispatch_once(&onceToken, ^{
        _dateFormatter2 = [[NSDateFormatter alloc] init];
        _dateFormatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    });
    return _dateFormatter2;
}

#pragma mark - public

- (NSString *)cm_stringWithDateFormat:(CMDateFormatType)format
{
    return [self cm_stringWithDateFormatString:getFormatString(format)];
}

- (NSString *)cm_stringWithDateFormatString:(NSString *)dateFormatString
{
    [self.cm_dateFormatter setDateFormat:dateFormatString];
    NSString *date_time = [NSString stringWithString:[self.cm_dateFormatter stringFromDate:self]];
    return date_time;
}

@end

@implementation NSString (CMFormat)

- (NSDateFormatter *)cm_dateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *_dateFormatter2 = nil;
    dispatch_once(&onceToken, ^{
        _dateFormatter2 = [[NSDateFormatter alloc] init];
        _dateFormatter2.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    });
    return _dateFormatter2;
}

#pragma mark - public

- (NSDate *)cm_dateWithDateFormat:(CMDateFormatType)format
{
    return [self cm_dateWithDateFormatString:getFormatString(format)];
}

- (NSDate *)cm_dateWithDateFormatString:(NSString *)dateFormatString
{
    [self.cm_dateFormatter setDateFormat:dateFormatString];
    NSDate *date = [self.cm_dateFormatter dateFromString:self];
    return date;
}

- (NSString *)cm_stringConverToDateFormat:(CMDateFormatType)toFormat
                        fromDateFormat:(CMDateFormatType)fromFormat
{
    return [self cm_stringConverToDateFormatString:getFormatString(toFormat)
                              fromDateFormatString:getFormatString(fromFormat)];
}

- (NSString *)cm_stringConverToDateFormatString:(NSString *)toFormatString
                           fromDateFormatString:(NSString *)fromFormatString
{
    NSDate *date = [self cm_dateWithDateFormatString:fromFormatString];
    return [date cm_stringWithDateFormatString:toFormatString];
}

@end

NSString *getFormatString(CMDateFormatType formatType) {
    NSString *formatString;
    switch (formatType) {
        case CMDateFormatTypeAll:
            formatString = @"yyyy-MM-dd HH:mm:ss:SS";
            break;
        case CMDateFormatTypeAllOther:
            formatString = @"yyyy-MM-dd HH:mm:ss.SS";
            break;
        case CMDateFormatTypeDateAndTime:
            formatString = @"yyyy-MM-dd HH:mm:ss";
            break;
        case CMDateFormatTypeDateAndMinite:
            formatString = @"yyyy-MM-dd HH:mm";
            break;
        case CMDateFormatTypeTime:
            formatString = @"HH:mm:ss";
            break;
        case CMDateFormatTypePreciseTime:
            formatString = @"HH:mm:ss:SS";
            break;
        case CMDateFormatTypeYearMonthDay:
            formatString = @"yyyy-MM-dd";
            break;
        case CMDateFormatTypeYearMonthDayOther:
            formatString = @"yyyy年MM月dd日";
            break;
        case CMDateFormatTypeYearMonth:
            formatString = @"yyyy-MM";
            break;
        case CMDateFormatTypeMonthDay:
            formatString = @"MM-dd";
            break;
    }
    return formatString;
}
