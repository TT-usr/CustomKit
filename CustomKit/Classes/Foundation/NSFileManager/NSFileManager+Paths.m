//
//  NSFileManager+Paths.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "NSFileManager+Paths.h"
#include <sys/xattr.h>

@implementation NSFileManager (CMPaths)

+ (NSURL *)CM_URLForDirectory:(NSSearchPathDirectory)directory
{
    return [self.defaultManager URLsForDirectory:directory inDomains:NSUserDomainMask].lastObject;
}

+ (NSString *)CM_pathForDirectory:(NSSearchPathDirectory)directory
{
    return NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES).firstObject;
}

+ (NSURL *)CM_documentsURL
{
    return [self CM_URLForDirectory:NSDocumentDirectory];
}

+ (NSString *)CM_documentsPath
{
    return [self CM_pathForDirectory:NSDocumentDirectory];
}

+ (NSURL *)CM_libraryURL
{
    return [self CM_URLForDirectory:NSLibraryDirectory];
}

+ (NSString *)CM_libraryPath
{
    return [self CM_pathForDirectory:NSLibraryDirectory];
}

+ (NSURL *)CM_cachesURL
{
    return [self CM_URLForDirectory:NSCachesDirectory];
}

+ (NSString *)CM_cachesPath
{
    return [self CM_pathForDirectory:NSCachesDirectory];
}

+ (NSURL *)CM_applicationSupportURL
{
    return [self CM_URLForDirectory:NSApplicationSupportDirectory];
}

+ (NSString *)CM_applicationSupportPath
{
    return [self CM_pathForDirectory:NSApplicationSupportDirectory];
}

+ (NSURL *)CM_tempURL
{
    NSString *path = NSTemporaryDirectory();
    return [NSURL fileURLWithPath:path];
}

+ (NSString *)CM_tempPath
{
    return NSTemporaryDirectory();
}

@end
