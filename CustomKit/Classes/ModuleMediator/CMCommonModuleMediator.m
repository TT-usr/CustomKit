//
//  CMCommonModuleMediator.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "CMCommonModuleMediator.h"
#import "CMCommonModuleProtocol.h"
#import <Aspects/Aspects.h>
#import "CMCommonModuleDefine.h"
#import <CustomKit/CMInvocation.h>
#import <objc/runtime.h>
#import <CustomKit/CMFoundation.h>

#define CMCommonModulePerformVCMethod(vc, method) \
for (id<CMCommonModuleProtocol> obj in ws.modulesDict.allValues) { \
    if ([obj respondsToSelector:@selector(method)]) { \
        [obj method(vc)]; \
    } \
}

#define CMCommonModulePerformMethod(method) \
for (id<CMCommonModuleProtocol> obj in ws.modulesDict.allValues) { \
    if ([obj respondsToSelector:@selector(method)]) { \
        [obj method]; \
    } \
}

#define CMCommonModuleAutoInit(type) \
    [ws.moduleNamesInitDict[@(type)] enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) { \
    [ws moduleWithName:obj]; \
}];

@interface CMCommonModuleRespondModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CMCommonModuleRespondPriority priority;
@property (nonatomic, assign) BOOL autoInit;

@end

