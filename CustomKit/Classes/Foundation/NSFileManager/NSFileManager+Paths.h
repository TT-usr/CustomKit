//
//  NSFileManager+Paths.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (CMPaths)

/**
 *  沙盒目录中document,library,caches的URL
 */
+ (NSURL *)CM_documentsURL;
+ (NSURL *)CM_libraryURL;
+ (NSURL *)CM_cachesURL;
+ (NSURL *)CM_applicationSupportURL;
+ (NSURL *)CM_tempURL;

/**
 *  沙盒目录中document,library,caches的Path
 */
+ (NSString *)CM_documentsPath;
+ (NSString *)CM_libraryPath;
+ (NSString *)CM_cachesPath;
+ (NSString *)CM_applicationSupportPath;
+ (NSString *)CM_tempPath;

@end
