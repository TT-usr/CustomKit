//
//  NSDictionary+CMSafe.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSDictionary+CMSafe.h"
#import <objc/runtime.h>

static void safe_swizzleInstMethod(Class class, SEL originalSelector, SEL newSelector) {
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
    }
}

@implementation NSDictionary (CMSafe)

#pragma mark - sefe hook


#pragma mark - 类方法

+ (nullable id)dictionary:(NSDictionary *)dict objectForKey:(NSString *)aKey defaultValue:(nullable id)value
{
    if (!dict) {
        return value;
    }
    return [dict objectForKey:aKey defaultValue:value];
}

+ (nullable NSString *)dictionary:(NSDictionary *)dict stringForKey:(NSString *)aKey defaultValue:(nullable NSString *)value
{
    if (!dict) {
        return value;
    }
    return [dict stringForKey:aKey defaultValue:value];
}

+ (nullable NSArray *)dictionary:(NSDictionary *)dict arrayForKey:(NSString *)aKey defaultValue:(nullable NSArray *)value
{
    if (!dict) {
        return value;
    }
    return [dict arrayForKey:aKey defaultValue:value];
}

+ (nullable NSDictionary *)dictionary:(NSDictionary *)dict dictionaryForKey:(NSString *)aKey defaultValue:(nullable NSDictionary *)value
{
    if (!dict) {
        return value;
    }
    return [dict dictionaryForKey:aKey defaultValue:value];
}

+ (nullable NSData *)dictionary:(NSDictionary *)dict dataForKey:(NSString *)aKey defaultValue:(nullable NSData *)value
{
    if (!dict) {
        return value;
    }
    return [dict dataForKey:aKey defaultValue:value];
}

+ (nullable NSDate *)dictionary:(NSDictionary *)dict dateForKey:(NSString *)aKey defaultValue:(nullable NSDate *)value
{
    if (!dict) {
        return value;
    }
    return [dict dateForKey:aKey defaultValue:value];
}

+ (nullable NSNumber *)dictionary:(NSDictionary *)dict numberForKey:(NSString *)aKey defaultValue:(nullable NSNumber *)value
{
    if (!dict) {
        return value;
    }
    return [dict numberForKey:aKey defaultValue:value];
}

+ (NSUInteger)dictionary:(NSDictionary *)dict unsignedIntegerForKey:(NSString *)aKey defaultValue:(NSUInteger)value
{
    if (!dict) {
        return value;
    }
    return [dict unsignedIntegerForKey:aKey defaultValue:value];
}

+ (NSInteger)dictionary:(NSDictionary *)dict integerForKey:(NSString *)aKey defaultValue:(NSInteger)value
{
    if (!dict) {
        return value;
    }
    return [dict integerForKey:aKey defaultValue:value];
}

+ (float)dictionary:(NSDictionary *)dict floatForKey:(NSString *)aKey defaultValue:(float)value
{
    if (!dict) {
        return value;
    }
    return [dict floatForKey:aKey defaultValue:value];
}

+ (double)dictionary:(NSDictionary *)dict doubleForKey:(NSString *)aKey defaultValue:(double)value
{
    if (!dict) {
        return value;
    }
    return [dict doubleForKey:aKey defaultValue:value];
}

+ (long long)dictionary:(NSDictionary *)dict longLongValueForKey:(NSString *)aKey defaultValue:(long long)value
{
    if (!dict) {
        return value;
    }
    return [dict longLongValueForKey:aKey defaultValue:value];
}

+ (BOOL)dictionary:(NSDictionary *)dict boolForKey:(NSString *)aKey defaultValue:(BOOL)value
{
    if (!dict) {
        return value;
    }
    return [dict boolForKey:aKey defaultValue:value];
}

+ (int)dictionary:(NSDictionary *)dict intForKey:(NSString *)aKey defaultValue:(int)value
{
    if (!dict) {
        return value;
    }
    return [dict intForKey:aKey defaultValue:value];
}

@end

@implementation NSMutableDictionary (CMSafe)

+(void)load {
#ifdef DISTRIBUTION
    Class clas = objc_getClass("__NSDictionaryM");
    safe_swizzleInstMethod(clas, @selector(setObject:forKey:), @selector(cm_overrideSetObject:forKey:));
    safe_swizzleInstMethod(clas, @selector(removeObjectForKey:), @selector(cm_overrideRemoveObjectForKey:));
#endif
}

- (void)cm_overrideSetObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (!anObject || !aKey ) {
        return;
    }
    [self cm_overrideSetObject:anObject forKey:aKey];
}

- (void)cm_overrideRemoveObjectForKey:(id)aKey {
    if (!aKey) {
        return;
    }
    
    [self cm_overrideRemoveObjectForKey:aKey];
}

@end

@implementation NSUserDefaults (CMSafe)
@end

@implementation NSMapTable (CMSafe)
@end

@implementation NSCache (CMSafe)

+ (void)load {
#ifdef DISTRIBUTION
    safe_swizzleInstMethod(self, @selector(setObject:forKey:), @selector(cm_safeSetObject:forKey:));
    safe_swizzleInstMethod(self, @selector(setObject:forKey:cost:), @selector(cm_safeSetObject:forKey:cost:));
#endif
}

- (void)cm_safeSetObject:(id)obj forKey:(id)key {
    if (obj) {
        [self cm_safeSetObject:obj forKey:key];
    } else {
        [self removeObjectForKey:key];
    }
}

- (void)cm_safeSetObject:(id)obj forKey:(id)key cost:(NSUInteger)g {
    if (obj) {
        [self cm_safeSetObject:obj forKey:key cost:g];
    } else {
        [self removeObjectForKey:key];
    }
}

@end
