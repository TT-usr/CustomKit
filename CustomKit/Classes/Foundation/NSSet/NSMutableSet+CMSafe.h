//
//  NSMutableSet+CMSafe.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet<ObjectType> (CMSafe)

// 排除nil
- (void)addObjectSafe:(ObjectType)object;

- (void)removeObjectSafe:(ObjectType)object;

@end
