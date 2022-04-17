//
//  NSString+Extension.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Count
@interface NSString (Count)

/// 一个字符串中共有多少个字符(一个汉字、字母、数字、emoji表情均表示一个字符)
- (NSUInteger)charactorCounts;

/// 将string截取到某个字符, index: 0 ~ length-1
- (NSString *_Nullable)stringToIndex:(NSUInteger)index;

/// 将string截取到某个字符, index: 0 ~ length-1
/// @param index 截取范围
/// @param replaceString 截取范围你之外的字符替代
- (NSString *_Nullable)stringToIndex:(NSUInteger)index replaceString:(NSString *_Nullable)replaceString;

/// 过滤掉会导致文字乱序显示的特殊字符
- (NSString *_Nullable)filterSpecialCharacters;

/// 判断字符串中是否含有特殊字符（除数字、字母、汉字之外）
- (BOOL)containsInvalidCharacters;

@end



#pragma mark - GetTextSize
@interface NSAttributedString (GetTextSize)

- (CGFloat)boundingHeightForWidth:(CGFloat)width;

- (CGFloat)boundingWidthForHeight:(CGFloat)height;

- (CGSize)boundingSizeWithSize:(CGSize)size;

@end



#pragma mark - GetTextSize
@interface NSString (GetTextSize)

/// 计算string的高度
/// @param width 容器宽度
/// @param font string字体
/// @return string的高度
- (double)cm_getTextHeightWithConstrainedWidth:(CGFloat)width font:(UIFont *_Nullable)font;

/// 计算string的高度
/// @param width 容器宽度
/// @param attributes 字体属性
/// @return string的高度
- (double)cm_getTextHeightWithConstrainedWidth:(CGFloat)width attributes:(NSDictionary *_Nullable)attributes;

/// 计算string的宽度
/// @param height 容器高度
/// @param font   string字体
/// @return string的宽度
- (double)cm_getTextWidthWithConstrainedHeight:(CGFloat)height font:(UIFont *_Nullable)font;

/// 计算string的宽度
/// @param height     容器高度
/// @param attributes 字体属性
/// @return string的宽度
- (double)cm_getTextWidthWithConstrainedHeight:(CGFloat)height attributes:(NSDictionary *_Nullable)attributes;

/// 计算string的size
/// @param size     容器size
/// @param font   string字体
/// @return string的size
- (CGSize)cm_getTextSizeWithConstrainedSize:(CGSize)size font:(UIFont *_Nullable)font;

/// 计算string的size
/// @param size     容器size
/// @param attributes 字体属性
/// @return string的size
- (CGSize)cm_getTextSizeWithConstrainedSize:(CGSize)size attributes:(NSDictionary *_Nullable)attributes;

@end



#pragma mark - MFCateory
/// 常规NSString扩展
@interface NSString (CMCateory)

+ (BOOL)isEmpytString:(NSString *_Nullable)str;

- (BOOL)isNotEmpty;

/// 判断字符串是否都是空格和换行
- (BOOL)isContentEmpty;

/// 判断当前字符串是否包含 str 。大小写不敏感， “A”等同于“a”，然而在某些地方还有更复杂的情况。例如，在德国，“ß” 和 “SS”是等价的。 注音不敏感，“A” 等同于 “Å” 等同于 “Ä.”
/// @param str 指定字符串
- (BOOL)containsStringWithCaseAndDiacriticInsensitive:(NSString *_Nullable)str;

/// 截断字符串到指定index，如果遇到emoji，会截掉整个emoji。
/// emoji表情在字符串中是以多个长度来处理的（有特殊的emoji，由多个码元组成(7~11)等）
/// 当遇到字符串截取时，如果截断位置刚好在emoji表情的中间。此时emoji表情就会出现无法解码
/// eg:  NSString *str = @"123😝";  [str substringToIndex:4];
/// [str substringToIndexWithEmojiSafe:4] 返回 @“123”;
/// @param toIndex 指定index
- (NSString *_Nullable)substringToIndexWithEmojiSafe:(NSUInteger)toIndex;

/// 字符串中是否包含 emoji
- (BOOL)hasEmojiFormat;

/// ASCII字符（英文、数字、半角符号）占0.5个长度。中文占1个长度。全角符号、Emoji、特殊符号等一个码元占0.5长度。
/// 这里注意emoji，有特殊的emoji，由多个码元组成(7~11)等。计算出来的宽度可能比预期略长。
- (float)lookWidth;

/// 返回不大于指定长度的字符串，长度计算规则同 lookWidth 方法，截取规则同 substringToIndexWithEmojiSafe
/// @param lookWidth 指定长度
- (NSString *_Nullable)constraintToSpecifiedWidth:(NSInteger)lookWidth;

@end



#pragma mark - OAURLEncodingAdditions<#m#>
@interface NSString (OAURLEncodingAdditions)

/// 判断字符串是否是IP（包含IPV4 和 IPV6）
- (BOOL)isIPAddress;

/// 判断字符串是否是IPV4
- (BOOL)isIPV4Address;

/// 判断字符串是否是IPV6
- (BOOL)isIPV6Address;

- (NSString *_Nullable)URLEncodedString;
- (NSString *_Nullable)URLDecodedString;

/// 从 urlString 字符串中得到参数的键值对。 eg：[:urlStr dictionaryFromURLString];
- (NSDictionary *_Nullable)dictionaryFromURLString;

/// 从URL的query字符串获取键为key的值
/// @param key 参数名称
/// @return 返回参数对应的值
- (NSString *_Nullable)queryStringForKey:(NSString *_Nullable)key;

/// 读取本地文件为NSDictionary，path为self
/// @return 字典对象
- (NSDictionary *_Nullable)dictionaryWithContentFile;

@end
