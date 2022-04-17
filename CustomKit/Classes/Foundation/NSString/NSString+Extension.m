//
//  NSString+Extension.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSString+Extension.h"
#import <CoreGraphics/CoreGraphics.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "NSDictionary+CMSafe.h"
#import "NSArray+CMSafe.h"
#import "NSObject+Swizzle.h"


#pragma mark - Count
@implementation NSString (Count)

+ (void)load {
#ifdef DISTRIBUTION
    [self swizzleInstanceSelector:@selector(paragraphRangeForRange:) withNewSelector:@selector(cm_safeParagraphRangeForRange:)];
    [self swizzleInstanceSelector:@selector(substringWithRange:) withNewSelector:@selector(cm_substringWithRange:)];
#endif
}

- (NSRange)cm_safeParagraphRangeForRange:(NSRange)range {
    if (self.length == 0 && (range.location | range.length) > 0) {
        return NSMakeRange(0, 0);
    }
    return [self cm_safeParagraphRangeForRange:range];
}

- (NSString *)cm_substringWithRange:(NSRange)range {
    if (range.length + range.location > self.length) {
        if (range.location < self.length) {
            return [self substringFromIndex:range.location];
        }
        nil;
    }
    return [self cm_substringWithRange:range];
}

#pragma mark -
- (NSUInteger)charactorCounts {
    if (![self isNotEmpty]) return 0;
    __block NSUInteger count = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        count++;
    }];
    return count;
}

- (NSString *)stringToIndex:(NSUInteger)index {
    return [self stringToIndex:index replaceString:@""];
}

- (NSString *_Nullable)stringToIndex:(NSUInteger)index replaceString:(NSString *)replaceString {
    if (![self isNotEmpty]) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    __block BOOL hasTrim = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [array addObjectSafe:substring];
        
        if (array.count >= index) {
            *stop = YES;
            hasTrim = YES;
        }
    }];
    
    NSString *result = [array componentsJoinedByString:@""];
    if (hasTrim && [replaceString isNotEmpty] && result.length != self.length) {
        result = [result stringByAppendingString:replaceString];
    }
    
    return result;
}

- (NSString *)filterSpecialCharacters {
    NSString *result = self;
    if ([self containsString:@"\U0000202e"]) {
        result = [self stringByReplacingOccurrencesOfString:@"\U0000202e" withString:@""];
    }
    return result;
}

- (BOOL)containsInvalidCharacters {
    if (![self isNotEmpty]) return NO;
    __block BOOL hasInvalid = NO;
    NSString *validStr = @"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validStr];
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if (![predicate evaluateWithObject:substring]) {
            hasInvalid = YES;
            *stop = YES;
        }
    }];
    return hasInvalid;
}

@end



#pragma mark - GetTextSize
@implementation NSAttributedString (GetTextSize)

- (CGFloat)boundingHeightForWidth:(CGFloat)width {
    if (self.length > 0){
        CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                         context:nil];
        return ceil(rect.size.height);
    }
    return 0;
}

- (CGFloat)boundingWidthForHeight:(CGFloat)height {
    if (self.length > 0){
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                         context:nil];
        return ceil(rect.size.width);
    }
    return 0;
}

- (CGSize)boundingSizeWithSize:(CGSize)size {
    if (self.length > 0){
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                         context:nil];
        return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
    }
    return CGSizeZero;
}

@end



#pragma mark - GetTextSize
@implementation NSString (GetTextSize)

- (double)cm_getTextHeightWithConstrainedWidth:(CGFloat)width font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName:font};
    return [self cm_getTextHeightWithConstrainedWidth:width attributes:attributes];
}

- (double)cm_getTextHeightWithConstrainedWidth:(CGFloat)width attributes:(NSDictionary *)attributes {
    return [self cm_getTextSizeWithConstrainedSize:CGSizeMake(width, MAXFLOAT) attributes:attributes].height;
}

- (double)cm_getTextWidthWithConstrainedHeight:(CGFloat)height font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName:font};
    return [self cm_getTextWidthWithConstrainedHeight:height attributes:attributes];
}

- (double)cm_getTextWidthWithConstrainedHeight:(CGFloat)height attributes:(NSDictionary *)attributes {
    return [self cm_getTextSizeWithConstrainedSize:CGSizeMake(MAXFLOAT, height) attributes:attributes].width;
}

- (CGSize)cm_getTextSizeWithConstrainedSize:(CGSize)size font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName:font};
    return [self cm_getTextSizeWithConstrainedSize:size attributes:attributes];
}

