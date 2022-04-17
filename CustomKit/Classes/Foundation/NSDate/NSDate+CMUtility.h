//
//  NSDate+CMUtility.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (CMUtility)

/*
 小于1小时显示“XX分钟前”
 24小时－一个自然天显示“HH:mm”
 一个自然天－两个自然天显示“昨天 HH:mm”
 大于等于两个自然天显示“MM-dd HH:mm”
 */
+ (NSString *)dateIntervalFriendly:(NSDate *)date;

+ (NSString *)dataForChat:(NSDate *)time;

/*
 小于1小时显示“XX分钟前”
 1小时－24小时显示“XX小时前”
 大于24小时显示“XX天前”
 */
+ (NSString *)dateIntervalSinceNow:(NSDate *)date;
// 规则同dateIntervalSinceNow 只是不返回未知
+ (NSString *)dateIntervalSinceNowWithoutUnknow:(NSDate *)date;

/*消息列表使用的时间格式
 */
+ (NSString *)sessionUsedTimeStringFromDate:(NSDate *)date;


+ (NSTimeInterval)intervalFromYear:(NSInteger)year;

@end

NS_ASSUME_NONNULL_END
