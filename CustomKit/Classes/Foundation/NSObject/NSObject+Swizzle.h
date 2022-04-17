//
//  NSObject+Swizzle.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)

/// 交换实例方法。
+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector;

/// 交换类方法。
+ (void)swizzleClassSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector;

/// 用block作为新方法实现交换实例方法。block的参数、返回值类型需要与原方法一致。
+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector newImpBlock:(id)block;

/// 用block作为新方法实现交换类方法。block的参数、返回值类型需要与原方法一致。
+ (void)swizzleClassSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector newImpBlock:(id)block;

@end
