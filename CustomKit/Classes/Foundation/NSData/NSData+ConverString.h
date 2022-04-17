//
//  NSData+ConverString.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ConverString)

/// 将NSData的字节流转换为16进制字符串
- (NSString *)hexadecimalString;

@end

NS_ASSUME_NONNULL_END