@implementation CMCommonModuleRespondModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _autoInit = YES;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if ([self isKindOfClass:[object class]]) {
        if ([self.name isEqualToString:[((CMCommonModuleRespondModel *)object) name]]) {
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)hash {
    return self.name.hash;
}

@end


@interface CMCommonModuleMediator ()

// protocol - impClass
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *modulesClassDict;

// protocol - modules
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<CMCommonModuleProtocol>> *modulesDict;

// int []
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSMutableArray<NSString *> *> *moduleNamesInitDict;

@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *servicesDict;
@property (nonatomic, strong) NSMapTable *servicesObjTable;

// dynamic regist module
@property (nonatomic, strong) NSMapTable<NSString *, id> *weakModulesObjTable;

// regist response  (key - set<MBCommonModuleRespondModel>)
@property (nonatomic, strong) NSMutableDictionary <id, NSMutableOrderedSet<CMCommonModuleRespondModel *> *> *respondNames;

@property (nonatomic, strong) NSMutableArray <id<AspectToken>> *aspectTokens;

@property (nonatomic, assign, getter=isDestroyed) BOOL destroyed;

@end

@implementation CMCommonModuleMediator

static __weak CMCommonModuleMediator *instance;
+ (instancetype)moduleMediator
{
    CMCommonModuleMediator *strongInstance = instance;
    @synchronized(self) {
        if (strongInstance == nil) {
            strongInstance = [[[self class] alloc] initModuleConfig];
            instance = strongInstance;
        }
    }
    return strongInstance;
}

- (instancetype)initModuleConfig
{
    self = [super init];
    if (self) {
        _modulesClassDict    = [NSMutableDictionary new];
        _modulesDict         = [NSMutableDictionary new];
        _moduleNamesInitDict = [NSMutableDictionary new];
        _servicesDict        = [NSMutableDictionary new];
        _servicesObjTable    = [NSMapTable strongToWeakObjectsMapTable]; // strong references to the keys and weak references to the values.
        _weakModulesObjTable = [NSMapTable strongToWeakObjectsMapTable];
        _respondNames        = [NSMutableDictionary new];
        // 向_moduleNamesInitDict字典中添加数据
        // 添加key是i， value是新建的可变数组

        for (NSInteger i = CMCommonModuleInitViewDidLoad; i <= CMCommonModuleInitViewDidAppear; i++) {
            [_moduleNamesInitDict setObject:NSMutableArray.new forKey:@(i)];
        }
        self.destroyed = NO;
    }
    return self;
}

+ (BOOL)leaveModuleMediator:(NSInteger)reason
{
    // 销毁房间信息
    if (instance) {
        [instance _vorDeallocModules:reason];
    }
    return YES;
}

- (void)bindViewController:(__kindof UIViewController *)viewController
{
    NSParameterAssert(viewController);
    
    if (!viewController) return;
    
    self.moduleContext.inVC = viewController;
    
    __weak typeof(self) ws = self;
    __weak typeof(viewController) wsVC = viewController;
    // Aspect 提供了两个方法， 一个用于类， 一个用于实例
    // Aspects 允许我们选择 hook 的时机是在方法执行之前，还是方法执行之后，甚至可以直接替换掉方法的实现
    // 该方法返回一个 AspectToken 对象，这个对象主要是 aspect 的唯一标识符
    // 控制器的生命周期阶段； hook住控制器各个生命周期的方法
    // 在生命周期的不同阶段去初始化相应的moudule， 因为有的module是在viewDidLoad阶段初始化的， 有的moudle是在viewWillAppear阶段初始化的...

    id<AspectToken> didLoadToken = [viewController aspect_hookSelector:@selector(viewDidLoad)
                                                           withOptions:AspectPositionAfter
                                                            usingBlock:^{
                                                                ws.moduleContext.inView = wsVC.view;
                                                                CMCommonModuleAutoInit(CMCommonModuleInitViewDidLoad)
                                                                CMCommonModulePerformVCMethod(wsVC, viewDidLoad:)
                                                            } error:NULL];
    
    id<AspectToken> willAppearToken = [viewController aspect_hookSelector:@selector(viewWillAppear:)
                                                              withOptions:AspectPositionAfter
                                                               usingBlock:^{
                                                                   CMCommonModuleAutoInit(CMCommonModuleInitViewWillAppear)
                                                                   CMCommonModulePerformVCMethod(wsVC, viewWillAppear:)
                                                               } error:NULL];
    id<AspectToken> didAppearToken = [viewController aspect_hookSelector:@selector(viewDidAppear:)
                                                             withOptions:AspectPositionAfter
                                                              usingBlock:^{
                                                                  CMCommonModuleAutoInit(CMCommonModuleInitViewDidAppear)
                                                                  CMCommonModulePerformVCMethod(wsVC, viewDidAppear:)
                                                             } error:NULL];
    id<AspectToken> willDisToken = [viewController aspect_hookSelector:@selector(viewWillDisappear:)
                                                           withOptions:AspectPositionAfter
                                                            usingBlock:^{
                                                                CMCommonModulePerformVCMethod(wsVC, viewWillDisappear:)
                                                           } error:NULL];
    id<AspectToken> didDisToken = [viewController aspect_hookSelector:@selector(viewDidDisappear:)
                                                          withOptions:AspectPositionAfter
                                                           usingBlock:^{
                                                               CMCommonModulePerformVCMethod(wsVC, viewDidDisappear:)
                                                          } error:NULL];
    
    id<AspectToken> didReceiveMemoryWarningToken = [viewController aspect_hookSelector:@selector(didReceiveMemoryWarning)
                                                                           withOptions:AspectPositionAfter usingBlock:^{
                                                                               CMCommonModulePerformMethod(didReceiveMemoryWarning)
                                                                               } error:NULL];
    
    if (!self.aspectTokens) {
        self.aspectTokens = [NSMutableArray new];
    }
    [self.aspectTokens addObjectSafe:didLoadToken];
    [self.aspectTokens addObjectSafe:willAppearToken];
    [self.aspectTokens addObjectSafe:didAppearToken];
    [self.aspectTokens addObjectSafe:willDisToken];
    [self.aspectTokens addObjectSafe:didDisToken];
}

- (void)registerModuleWithProto:(Protocol *)proto
                       impClass:(Class)impClass
{
    [self registerModuleWithProto:proto
                         impClass:impClass
                         initType:CMCommonModuleInitAuto];
}

- (void)registerModuleWithProto:(Protocol *)proto
                       impClass:(Class)impClass
                       initType:(CMCommonModuleInitType)initType
{
    [self registerModuleWithProto:proto
                         impClass:impClass
                         initType:initType
                        toMapMode:nil];
}

- (void)registerModuleWithProto:(Protocol *)proto
                       impClass:(Class)impClass
                       initType:(CMCommonModuleInitType)initType
                      toMapMode:(id)mapMode
{
    NSParameterAssert(proto);
    NSParameterAssert(impClass);
    
    if (!proto || !impClass) { return; }
    
    if (![impClass conformsToProtocol:proto]) {
        NSAssert(NO, @">Moudle> %@ must be implementation %@ ...", impClass, NSStringFromProtocol(proto));
        return;
    }
    
    if (![impClass conformsToProtocol:@protocol(CMCommonModuleProtocol)]) {
        NSAssert(NO, @">Moudle> %@ must be implementation CMCommonModuleProtocol ...", impClass);
        return;
    }
    
    NSString *protoName = [self _getProtoNameWithProto:proto toMapMode:mapMode]; // get key
    [self.modulesClassDict setObject:impClass forKey:protoName];
    // 如果初始化时机里已经有该协议
    [self.moduleNamesInitDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSMutableArray<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj containsObject:protoName]) {
            [obj removeObject:protoName];
            *stop = YES;
        }
    }];
    
    if ([self.moduleNamesInitDict objectForKey:@(initType)]) {
        [[self.moduleNamesInitDict objectForKey:@(initType)] addObject:protoName];
    }
    
    if (initType == CMCommonModuleInitRegist) { //即刻初始化
        [self moduleWithProto:proto];
    }
}

