//
//  CMCommonModuleContext.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMCommonModuleContext : NSObject

@property (nonatomic, weak)   UIView            *inView;
@property (nonatomic, weak)   UIViewController  *inVC;
@property (nonatomic, assign) NSInteger         atIndex;

@property (nonatomic, assign, getter=isSuspension) BOOL suspension;

@property (nonatomic, copy)   NSString     *businessID;
@property (nonatomic, strong) NSDictionary *sourceInfo;
@property (nonatomic, strong) id           extraObj;

@end

NS_ASSUME_NONNULL_END
