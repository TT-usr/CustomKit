//
//  NSObject+Swizzle.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSObject+Swizzle.h"
#import <objc/runtime.h>

@implementation NSObject (Swizzle)

static void swizzleInstanceMethod(Class class, SEL originalSelector, SEL newSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    if (originalMethod && newMethod) {
        IMP originalImp = method_getImplementation(originalMethod);
        IMP newImp = method_getImplementation(newMethod);
        const char *originalTypeEncoding = method_getTypeEncoding(originalMethod);
        const char *newTypeEncoding = method_getTypeEncoding(newMethod);
        BOOL addOriginal = class_addMethod(class, originalSelector, newImp, newTypeEncoding);
        BOOL addNew = class_addMethod(class, newSelector, originalImp, originalTypeEncoding);
        if (addOriginal && !addNew) {
            // 原方法是父类方法，已将新方法实现添加到本类；新方法是本类方法，需要将实现换为老方法实现。场景如在子类中添加了新方法，替换继承自父类的方法。
            class_replaceMethod(class, newSelector, originalImp, originalTypeEncoding);
        } else if (!addOriginal && addNew) {
            // 新方法是父类方法，已将原方法实现添加到本类；原方法是本类方法，需要将实现换为新方法实现。场景如子类不可见，需要通过父类category添加新方法，替换子类的方法。
            class_replaceMethod(class, originalSelector, newImp, newTypeEncoding);
        } else if (!addOriginal && !addNew) {
            // 原方法、新方法都是本类方法，需要将实现互换。场景如在category中添加了新方法，替换类原有的方法。
            method_exchangeImplementations(originalMethod, newMethod);
        }
        // else 原方法、新方法都是父类方法，已将方法实现交换添加到本类。场景如子类不可见，需要通过父类category添加新方法，替换继承自父类的方法。
    } else {
#ifdef DEBUG
        NSString *msg = nil;
        NSString *methodType = class_isMetaClass(class) ? @"class" : @"instance";
        if (!originalMethod && !newMethod) {
            // 原方法、新方法在本类和父类都不存在，无法替换。
            msg = [NSString stringWithFormat:@"Try swizzle %@ method %@ with %@ of class %@, but %@ and %@ both are not exist.", methodType, NSStringFromSelector(originalSelector), NSStringFromSelector(newSelector), class, NSStringFromSelector(originalSelector), NSStringFromSelector(newSelector)];
        } else if (!originalMethod) {
            // 原方法在本类和父类都不存在，无法替换。
            msg = [NSString stringWithFormat:@"Try swizzle %@ method %@ with %@ of class %@, but original method %@ is not exist.", methodType, NSStringFromSelector(originalSelector), NSStringFromSelector(newSelector), class, NSStringFromSelector(originalSelector)];
        } else {
            // 新方法在本类和父类都不存在，无法替换。
            msg = [NSString stringWithFormat:@"Try swizzle %@ method %@ with %@ of class %@, but new method %@ is not exist.", methodType, NSStringFromSelector(originalSelector), NSStringFromSelector(newSelector), class, NSStringFromSelector(newSelector)];
        }
        NSLog(@"%@", msg);
        @throw [NSException exceptionWithName:@"CMSwizzleError" reason:msg userInfo:nil];
#endif
    }
}

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector
{
    swizzleInstanceMethod(self, originalSelector, newSelector);
}

+ (void)swizzleClassSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector
{
    Class metaClass = object_getClass(self);
    swizzleInstanceMethod(metaClass, originalSelector, newSelector);
}

static void swizzleInstanceMethodWithBlock(Class class, SEL originalSelector, SEL newSelector, id block) {
    IMP newImp = imp_implementationWithBlock(block);
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    if (originalMethod) {
        const char *typeEncoding = method_getTypeEncoding(originalMethod);
        if (class_addMethod(class, newSelector, method_getImplementation(originalMethod), typeEncoding)) {
            if (!class_addMethod(class, originalSelector, newImp, typeEncoding)) {
                // 原方法是本类方法，需要将实现换为新实现。
                class_replaceMethod(class, originalSelector, newImp, typeEncoding);
            }
            // else 原方法是父类方法，已将新实现添加到本类。
            return;
        }
    }
#ifdef DEBUG
    NSString *msg = nil;
    NSString *methodType = class_isMetaClass(class) ? @"class" : @"instance";
    if (originalMethod) {
        // 本类已有同名新方法，添加失败。
        msg = [NSString stringWithFormat:@"Try swizzle %@ method %@ with block of class %@, but new method %@ is already exist.", methodType, NSStringFromSelector(originalSelector), class, NSStringFromSelector(newSelector)];
    } else {
        // 原方法在本类和父类都不存在，无法替换。
        msg = [NSString stringWithFormat:@"Try swizzle %@ method %@ with block of class %@, but original method %@ is not exist.", methodType, NSStringFromSelector(originalSelector), class, NSStringFromSelector(originalSelector)];
    }
    NSLog(@"%@", msg);
    @throw [NSException exceptionWithName:@"CMSwizzleError" reason:msg userInfo:nil];
#endif
}

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector newImpBlock:(id)block
{
    swizzleInstanceMethodWithBlock(self, originalSelector, newSelector, block);
}

+ (void)swizzleClassSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector newImpBlock:(id)block
{
    Class metaClass = object_getClass(self);
    swizzleInstanceMethodWithBlock(metaClass, originalSelector, newSelector, block);
}

@end
