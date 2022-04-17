//
//  CMFoundation.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//


#ifndef CMFoundation_h
#define CMFoundation_h

// NSObject
#if __has_include(<Foundation/NSObject+Swizzle.h>)
#import <Foundation/NSObject+Swizzle.h>
#import <Foundation/NSObject+CMUtility.h>
#import <Foundation/NSObject+DebugConfiguration.h>
#endif

// NSString
#if __has_include(<Foundation/NSString+Extension.h>)
#import <Foundation/NSString+Extension.h>
#endif

// NSSet
#if __has_include(<Foundation/NSMutableSet+CMSafe.h>)
#import <Foundation/NSMutableSet+CMSafe.h>
#endif

// Invocation
#if __has_include(<Foundation/CMInvocation.h>)
#import <Foundation/CMInvocation.h>
#endif

// NSDictionary
#if __has_include(<Foundation/NSDictionary+CMSafe.h>)
#import <Foundation/CMDictionaryAccessor.h>
#import <Foundation/NSObject+CMDictionaryAdapterPrivate.h>
#import <Foundation/NSDictionary+CMSafe.h>
#import <Foundation/NSDictionary+URLQueryComponents.h>
#endif

// NSArray
#if __has_include(<Foundation/NSArray+CMSafe.h>)
#import <Foundation/NSArray+CMSafe.h>
#import <Foundation/NSArray+CMUtility.h>
#endif

// NSData
#if __has_include(<Foundation/NSData+ConverString.h>)
#import <Foundation/NSData+ConverString.h>
#endif

// NSDate
#if __has_include(<Foundation/NSDate+CMFormat.h>)
#import <Foundation/NSDate+CMFormat.h>
#import <Foundation/NSDate+Utilities.h>
#import <Foundation/NSDate+CMUtility.h>
#endif

// NSNull
#if __has_include(<Foundation/NSNull+CMSafe.h>)
#import <Foundation/NSNull+CMSafe.h>
#endif

// NSFileManager
#if __has_include(<Foundation/NSFileManager+Paths.h>)
#import <Foundation/NSFileManager+Paths.h>
#endif

// JSON
#if __has_include(<Foundation/CMJSONHelper.h>)
#import <Foundation/CMJSONHelper.h>
#endif

#endif /* Foundation_h */
