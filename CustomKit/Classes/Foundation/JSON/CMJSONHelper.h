//
//  CMJSONHelper.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CMJSONHelper)

/// 将字典转换为JSON字符串，不带换行
- (NSString *)CMJSONString;
- (NSString *)CMJSON2String DEPRECATED_MSG_ATTRIBUTE("请使用[dict CMJSONString]");
- (NSString *)CMJSON2StringNilOptions DEPRECATED_MSG_ATTRIBUTE("请使用[dict CMJSONString]");
- (NSString *)CMJSONStringNOPrettyPrinted DEPRECATED_MSG_ATTRIBUTE("请使用[dict CMJSONString]");

/// 将字典转换为JSON字符串，带换行
- (NSString *)CMJSONStringWithPrettyPrinted;

/// 将字典转换为JSON Data，不带换行
- (nullable NSData *)CMJSONData;

@end



@interface NSArray (CMJSONHelper)

/// 将数组转换为JSON字符串，不带换行
- (NSString *)CMJSONString;
- (NSString *)CMJSON2String DEPRECATED_MSG_ATTRIBUTE("请使用[array CMJSONString]");
- (NSString *)CMJSON2StringNilOptions DEPRECATED_MSG_ATTRIBUTE("请使用[array CMJSONString]");
- (NSString *)CMJSONStringNOPrettyPrinted DEPRECATED_MSG_ATTRIBUTE("请使用[array CMJSONString]");

/// 将字典转换为JSON字符串，带换行
- (NSString *)CMJSONStringWithPrettyPrinted;

/// 将数组转换为JSON Data，不带换行
- (nullable NSData *)CMJSONData;

@end



@interface NSString (CMJSONHelper)

/// 将JSON字符串转换为字典或数组，默认为可变容器
- (nullable id)objectFromJSONString;
- (nullable id)objectFromCMJSONString DEPRECATED_MSG_ATTRIBUTE("请使用[str objectFromJSONString]");

@end



@interface NSData (CMJSONHelper)

/// 将 Data 转换为字典或数组，默认为可变容器
- (nullable id)objectFromJSONData;

@end

NS_ASSUME_NONNULL_END
