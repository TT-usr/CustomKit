//
//  NSArray+CMUtility.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (CMUtility)

/// map函数
- (NSMutableArray *)cm_map:(id _Nullable (^)(ObjectType object, NSUInteger idx))block;

/// 过滤掉数组中的某些元素(与RAC保持一致,YES表示要保留)
- (NSMutableArray<ObjectType> *)cm_filter:(BOOL (^)(ObjectType objc, NSUInteger idx))block;

/// 数组降维(把多维数组降维到一维数组)
- (NSMutableArray<ObjectType> *)cm_flatten;

/// 数组中上一元素的处理结果与当前元素的处理
- (nullable id)cm_reduce:(id _Nullable (^)(id _Nullable lastResult, ObjectType currentValue, NSUInteger idx))block;

- (NSMutableArray<NSMutableArray *> *)cm_zip:(NSArray *)otherArray;

- (void)cm_forEach:(void(^)(ObjectType objc, NSUInteger idx))block;

/// 把数组变为可变数组
- (NSMutableArray<ObjectType> *)cm_mutableArray;

/// 删除某一特定对象,找到一个满足条件的就会删除并停止
- (NSMutableArray<ObjectType> *)cm_removeOneObject:(BOOL(^)(ObjectType object, NSInteger index))conditionBlock;

@end

NS_ASSUME_NONNULL_END
