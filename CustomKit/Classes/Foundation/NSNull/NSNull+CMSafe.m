//
//  NSNull+CMSafe.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSNull+CMSafe.h"

@implementation NSNull (CMSafe)

#pragma mark - Forward Message

// 其他未识别方法进入消息转发，把消息转发给 nil
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [NSObject instanceMethodSignatureForSelector:@selector(init)];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    anInvocation.target = nil;
    [anInvocation invoke];
}

@end
