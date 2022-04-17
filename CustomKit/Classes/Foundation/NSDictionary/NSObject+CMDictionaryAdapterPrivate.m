//
//  NSObject+CMDictionaryAdapterPrivate.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSObject+CMDictionaryAdapterPrivate.h"
#import "CMDictionaryAccessor.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface NSObject () <CMDictionarySetAccessor, CMDictionaryGetAccessor>
@end

@implementation NSObject (CMDictionaryAdapterPrivate)

- (void)printCurrentCallStack
{
    NSArray *callArray = [NSThread callStackSymbols];
    NSLog(@"\n -----------------------------------------call stack----------------------------------------------\n");
    for (NSString *string in callArray) {
        NSLog(@"  %@  ", string);
    }
    NSLog(@"\n -------------------------------------------------------------------------------------------------\n");
}

#pragma mark - CMDictionaryGetAccessor

- (id)objectForKey:(NSString *)key defaultValue:(id)defaultValue
{
    if ([self respondsToSelector:@selector(objectForKey:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
       id obj = [(NSDictionary *)self objectForKey:key];
#pragma clang diagnostic pop
        return (obj && obj != [NSNull null]) ? obj : defaultValue;
    } else if (throwExceptionEnabled){
        [self printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"self can't implementation -[objectForKey:], the receiver's class is:%@, The key is %@, the defaultValue is :%@", key, [self class], defaultValue];
        NSException *exception = [NSException exceptionWithName:@"IllegalParameters" reason:reason userInfo:(NSDictionary *)self];
        @throw exception;
        return nil;
    }
    
    return nil;
}

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    id obj = [self objectForKey:key defaultValue:defaultValue];
    if (![obj isKindOfClass:[NSString class]]) {
        if (obj) {
            if ([obj isKindOfClass:[NSNumber class]]) {
                //抛出警告
                if (illegalTypeLogEnabled) {
                    NSString *reason = [NSString stringWithFormat:@"%s, The key is \" %@ \", the value is \" %@ \", need type is NSString", __func__, key, obj];
                    NSDictionary *userInfo = @{
                        @"key" : @"iOS_IllegalType_Log",
                        @"content" : reason,
                        @"type" : @"NSString",
                    };
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MMBaseFoundation_NSDictionary_Type_Error" object:nil userInfo:userInfo];
                }
                
                // 处理 NSNumber -> NSString
                return [(NSNumber *)obj stringValue];
            } else if (throwExceptionEnabled){
                [self printCurrentCallStack];
                NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSString, the value's actual type is:%@", key, obj, [obj class]];
                NSException *exception = [NSException exceptionWithName:@"IllegalType" reason:reason userInfo:(NSDictionary *)self];
                @throw exception;
            }
        }
        
        return defaultValue;
    }
    
    return (NSString *)obj;
}

- (NSArray *)arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
    id obj = [self objectForKey:key defaultValue:defaultValue];
    if (![obj isKindOfClass:[NSArray class]]) {
        if (throwExceptionEnabled || illegalTypeLogEnabled) {
            if (obj) {
                //抛出警告
                if (([obj isKindOfClass:[NSDictionary class]] && [(NSDictionary *)obj count]==0) ||
                    ([obj isKindOfClass:[NSString class]] && [(NSString *)obj length]==0) ) {
                    if (illegalTypeLogEnabled) {
                        NSString *reason = [NSString stringWithFormat:@"%s, The key is \" %@ \", the value is \" %@ \", need type is NSArray", __func__, key, obj];
                        NSDictionary *userInfo = @{
                            @"key" : @"iOS_IllegalType_Log",
                            @"content" : reason,
                            @"type" : @"NSArray",
                        };
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MMBaseFoundation_NSDictionary_Type_Error" object:nil userInfo:userInfo];
                    }
                    
                } else if (throwExceptionEnabled) {
                    [self printCurrentCallStack];
                    NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSArray, value's actual type is:%@", key, obj, [obj class]];
                    NSException *exception = [NSException exceptionWithName:@"IllegalType" reason:reason userInfo:(NSDictionary *)self];
                    @throw exception;
                }
            }
        }
        
        return defaultValue;
    }
    
    return (NSArray *)obj;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
    id obj = [self objectForKey:key defaultValue:defaultValue];
    if (![obj isKindOfClass:[NSDictionary class]]) {
        if (throwExceptionEnabled || illegalTypeLogEnabled) {
            if (obj) {
                //抛出警告
                if ( ([obj isKindOfClass:[NSArray class]] && [(NSArray *)obj count]==0) ||
                    ([obj isKindOfClass:[NSString class]] && [(NSString *)obj length]==0) ) {
                    if (illegalTypeLogEnabled) {
                        NSString *reason = [NSString stringWithFormat:@"%s, The key is \" %@ \", the value is \" %@ \", need type is NSDictionary", __func__, key, obj];
                        NSDictionary *userInfo = @{
                            @"key" : @"iOS_IllegalType_Log",
                            @"content" : reason,
                            @"type" : @"NSDictionary",
                        };
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"MMBaseFoundation_NSDictionary_Type_Error" object:nil userInfo:userInfo];
                    }
                    
                } else if (throwExceptionEnabled) {
                    [self printCurrentCallStack];
                    NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSDictionary, the value's actual type is:%@", key, obj, [obj class]];
                    NSException *exception = [NSException exceptionWithName:@"IllegalType" reason:reason userInfo:(NSDictionary *)self];
                    @throw exception;
                }
            }
        }
        
        return defaultValue;
    }
    
    return (NSDictionary *)obj;
}

