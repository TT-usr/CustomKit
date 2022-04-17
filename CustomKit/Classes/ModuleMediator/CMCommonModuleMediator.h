//
//  CMCommonModuleMediator.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCommonModuleContext.h"
#import "CMCommonModuleDefine.h"

#define CMCommonGetModuleMediator [MBCommonModuleMediator moduleMediator]

#define CMCommonProto(proto) \
(NO && ((void)({id<proto> tempObj; tempObj;}), NO), @protocol(proto))

#define CMCommonGetModuleWithClass(proto, clz) \
({clz *obj = (clz *)[CMCommonGetModuleMediator moduleWithProto:MBCommonProto(proto)]; \
if (![obj isKindOfClass:clz.class]) { \
obj = nil; \
} \
obj;})

#define CMCommonGetModule(proto) \
((id <proto>)[CMCommonGetModuleMediator moduleWithProto:@protocol(proto)])


#define CMCommonRespondSEL(aSel, ...)\
[CMCommonGetModuleMediator dispatchSelector:@selector(aSel) param: __VA_ARGS__];

@interface CMCommonModuleMediator : NSObject

/**
 *  获取一个模块中转器(非单例，必须被业务持有)
 */
+ (instancetype)moduleMediator;

@property (nonatomic, strong) CMCommonModuleContext *moduleContext;

- (void)bindViewController:(__kindof UIViewController *)viewController;


//------- 注册模块 生命周期由Mediator维护 ------
/**
 注册module
 
 @param proto proto
 @param impClass 实现类 - 类必须实现 MBCommonModuleProtocol 协议
 @param initType 初始化时机
 @param toMapMode 映射模板时需要，默认为nil
 */
- (void)registerModuleWithProto:(Protocol *)proto
                       impClass:(Class)impClass;

- (void)registerModuleWithProto:(Protocol *)proto
                       impClass:(Class)impClass
                       initType:(CMCommonModuleInitType)initType;

- (void)registerModuleWithProto:(Protocol *)proto
                       impClass:(Class)impClass
                       initType:(CMCommonModuleInitType)initType
                      toMapMode:(id)mapMode;

/** 生命周期自己管理 -- 注册到内部方便在其他地方获取 */
- (void)registerModuleObj:(id)obj
                  toProto:(Protocol *)proto;

#pragma mark - 获取模块
/**
 获取module
 可以获取到通过registerModuleWithName:...注册 / registerModuleObjWithName:... 注册的
 
 @param proto proto
 @param context context / 默认值为 self.moduleContext
 @param autoInit 是否自动初始化 / 默认YES
 @param mapMode 映射模板时需要，默认为nil
 */
- (id)moduleWithProto:(Protocol *)proto;

- (id)moduleWithProto:(Protocol *)proto
             autoInit:(BOOL)autoInit;

- (id)moduleWithProto:(Protocol *)proto
              context:(CMCommonModuleContext *)context
             autoInit:(BOOL)autoInit;

- (id)moduleWithProto:(Protocol *)proto
              context:(CMCommonModuleContext *)context
             autoInit:(BOOL)autoInit
            toMapMode:(id)mapMode;

#pragma mark - remove
- (void)removeModuleWithProto:(Protocol *)proto;

#pragma mark - dispatch
- (void)dispatchSelector:(SEL)aSel
                   param:(id)param, ...;

#pragma mark - respondType
/**
 分发IM 数据
 
 @param type IM 消息类型 eventType
 @param aSel module实现IM消息出来方法
 @param param 传递的参数， 参数个数类型最好与sel中的类型匹配
 比如 sel = resmethod:(id)abc type:(NSInteger)type tes:(float)dd
 传递的参数应该为 NSObject.new, 1, 2.5
 注意：float 与 int 不能混用， dd 参数需要加小数点， 不能为3 ； type 也一样。
 如果sel的第一个参数为整数，则param传nil为跳过， 其他的参数正常传
 */
- (void)respondType:(NSInteger)type
           selector:(SEL)aSel
              param:(id)param, ...;

- (void)respondType:(NSInteger)type selectorWithParams:(SEL)aSel, ...;

#pragma mark - registerRespondToProto
/**
 注册IM type 与之对应响应的module ，如果module未初始化会自动初始化
 
 @param proto proto
 @param priority 响应优先级
 @param type IM 消息类型 eventType
 @param autoInit 使用时是否自动初始化 YES
 @param ... 多个type types不能为0 ,为0会自动结束
 */
- (void)registerRespondToProto:(Protocol *)proto
                          type:(NSInteger)type, ...;


- (void)registerRespondToProto:(Protocol *)proto
                      priority:(CMCommonModuleRespondPriority)priority
                          type:(NSInteger)type, ...;

- (void)registerRespondToProto:(Protocol *)proto
                      priority:(CMCommonModuleRespondPriority)priority
                      autoInit:(BOOL)autoInit
                          type:(NSInteger)type, ...;

#pragma mark - registerRespondSelector
/**
 注册响应方法与之对应的module
 
 @param aSel module需要响应的方法
 @param proto proto
 @param priority 响应优先级
 @param autoInit 使用时是否自动初始化 YES
 */
- (void)registerRespondSelector:(SEL)aSel
                        toProto:(Protocol *)proto;

- (void)registerRespondSelector:(SEL)aSel
                        toProto:(Protocol *)proto
                       priority:(CMCommonModuleRespondPriority)priority;

- (void)registerRespondSelector:(SEL)aSel
                        toProto:(Protocol *)proto
                       priority:(CMCommonModuleRespondPriority)priority
                       autoInit:(BOOL)autoInit;

#pragma mark - respondSelector
/**
 分发响应事件
 
 @param aSel module需要响应的方法
 @param param 传递的参数， 参数个数类型最好与sel中的类型匹配
 比如 sel = resmethod:(id)abc type:(NSInteger)type tes:(float)dd
 传递的参数应该为 NSObject.new, 1, 2.5
 注意：float 与 int 不能混用， dd 参数需要加小数点， 不能为3 ； type 也一样。
 如果sel的第一个参数为整数，则param传nil为跳过， 其他的参数正常传
 */
- (void)respondSelector:(SEL)aSel
                  param:(id)param, ...;

- (void)respondSelectorWithParams:(SEL)aSel, ...;

#pragma mark - leave
+ (BOOL)leaveModuleMediator:(NSInteger)reason;

- (void)registerService:(Protocol *)proto impClass:(Class)impClass;
- (id)serviceWithProto:(Protocol *)proto;
@end

