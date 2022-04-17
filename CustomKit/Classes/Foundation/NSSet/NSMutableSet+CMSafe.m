//
//  NSMutableSet+CMSafe.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSMutableSet+CMSafe.h"
#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSMutableSet (CMSafe)

#pragma mark - safe hook -

+ (void)load {
#ifdef DISTRIBUTION
    [objc_getClass("__NSSetM") swizzleInstanceSelector:@selector(addObject:) withNewSelector:@selector(cm_safeAddObject:)];
    [objc_getClass("__NSSetM") swizzleInstanceSelector:@selector(removeObject:) withNewSelector:@selector(cm_safeRemoveObject:)];
#endif
}

- (void)cm_safeAddObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self cm_safeAddObject:anObject];
}

- (void)cm_safeRemoveObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self cm_safeRemoveObject:anObject];
}

#pragma mark - other -

// 排除nil
- (void)addObjectSafe:(id)object
{
    if (object) {
        [self addObject:object];
    }
}

- (void)removeObjectSafe:(id)object
{
    if (object) {
        [self removeObject:object];
    }
}

@end