- (NSData *)dataForKey:(NSString *)key defaultValue:(NSData *)defaultValue
{
    id obj = [self objectForKey:key defaultValue:defaultValue];
    if (![obj isKindOfClass:[NSData class]]) {
        if (obj && throwExceptionEnabled) {
            [self printCurrentCallStack];
            NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSData, the value's type is:%@", key, obj, [obj class]];
            NSException *exception = [NSException exceptionWithName:@"IllegalType" reason:reason userInfo:(NSDictionary *)self];
            @throw exception;
        }
        
        return defaultValue;
    }
    
    return (NSData *)obj;
}

- (NSDate *)dateForKey:(NSString *)key defaultValue:(NSDate *)defaultValue
{
    id obj = [self objectForKey:key defaultValue:defaultValue];
    if (![obj isKindOfClass:[NSDate class]]) {
        if (obj && throwExceptionEnabled) {
            [self printCurrentCallStack];
            NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSDate, the value's actual type is:%@", key, obj, [obj class]];
            NSException *exception = [NSException exceptionWithName:@"IllegalType" reason:reason userInfo:(NSDictionary *)self];
            @throw exception;
        }
        return defaultValue;
    }
    
    return (NSDate *)obj;
}

- (NSNumber *)numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue
{
    id obj = [self objectForKey:key defaultValue:defaultValue];
    if (![obj isKindOfClass:[NSNumber class]]) {
        
        if (obj) {
            if ([obj isKindOfClass:[NSString class]]) {
                //抛出警告
                if (illegalTypeLogEnabled) {
                    NSString *reason = [NSString stringWithFormat:@"%s, The key is \" %@ \", the value is \" %@ \", need type is NSNumber", __func__, key, obj];
                    NSDictionary *userInfo = @{
                        @"key" : @"iOS_IllegalType_Log",
                        @"content" : reason,
                        @"type" : @"NSNumber",
                    };
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MMBaseFoundation_NSDictionary_Type_Error" object:nil userInfo:userInfo];
                }
                
                // 处理 NSString -> NSNumber
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *number = [numberFormatter numberFromString:(NSString *)obj];
                return number ?: defaultValue;
            } else if (throwExceptionEnabled){
                [self printCurrentCallStack];
                NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSNumber, the value's actual type is:%@", key, obj, [obj class]];
                NSException *exception = [NSException exceptionWithName:@"IllegalType" reason:reason userInfo:(NSDictionary *)self];
                @throw exception;
            }
        }
        return defaultValue;
    }
    return (NSNumber *)obj;
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue
{
    id obj = [self objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(unsignedIntegerValue)]) {
        return [obj unsignedIntegerValue];
    }
    
    return defaultValue;
}

- (int)intForKey:(NSString *)key defaultValue:(int)defaultValue
{
    id obj = [self objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(intValue)]) {
        return [obj intValue];
    }
    
    return defaultValue;
}

- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue
{
    id obj = [self objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(integerValue)]) {
        return [obj integerValue];
    }
    
    return defaultValue;
}

- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue
{
    id obj = [self objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(floatValue)]) {
        return [obj floatValue];
    }
    
    return defaultValue;
}

- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue
{
    id obj = [self objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(doubleValue)]) {
        return [obj doubleValue];
    }
    
    return defaultValue;
}

- (long long)longLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue
{
    id obj = [self objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(longLongValue)]) {
        return [obj longLongValue];
    }
    
    return defaultValue;
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    id obj = [self objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(boolValue)]) {
        return [obj boolValue];
    }
    
    return defaultValue;
}

#pragma mark - CMDictionarySetAccessor

- (void)setObjectSafe:(id)value forKey:(id)key
{
    if (!value || !key || value == [NSNull null] || key == [NSNull null]) {
        return;
    }
    
    if ([self respondsToSelector:@selector(setObject:forKey:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
        [(NSMutableDictionary *)self setObject:value forKey:key];
#pragma clang diagnostic pop
    } else if (throwExceptionEnabled){
        //NSLog(@"Error, called function %s with illegal parameters, The key is:%@, The value is:%@", __func__, key, value);
        [self printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"The receiver's type is:%@,The key is %@, the value is :%@", [self class], key, value];
        NSException *exception = [NSException exceptionWithName:@"IllegalParameters" reason:reason userInfo:(NSDictionary *)self];
        @throw exception;
    }
}

//使用这个方法的前提是object肯定满足条件，只对key进行判断,不对外开放只在本类内部使用
- (void)setObject:(id)value forSafeKey:(id)key
{
    if (!key || key == [NSNull null]) {
        return;
    }
    
    if ([self respondsToSelector:@selector(setObject:forKey:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
        [(NSMutableDictionary *)self setObject:value forKey:key];
#pragma clang diagnostic pop
    } else if (throwExceptionEnabled) {
        //NSLog(@"Error, called function %s with illegal parameters, The key is:%@, The value is:%@", __func__, key, value);
        [self printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"The receiver's type is:%@, The key is %@, the value is :%@", [self class], key, value];
        NSException *exception = [NSException exceptionWithName:@"IllegalParameters" reason:reason userInfo:(NSDictionary *)self];
        @throw exception;
    }
}

- (void)setString:(NSString *)value forKey:(NSString *)key
{
    [self setObjectSafe:value forKey:key];
}

- (void)setNumber:(NSNumber *)value forKey:(NSString *)key
{
    [self setObjectSafe:value forKey:key];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithInteger:value] forSafeKey:key];
}

- (void)setInt:(int)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithInt:value] forSafeKey:key];
}

- (void)setFloat:(float)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithFloat:value] forSafeKey:key];
}

- (void)setDouble:(double)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithDouble:value] forSafeKey:key];
}

- (void)setLongLongValue:(long long)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithLongLong:value] forSafeKey:key];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [self setObject:[NSNumber numberWithBool:value] forSafeKey:key];
}

@end

#pragma clang diagnostic pop
