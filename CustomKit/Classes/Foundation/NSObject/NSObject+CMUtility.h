//
//  NSObject+CMUtility.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CM_FreeBlock)(id unsafeSelf);

@interface NSObject (CMUtility)

/// 对objc做类型判断,属于当前类返回objc,否则返回nil
+ (nullable instancetype)cm_cast:(id _Nullable)objc;

/// 当前类实例释放`后`执行这个block
- (void)cm_deallocBlock:(CM_FreeBlock)deallocBlock;

@end

NS_ASSUME_NONNULL_END