- (CGSize)cm_getTextSizeWithConstrainedSize:(CGSize)size attributes:(NSDictionary *)attributes {
    CGRect rect = [self boundingRectWithSize:size
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                  attributes:attributes
                                     context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
}

@end



#pragma mark - CMCateory
@implementation NSString (CMCateory)

- (BOOL)isNotEmpty {
    // 如果是nil调用时必定是NO，因此只需要判断empty
    return [self isKindOfClass:[NSString class]] && [self length] > 0;
}

+ (BOOL)isEmpytString:(NSString *)str {
    if (!str) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
        NSCAssert(NO, @"参数不能为非NSString类型");
        return YES;
    }
    if (str.length == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isContentEmpty {
    NSString *trimStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimStr.length == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)containsStringWithCaseAndDiacriticInsensitive:(NSString *)str {
    if (!str) {
        return NO;
    }
    NSRange range = [self rangeOfString:str options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
    if (range.location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (NSString *)substringToIndexWithEmojiSafe:(NSUInteger)toIndex {
    NSString *substring = self;
    if (toIndex < self.length) {
        NSRange rangeIndex = [self rangeOfComposedCharacterSequenceAtIndex:toIndex];
        substring = [self substringToIndex:rangeIndex.location];
    }
    return substring;
}

- (BOOL)hasEmojiFormat {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

- (float)lookWidth {
    float width = 0;
    for (NSUInteger i = 0; i < self.length; i++)
    {
        unichar a = [self characterAtIndex:i];
        if (a >= 0x4e00 && a <= 0x9fa5) { //汉字
            width += 1;
        } else if (a >= 0x00 && a <= 0x7F) { //字母，数字，半角符号
            width += 0.5;
        } else {  //emoji的一个码元，全角符号等
            width += 0.5;
        }
    }
    return width;
}

- (NSString *)constraintToSpecifiedWidth:(NSInteger)lookWidth {
    float width = 0;
    for (NSUInteger i = 0; i < self.length; i++)
    {
        unichar a = [self characterAtIndex:i];
        if (a >= 0x4e00 && a <= 0x9fa5) { //汉字
            width += 1;
        } else if (a >= 0x00 && a <= 0x7F) { //字母，数字，半角符号
            width += 0.5;
        } else {  //emoji的其中一个码元，全角符号等
            width += 0.5;
        }
        
        if (width > lookWidth) {
            return [self substringToIndexWithEmojiSafe:i];
        }
    }
    return self;
}

@end



#pragma mark - OAURLEncodingAdditions
@implementation NSString (OAURLEncodingAdditions)

- (BOOL)isIPAddress {
    return [self isIPV4Address] || [self isIPV6Address];
}

- (BOOL)isIPV4Address {
    struct sockaddr_in sa;
    char *hostNameOrIPAddressCString = (char *)[self UTF8String];
    int result = inet_pton(AF_INET, hostNameOrIPAddressCString, &(sa.sin_addr));
    return (result != 0);
}

- (BOOL)isIPV6Address {
    struct sockaddr_in6 sa;
    char *hostNameOrIPAddressCString = (char *)[self UTF8String];
    int result = inet_pton(AF_INET6, hostNameOrIPAddressCString, &(sa.sin6_addr));
    return (result != 0);
}

- (NSString *)URLEncodedString {
    NSString *result = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"].invertedSet];
    return result;
}

- (NSString*)URLDecodedString {
    NSString *result = [self stringByRemovingPercentEncoding];
    return result;
}

- (NSDictionary *)dictionaryFromURLString {
    NSString *string = self;
    // #之后部分不处理
    NSRange hashRange = [string rangeOfString:@"#"];
    if (hashRange.location != NSNotFound) {
        string = [string substringToIndex:hashRange.location];
    }
    // ?之前部分不处理
    NSRange questionRange = [string rangeOfString:@"?"];
    if (questionRange.location != NSNotFound) {
        string = [string substringFromIndex:questionRange.location + 1];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *pairStrings = [string componentsSeparatedByString:@"&"];
    for (NSString *pairString in pairStrings) {
        NSRange equalRange = [pairString rangeOfString:@"="];
        if (equalRange.location == NSNotFound) {
            continue;
        }
        NSString *name = [pairString substringToIndex:equalRange.location];
        NSString *value = [[pairString substringFromIndex:equalRange.location + 1] URLDecodedString];
        if (name && value) {
            [dict setObject:value forKey:name];
        }
    }
    return dict;
}

- (NSString *)queryStringForKey:(NSString *)key {
    NSDictionary *dict = [self dictionaryFromURLString];
    if (dict.count) {
        return [dict valueForKey:key];
    }
    return nil;
}

- (NSDictionary *)dictionaryWithContentFile {
    NSData *data = [NSData dataWithContentsOfFile:self];
    if (data && [data length]) {
        return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    }
    return nil;
}

@end
