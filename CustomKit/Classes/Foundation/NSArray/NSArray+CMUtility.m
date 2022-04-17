//
//  NSArray+CMUtility.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSArray+CMUtility.h"

@implementation NSArray (CMUtility)

- (NSMutableArray *)cm_map:(id (^)(id, NSUInteger))block {
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = block ? block(obj, idx) : nil;
        if (value) {
            [mutArr addObject:value];
        }
    }];
    return mutArr;
}

- (NSMutableArray *)cm_filter:(BOOL (^)(id objc, NSUInteger idx))block {
    if (!block) return self.cm_mutableArray;
    
    NSMutableArray *filteredMutArr = @[].mutableCopy;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isPass = block(obj, idx);
        isPass ? [filteredMutArr addObject:obj] : NULL;
    }];
    return filteredMutArr;
}

- (NSMutableArray *)cm_flatten {
    NSMutableArray *flattenedMutArray = @[].mutableCopy;
    for (id value in self) {
        if ([value isKindOfClass:[NSArray class]]) {
            [flattenedMutArray addObjectsFromArray:[(NSArray *)value cm_flatten]];
        }
        else {
            [flattenedMutArray addObject:value];
        }
    }
    return flattenedMutArray;
}

- (id)cm_reduce:(id(^)(id lastResult, id currentValue, NSUInteger idx))block {
    __block id result = nil;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result = block(result, obj, idx);
    }];
    return result;
}

- (NSMutableArray<NSMutableArray *> *)cm_zip:(NSArray *)otherArray {
    NSMutableArray *resultArr = @[].mutableCopy;
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id otherValue = (idx < otherArray.count) ? otherArray[idx] : nil;
        if (otherValue) {
            NSMutableArray *tempArr = @[].mutableCopy;
            [tempArr addObject:obj];
            [tempArr addObject:otherValue];
            
            [resultArr addObject:tempArr];
        } else {
            *stop = YES;
        }
    }];
    return resultArr;
}

- (void)cm_forEach:(void(^)(id objc, NSUInteger idx))block {
    if (!block) return;
    
    NSUInteger index = 0;
    for (id obj in self) {
        block(obj, index++);
    }
}

- (NSMutableArray *)cm_mutableArray {
    if ([self isKindOfClass:[NSMutableArray class]]) {
        return (NSMutableArray *)self;
    }
    else {
        return [NSMutableArray arrayWithArray:self];
    }
}

- (NSMutableArray *)cm_removeOneObject:(BOOL(^)(id object, NSInteger index))conditionBlock {
    NSMutableArray *mutArr = self.cm_mutableArray;
    if (!conditionBlock) return mutArr;
    
    [mutArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL finded = conditionBlock(obj, idx);
        if (finded) {
            [mutArr removeObject:obj];
        }
        *stop = finded;
    }];
    return mutArr;
}

@end
