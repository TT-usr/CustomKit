//
//  NSObject+DebugConfiguration.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSObject+DebugConfiguration.h"
#import "NSObject+CMDictionaryAdapterPrivate.h"

@implementation NSObject (DebugConfiguration)

//当类型不匹配的时候是否抛异常
+ (void)setThrowExceptionEnabled:(BOOL)enabled
{
#if DEBUG
    throwExceptionEnabled = enabled;
#endif
}

//当类型不匹配但又是string、number等可以相互转化的类型时
+ (void)setIllegalTypeLogEnabled:(BOOL)enabled
{
#if DEBUG
    illegalTypeLogEnabled = enabled;
#endif
}

@end
