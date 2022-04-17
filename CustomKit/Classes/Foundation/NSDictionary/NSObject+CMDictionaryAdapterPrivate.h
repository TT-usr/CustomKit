//
//  NSObject+CMDictionaryAdapterPrivate.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

static BOOL throwExceptionEnabled  = NO;
static BOOL illegalTypeLogEnabled  = NO;
/**
 * 为CMDictionaryAccessor协议提供默认实现，私有类别，不应该被import
 */
@interface NSObject (CMDictionaryAdapterPrivate)

@end

