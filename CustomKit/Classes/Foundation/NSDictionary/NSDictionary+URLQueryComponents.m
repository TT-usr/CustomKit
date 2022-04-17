//
//  NSDictionary+URLQueryComponents.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSDictionary+URLQueryComponents.h"

@implementation NSDictionary (URLQueryComponents)

- (NSString *)stringFromQueryComponents
{
    NSMutableString *result = nil;
    for (id key in [self allKeys]) {
        NSString *name = nil;
        if ([key isKindOfClass:[NSString class]]) {
            name = key;
        } else if ([key isKindOfClass:[NSNumber class]]) {
            name = [(NSNumber *)key stringValue];
        } else {
            continue;
        }
        
        id valueObject = [self objectForKey:key];
        NSString *value = nil;
        if ([valueObject isKindOfClass:[NSString class]]) {
            value = (NSString *)valueObject;
        } else if ([valueObject isKindOfClass:[NSNumber class]]) {
            value = [(NSNumber *)valueObject stringValue];
        } else {
            continue;
        }
        NSString *percentEncodingValue = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"].invertedSet];
        
        if (!result) {
            result = [NSMutableString string];
        } else {
            [result appendFormat:@"&"];
        }
        [result appendFormat:@"%@=%@", name, percentEncodingValue];
    }
    return [result copy];
}

@end