- (id)moduleWithName:(NSString *)name
{
    return [self moduleWithProto:NSProtocolFromString(name)];
}

- (id)moduleWithProto:(Protocol *)proto
{
    return [self moduleWithProto:proto
                        autoInit:YES];
}

- (id)moduleWithProto:(Protocol *)proto
             autoInit:(BOOL)autoInit
{
    return [self moduleWithProto:proto
                         context:nil
                        autoInit:autoInit];
}

- (id)moduleWithProto:(Protocol *)proto
              context:(CMCommonModuleContext *)context
             autoInit:(BOOL)autoInit
{
    return [self moduleWithProto:proto
                         context:context
                        autoInit:autoInit
                       toMapMode:nil];
}

- (id)moduleWithProto:(Protocol *)proto
              context:(CMCommonModuleContext *)context
             autoInit:(BOOL)autoInit
            toMapMode:(id)mapMode
{
    NSParameterAssert(proto);
    
    if (!proto) return nil;
    
    if (self.isDestroyed) return nil;
    
    NSString *protoName = NSStringFromProtocol(proto);
    id<CMCommonModuleProtocol> module = [self.modulesDict objectForKey:protoName];
    if (!module) {
        module = [self.weakModulesObjTable objectForKey:protoName];
    }
    if (autoInit && !module) {
        NSString *protoClassKey = [self _getProtoNameWithProto:proto toMapMode:mapMode];
        Class class = [self.modulesClassDict objectForKey:protoClassKey];
        if (!class) {
//            NSString *className = [protoName stringByReplacingOccurrencesOfString:@"Protocol" withString:@""];
//            class = NSClassFromString(className);
            if (!class) return nil;
//            [self.modulesClassDict setObject:class forKey:protoName]; // 添加到映射表里
        }
        
        module = [[class alloc] initWithModuleContext:(context ?: self.moduleContext)];
        if (module) {
            [self.modulesDict setObject:module forKey:protoName];
        } else {
            NSLog(@">Moudle> %@ is nil ...", class);
        }
    }
    return module;
}

- (void)removeModuleWithProto:(Protocol *)proto
{
    NSParameterAssert(proto);
    
    if (!proto) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
    id<CMCommonModuleProtocol> module = [self.modulesDict objectForKey:protoName];
    if (module) {
        if ([module respondsToSelector:@selector(moduleDealloc:)]) {
            [module moduleDealloc:0];
        }
        [self.modulesDict removeObjectForKey:protoName];
    }
}

- (void)registerService:(Protocol *)proto
               impClass:(Class)impClass
{
    NSAssert([impClass conformsToProtocol:proto], @">Module>%@ must conform to %@ !...", impClass, NSStringFromProtocol(proto));
    NSParameterAssert(proto);
    NSParameterAssert(impClass);
    
    if (![impClass conformsToProtocol:proto]) {
        return;
    }
    NSString *name = NSStringFromProtocol(proto);
    if (!name || !impClass) {
        return;
    }
    [self.servicesDict setObject:impClass forKey:name];
}

- (id)serviceWithProto:(Protocol *)proto
{
    return [self serviceWithProto:proto
                          context:nil];
}

