//
//  MDInvocation.h
//  MomoChat
//
//  Created by Zero.D.Saber on 2019/9/20.
//  Copyright © 2019 wemomo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMInvocation<__covariant R : id> : NSObject

+ (R)cm_target:(id)target invokeSelectorWithArgs:(SEL)selector, ...;

+ (R)cm_target:(id)target invokeSelector:(SEL)selector args:(va_list)args;

@end

NS_ASSUME_NONNULL_END
