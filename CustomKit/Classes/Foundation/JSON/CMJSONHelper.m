//
//  CMJSONHelper.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "CMJSONHelper.h"

@implementation NSDictionary (CMJSONHelper)

- (NSString *)CMJSONString {
    NSData *jsonData = [NSJSONSerialization isValidJSONObject:self] ? [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil] : nil;
    NSString *jsonString = @"{}";
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *)CMJSON2String {
    return [self CMJSONString];
}

- (NSString *)CMJSON2StringNilOptions {
    return [self CMJSONString];
}

- (NSString *)CMJSONStringNOPrettyPrinted {
    return [self CMJSONString];
}

- (NSString *)CMJSONStringWithPrettyPrinted {
    NSData *jsonData = [NSJSONSerialization isValidJSONObject:self] ? [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] : nil;
    NSString *jsonString = @"{}";
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSData *)CMJSONData {
    NSData *jsonData = [NSJSONSerialization isValidJSONObject:self] ? [NSJSONSerialization dataWithJSONObject:self options:0 error:nil] : nil;
    return jsonData;
}

@end

@implementation NSArray (CMJSONHelper)

- (NSString *)CMJSONString
{
    NSData *jsonData = [NSJSONSerialization isValidJSONObject:self]?[NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:nil]:nil;
    NSString *jsonString = @"[]";
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSString *)CMJSON2String {
    return [self CMJSONString];
}

- (NSString *)CMJSON2StringNilOptions {
    return [self CMJSONString];
}

- (NSString *)CMJSONStringNOPrettyPrinted {
    return [self CMJSONString];
}

- (NSString *)CMJSONStringWithPrettyPrinted {
    NSData *jsonData = [NSJSONSerialization isValidJSONObject:self] ? [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] : nil;
    NSString *jsonString = @"[]";
    if (jsonData) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (NSData *)CMJSONData {
    NSData *jsonData = [NSJSONSerialization isValidJSONObject:self] ? [NSJSONSerialization dataWithJSONObject:self options:0 error:nil] : nil;
    return jsonData;
}

@end

@implementation NSString (CMJSONHelper)

- (id)objectFromJSONString {
    NSData *dataString = [self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = nil;
    if (dataString) {
        jsonObject = [NSJSONSerialization JSONObjectWithData:dataString options:NSJSONReadingMutableContainers error:nil];
    }
    return jsonObject;
}

- (id)objectFromCMJSONString {
    return [self objectFromJSONString];
}

@end

@implementation NSData (CMJSONHelper)

- (id)objectFromJSONData {
    id jsonObject = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
    return jsonObject;
}

@end