- (id)serviceWithProto:(Protocol *)proto
               context:(CMCommonModuleContext *)context
{
    NSParameterAssert(proto);
    
    if (!proto) return nil;
    
    if (self.isDestroyed) {
        return nil;
    }
    
    NSString *protoName = NSStringFromProtocol(proto);
    Class clz = self.servicesDict[protoName];
    if (!clz) return nil;
    
    id obj = [self.servicesObjTable objectForKey:protoName];
    if (obj) {
        return obj;
    }
    if ([clz respondsToSelector:@selector(initWithModuleContext:)]) {
        obj = [[clz alloc] initWithModuleContext:context? : self.moduleContext];
    } else {
        obj = [[clz alloc] init];
    }
    if (obj) {
        [self.servicesObjTable setObject:obj forKey:protoName];
    }
    return obj;
}

- (Class)serviceClassWithProto:(Protocol *)proto
{
    NSParameterAssert(proto);
    
    if (!proto) return nil;
    
    NSString *protoName = NSStringFromProtocol(proto);
    Class clz = self.servicesDict[protoName];
    return clz;
}

- (void)registerModuleObj:(id)obj
                  toProto:(Protocol *)proto
{
    NSParameterAssert(obj);
    NSParameterAssert(proto);
    if (!proto || !obj) {
        return;
    }
    NSString *protoName = NSStringFromProtocol(proto);
    [self.weakModulesObjTable setObject:obj forKey:protoName];
}

#pragma mark - dispatch

- (void)dispatchSelector:(SEL)aSel
                   param:(id)param, ...
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSString *selName = NSStringFromSelector(aSel);
    if (!selName) return;
    
    NSDictionary *currentModulesDict = self.modulesDict.copy ?: @{};
    for (NSString *key in currentModulesDict) {
        id<CMCommonModuleProtocol> obj = [currentModulesDict objectForKey:key];
        if ([obj respondsToSelector:aSel]) {
            va_list args;
            va_start(args, param);
            [self _respondObjSelector:aSel toObj:obj param:param vaList:args];
            va_end(args);
        }
    }
}

#pragma mark - Register Respond To Proto
- (void)registerRespondToProto:(Protocol *)proto
                          type:(NSInteger)type, ...
{
    
    NSParameterAssert(proto);
    if (!proto) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
    
    va_list args;
    va_start(args, type);
    
    NSInteger value = type;
    while (value) {
        [self _registerRespondToModule:protoName priority:CMCommonModuleRespondPriorityDefalut autoInit:YES key:@(value)];
        value =  va_arg(args, NSInteger);
    }
    va_end(args);
}

- (void)registerRespondToProto:(Protocol *)proto
                      priority:(CMCommonModuleRespondPriority)priority
                          type:(NSInteger)type, ...
{
    NSParameterAssert(proto);
    if (!proto) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
    
    va_list args;
    va_start(args, type);
    
    NSInteger value = type;
    while (value) {
        [self _registerRespondToModule:protoName priority:priority autoInit:YES key:@(value)];
        value =  va_arg(args, NSInteger);
    }
    va_end(args);
}

- (void)registerRespondToProto:(Protocol *)proto
                      priority:(CMCommonModuleRespondPriority)priority
                      autoInit:(BOOL)autoInit
                          type:(NSInteger)type, ...
{
    NSParameterAssert(proto);
    if (!proto) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
    
    va_list args;
    va_start(args, type);
    
    NSInteger value = type;
    while (value) {
        [self _registerRespondToModule:protoName priority:priority autoInit:autoInit key:@(value)];
        value =  va_arg(args, NSInteger);
    }
    va_end(args);
}

#pragma mark - Register Respond Selector

- (void)registerRespondSelector:(SEL)aSel
                        toProto:(Protocol *)proto
{
    [self registerRespondSelector:aSel
                          toProto:proto
                         priority:CMCommonModuleRespondPriorityDefalut];
}

- (void)registerRespondSelector:(SEL)aSel
                        toProto:(Protocol *)proto
                       priority:(CMCommonModuleRespondPriority)priority
{
    [self registerRespondSelector:aSel
                          toProto:proto
                         priority:priority
                         autoInit:YES];
}

- (void)registerRespondSelector:(SEL)aSel
                        toProto:(Protocol *)proto
                       priority:(CMCommonModuleRespondPriority)priority
                       autoInit:(BOOL)autoInit
{
    NSParameterAssert(proto);
    NSParameterAssert(aSel);
    if (!proto || !aSel) return;
    
    NSString *protoName = NSStringFromProtocol(proto);
    NSString *selName = NSStringFromSelector(aSel);
    [self _registerRespondToModule:protoName
                          priority:priority
                          autoInit:autoInit
                               key:selName];
}

