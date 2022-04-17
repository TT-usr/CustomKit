//
//  CMCommonModuleProtocol.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "CMCommonModuleLifeCycleProtocol.h"
#import "CMCommonModuleContext.h"
#import "CMCommonModuleDefine.h"

@protocol CMCommonModuleProtocol <NSObject, CMCommonModuleLifeCycleProtocol>

@required

- (instancetype)initWithModuleContext:(__kindof CMCommonModuleContext *)moduleContext;

@property (nonatomic, strong, readonly) CMCommonModuleContext *moduleContext;

/**
 用于模块间通信
 
 @param event 每个模块可以自己定义枚举
 @param info 传递的参数
 @param callback 执行回调
 */
- (BOOL)handleEvent:(NSInteger)event
           userInfo:(id)info
           callback:(CMCommonModulesCallback)callback;

/**
 module销毁时会调用
 */
- (void)moduleDealloc:(NSInteger)reason;

// unavailable
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end
