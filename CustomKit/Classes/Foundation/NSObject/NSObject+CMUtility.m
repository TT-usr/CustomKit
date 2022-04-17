//
//  NSObject+CMUtility.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSObject+CMUtility.h"
#import <objc/runtime.h>

@interface CMWeakSelf : NSObject

@property (nonatomic, copy, readonly) CM_FreeBlock deallocBlock;
@property (nonatomic, unsafe_unretained, readonly) id realTarget;

- (instancetype)initWithBlock:(CM_FreeBlock)deallocBlock realTarget:(id)realTarget;

@end

@implementation CMWeakSelf

- (instancetype)initWithBlock:(CM_FreeBlock)deallocBlock realTarget:(id)realTarget {
    self = [super init];
    if (self) {
        //属性设为readonly,并用指针指向方式,是参照RACDynamicSignal中的写法
        self->_deallocBlock = [deallocBlock copy];
        self->_realTarget = realTarget;
    }
    return self;
}

- (void)dealloc {
    if (nil != self.deallocBlock) {
        self.deallocBlock(self.realTarget);
#if DEBUG
        NSLog(@"成功移除对象");
#endif
    }
}

@end

@implementation NSObject (CMUtility)

#pragma mark - Cast

+ (instancetype)cm_cast:(id)objc {
    if (!objc) return nil;
    
    if ([objc isKindOfClass:self.class]) {
        return objc;
    }
    return nil;
}

#pragma mark - Dealloc

- (void)cm_deallocBlock:(CM_FreeBlock)deallocBlock {
    if (!deallocBlock) return;
    
    @autoreleasepool {
        NSMutableArray *blocks = objc_getAssociatedObject(self, _cmd);
        if (!blocks) {
            blocks = [[NSMutableArray alloc] init];
            objc_setAssociatedObject(self, _cmd, blocks, OBJC_ASSOCIATION_RETAIN);
        }
        CMWeakSelf *blockExecutor = [[CMWeakSelf alloc] initWithBlock:deallocBlock realTarget:self];
        /// 原理: 当self释放时,它所绑定的属性也自动会释放
        [blocks addObject:blockExecutor];
    }
}

@end