#pragma mark - Respond
- (void)respondType:(NSInteger)type
 selectorWithParams:(SEL)aSel, ...
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSNumber *typeKey = @(type);
    NSMutableOrderedSet <CMCommonModuleRespondModel *> *set = [self.respondNames objectForKey:typeKey];
    for (CMCommonModuleRespondModel *obj in set) {
        id module = [self moduleWithName:obj.name];
        if (!module) continue;
        
        va_list args;
        va_start(args, aSel);
        [CMInvocation cm_target:module invokeSelector:aSel args:args];
        va_end(args);
    }
}

- (void)respondType:(NSInteger)type
           selector:(SEL)aSel
              param:(id)param, ...
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSNumber *typeKey = @(type);
    NSMutableOrderedSet <CMCommonModuleRespondModel *> *set = [self.respondNames objectForKey:typeKey];
    for (CMCommonModuleRespondModel *obj in set) {
        id module = [self moduleWithProto:NSProtocolFromString(obj.name) autoInit:obj.autoInit];
        if (!module) continue;
        
        va_list args;
        va_start(args, param);
        [self _respondObjSelector:aSel toObj:module param:param vaList:args];
        va_end(args);
    }
}

- (void)respondSelector:(SEL)aSel
                  param:(id)param, ...
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSString *selName = NSStringFromSelector(aSel);
    if (!selName) return;
    
    NSMutableOrderedSet <CMCommonModuleRespondModel *> *set = [self.respondNames objectForKey:selName];
    for (CMCommonModuleRespondModel *obj in set.copy) {
        id module = [self moduleWithProto:NSProtocolFromString(obj.name) autoInit:obj.autoInit];
        if (!module) continue;
        
        va_list args;
        va_start(args, param);
        [self _respondObjSelector:aSel toObj:module param:param vaList:args];
        va_end(args);
    }
}

- (void)respondSelectorWithParams:(SEL)aSel, ...
{
    NSParameterAssert(aSel);
    if (!aSel) return;
    
    NSString *selName = NSStringFromSelector(aSel);
    if (!selName) return;
    
    NSMutableOrderedSet <CMCommonModuleRespondModel *> *set = [self.respondNames objectForKey:selName];
    for (CMCommonModuleRespondModel *obj in set) {
        id module = [self moduleWithName:obj.name];
        if (!module) continue;
        
        va_list args;
        va_start(args, aSel);
        [CMInvocation cm_target:module invokeSelector:aSel args:args];
        va_end(args);
    }
}

#pragma mark - Private Methods

- (void)_vorDeallocModules:(NSInteger)reason
{
    if (self.isDestroyed) return;
    self.destroyed = YES;
    [self.modulesDict enumerateKeysAndObjectsUsingBlock:^(NSString  * _Nonnull key, id<CMCommonModuleProtocol>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(moduleDealloc:)]) {
            [obj moduleDealloc:reason];
        }
    }];
    [self.aspectTokens enumerateObjectsUsingBlock:^(id<AspectToken>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj remove];
    }];
}

- (void)_respondObjSelector:(SEL)aSel
                      toObj:(id)obj
                      param:(id)param
                     vaList:(va_list)args
{
    NSParameterAssert(aSel);
    NSParameterAssert(obj);
    
    if (!aSel || !obj) return;
    
    NSMethodSignature *signature = [obj methodSignatureForSelector: aSel];
    NSParameterAssert(signature);
    if (!signature) return;
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = obj;
    invocation.selector = aSel;
    if (!invocation) return;
    
    /**
     0 -> self
     1 -> selector
     2 -> 第一个参数
     */
    
    NSUInteger tArgIndex = 2;
    NSUInteger argumentCount = signature.numberOfArguments;
    
    const char *argType = [signature getArgumentTypeAtIndex:2];
    // Skip const type qualifier.
    if (argType[0] == _C_CONST) argType++;
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        tArgIndex = 3;
        [invocation setArgument:&param atIndex:2];
        if (argumentCount == 3) { // 只有一个参数直接invoke
            [invocation invoke];
            return;
        }
    }
    
    for (NSUInteger argIndex = tArgIndex; argIndex < argumentCount; argIndex ++) {
        [self _setInvocationArgument:signature invocation:invocation argIndex:argIndex vaList:args];
    }
    
    [invocation invoke];
}

