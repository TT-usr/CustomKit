//
//  CMCommonModuleLifeCycleProtocol.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

@class UIViewController;

@protocol CMCommonModuleLifeCycleProtocol <NSObject>

@optional

- (void)viewDidLoad:(__kindof UIViewController *)vc;

- (void)viewWillAppear:(__kindof UIViewController *)vc;
- (void)viewDidAppear:(__kindof UIViewController *)vc;

- (void)viewWillDisappear:(__kindof UIViewController *)vc;
- (void)viewDidDisappear:(__kindof UIViewController *)vc;

- (void)didReceiveMemoryWarning;

@end
