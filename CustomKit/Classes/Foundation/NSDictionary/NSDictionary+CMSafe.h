//
//  NSDictionary+CMSafe.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMDictionaryAccessor.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (CMSafe) <CMDictionaryGetAccessor>

+ (nullable id)dictionary:(NSDictionary *)dict objectForKey:(NSString *)aKey defaultValue:(nullable id)value;
+ (nullable NSString *)dictionary:(NSDictionary *)dict stringForKey:(NSString *)aKey defaultValue:(nullable NSString *)value;
+ (nullable NSArray *)dictionary:(NSDictionary *)dict arrayForKey:(NSString *)aKey defaultValue:(nullable NSArray *)value;
+ (nullable NSDictionary *)dictionary:(NSDictionary *)dict dictionaryForKey:(NSString *)aKey defaultValue:(nullable NSDictionary *)value;
+ (nullable NSData *)dictionary:(NSDictionary *)dict dataForKey:(NSString *)aKey defaultValue:(nullable NSData *)value;
+ (nullable NSDate *)dictionary:(NSDictionary *)dict dateForKey:(NSString *)aKey defaultValue:(nullable NSDate *)value;
+ (nullable NSNumber *)dictionary:(NSDictionary *)dict numberForKey:(NSString *)aKey defaultValue:(nullable NSNumber *)value;
+ (NSUInteger)dictionary:(NSDictionary *)dict unsignedIntegerForKey:(NSString *)aKey defaultValue:(NSUInteger)value;
+ (NSInteger)dictionary:(NSDictionary *)dict integerForKey:(NSString *)aKey defaultValue:(NSInteger)value;
+ (float)dictionary:(NSDictionary *)dict floatForKey:(NSString *)aKey defaultValue:(float)value;
+ (double)dictionary:(NSDictionary *)dict doubleForKey:(NSString *)aKey defaultValue:(double)value;
+ (long long)dictionary:(NSDictionary *)dict longLongValueForKey:(NSString *)aKey defaultValue:(long long)value;
+ (BOOL)dictionary:(NSDictionary *)dict boolForKey:(NSString *)aKey defaultValue:(BOOL)value;
+ (int)dictionary:(NSDictionary *)dict intForKey:(NSString *)aKey defaultValue:(int)value;

@end

@interface NSMutableDictionary (CMSafe) <CMDictionarySetAccessor>
@end

@interface NSUserDefaults (CMSafe) <CMDictionarySetAccessor, CMDictionaryGetAccessor>
@end

@interface NSMapTable (CMSafe) <CMDictionarySetAccessor, CMDictionaryGetAccessor>
@end

@interface NSCache (CMSafe) <CMDictionarySetAccessor, CMDictionaryGetAccessor>
@end

NS_ASSUME_NONNULL_END
