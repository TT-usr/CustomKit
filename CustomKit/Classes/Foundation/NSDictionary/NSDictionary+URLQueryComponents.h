//
//  NSDictionary+URLQueryComponents.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (URLQueryComponents)

/// 将字典转为 key1=value1&key2=value2&key3=value3 形式，只能转 字符串和数字。
- (NSString *)stringFromQueryComponents;

@end
