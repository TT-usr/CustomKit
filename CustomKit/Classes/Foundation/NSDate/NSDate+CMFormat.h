//
//  NSDate+CMFormat.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, CMDateFormatType) {
    CMDateFormatTypeAll,               // 2014-03-04 13:23:35:67
    CMDateFormatTypeAllOther,          // 2014-03-04 13:23:35.67
    CMDateFormatTypeDateAndTime,       // 2014-03-04 13:23:35
    CMDateFormatTypeDateAndMinite,     // 2014-03-04 13:23

    CMDateFormatTypeTime,              // 13:23:35
    CMDateFormatTypePreciseTime,       // 13:23:35:67

    CMDateFormatTypeYearMonthDay,      // 2014-03-04
    CMDateFormatTypeYearMonthDayOther, // 2014年03月04日
    CMDateFormatTypeYearMonth,         // 2014-03
    CMDateFormatTypeMonthDay,          // 03-04
};

@interface NSDate (CMFormat)

/**
 *  NSDate 转 NSString
 *
 *  @param format 日期格式类型
 *
 *  @return 日期字符串
 */
- (NSString *)cm_stringWithDateFormat:(CMDateFormatType)format;
- (NSString *)cm_stringWithDateFormatString:(NSString *)dateFormatString;

@end

@interface NSString (CMFormat)

/**
 *  NSString 转 NSDate
 *
 *  @param format 日期格式类型
 *
 *  @return NSDate日期
 */
- (NSDate *)cm_dateWithDateFormat:(CMDateFormatType)format;
- (NSDate *)cm_dateWithDateFormatString:(NSString *)dateFormatString;

/**
 *  将某种格式的日期字符串 转 另一种格式的日期字符串
 *
 *  @param toFormat   目标日期格式类型
 *  @param fromFormat 源日期格式类型
 *
 *  @return 转换后的日期字符串
 */
- (NSString *)cm_stringConverToDateFormat:(CMDateFormatType)toFormat
                           fromDateFormat:(CMDateFormatType)fromFormat;
- (NSString *)cm_stringConverToDateFormatString:(NSString *)toFormatString
                           fromDateFormatString:(NSString *)fromFormatString;

@end