- (void)_setInvocationArgument:(NSMethodSignature *)signature
                    invocation:(NSInvocation *)invocation
                      argIndex:(NSUInteger)argIndex
                        vaList:(va_list)args
{
    const char *argType = [signature getArgumentTypeAtIndex:argIndex];
    
    // Skip const type qualifier.
    if (argType[0] == _C_CONST) argType++;
    
    if (strcmp(argType, @encode(id)) == 0 || strcmp(argType, @encode(Class)) == 0) {
        id valueObj = va_arg(args, id);
        [invocation setArgument:&valueObj atIndex:argIndex];
    } else if (strcmp(argType, @encode(SEL)) == 0) {
        SEL selector = va_arg(args, SEL);
        [invocation setArgument:&selector atIndex:argIndex];
    } else if (strcmp(argType, @encode(Class)) == 0) {
        Class theClass = va_arg(args, Class);
        [invocation setArgument:&theClass atIndex:argIndex];
    } else if (strcmp(argType, @encode(char)) == 0) {
        char ch = va_arg(args, int);
        [invocation setArgument:&ch atIndex:argIndex];
    } else if (strcmp(argType, @encode(int)) == 0) {
        int value = va_arg(args, int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(short)) == 0) {
        short value = va_arg(args, int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(long)) == 0) {
        long value = va_arg(args, long);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(long long)) == 0) {
        long long value = va_arg(args, long long);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned char)) == 0) {
        unsigned char value = va_arg(args, unsigned int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned int)) == 0) {
        unsigned int value = va_arg(args, unsigned int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned short)) == 0) {
        unsigned short value = va_arg(args, unsigned int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned long)) == 0) {
        unsigned long value = va_arg(args, unsigned long);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(unsigned long long)) == 0) {
        unsigned long long value = va_arg(args, unsigned long long);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(float)) == 0) {
        float value = va_arg(args, double);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(double)) == 0) {
        double value = va_arg(args, double);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(BOOL)) == 0) {
        BOOL value = va_arg(args, int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(bool)) == 0) {
        bool value = va_arg(args, int);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(char *)) == 0) {
        char * value = va_arg(args, char *);
        [invocation setArgument:&value atIndex:argIndex];
    } else if (strcmp(argType, @encode(void (^)(void))) == 0) {
        id value = va_arg(args, id);
        [invocation setArgument:&value atIndex:argIndex];
    } else {
        char *values = va_arg(args, char *);
        NSValue *va = [NSValue valueWithBytes:values objCType:argType];
        [invocation setArgument:&va atIndex:argIndex];
    }
}

- (void)_registerRespondToModule:(NSString *)name
                        priority:(CMCommonModuleRespondPriority)priority
                        autoInit:(BOOL)autoInit
                             key:(id)key
{
    if (!key) return;
    
    NSMutableOrderedSet<CMCommonModuleRespondModel *> *set = [self.respondNames objectForKey:key];
    if (!set) {
        set = [[NSMutableOrderedSet alloc] init];
        [self.respondNames setObject:set forKey:key];
    }
    CMCommonModuleRespondModel *reportModel = [[CMCommonModuleRespondModel alloc] init];
    reportModel.name = name;
    reportModel.priority = priority;
    reportModel.autoInit = autoInit;
    
    if ([set containsObject:reportModel]) {
        [set removeObject:reportModel];
    }
    
    __block BOOL hasInsert = NO;
    [set enumerateObjectsUsingBlock:^(CMCommonModuleRespondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.priority <= priority) {
            [set insertObject:reportModel atIndex:idx];
            hasInsert = YES;
            *stop = YES;
        }
    }];
    if (!hasInsert) {
        [set addObject:reportModel];
    }
}

- (NSString *)_getProtoNameWithProto:(Protocol *)proto
                           toMapMode:(id)mapMode
{
    NSString *protoName = NSStringFromProtocol(proto);
    if (mapMode) {
        protoName = [NSString stringWithFormat:@"%@__%@", protoName, mapMode];
    }
    return protoName;
}

@end
