//
//  CMCommonModuleDefine.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#ifndef MBCommonModuleDefine_h
#define MBCommonModuleDefine_h

// 定义modules 传递消息的回调block类型 无参可以随意传递参数
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
// 参数不能为bool 值， bool值会报错
typedef id(^CMCommonModulesCallback)();
#pragma clang diagnostic pop

/**
 module初始化时机
 
 - CMCommonModuleInitAuto: 自动/用到的时候才会初始
 - CMCommonModuleInitViewDidLoad: viewController didload
 - CMCommonModuleInitViewWillAppear: viewController willAppear
 - CMCommonModuleInitViewDidAppear: viewController didAppear
 - CMCommonModuleInitRegist: 注册即初始化
 */
typedef NS_ENUM(NSInteger, CMCommonModuleInitType) {
    CMCommonModuleInitAuto           = 0,
    CMCommonModuleInitViewDidLoad    = 1,
    CMCommonModuleInitViewWillAppear = 2,
    CMCommonModuleInitViewDidAppear  = 3,
    CMCommonModuleInitRegist         = 4,
};

/**
 响应优先级 默认defalut
 */
typedef NS_ENUM(NSInteger, CMCommonModuleRespondPriority) {
    CMCommonModuleRespondPriorityLow      = -100,
    CMCommonModuleRespondPriorityDefalut  = 0,
    CMCommonModuleRespondPriorityHigh     = 100,
};

#endif /* MBCommonModuleDefine_h */
