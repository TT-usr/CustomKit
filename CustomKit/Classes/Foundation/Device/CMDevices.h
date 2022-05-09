//
//  CMDevices.h
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMDevices : NSObject

@property (nonatomic, assign, readonly) CGFloat screenWidth;
@property (nonatomic, assign, readonly) CGFloat screenHeight;
@property (nonatomic, assign, readonly) CGFloat topSafeArea;
@property (nonatomic, assign, readonly) CGFloat bottomSafeArea;
@property (nonatomic, assign, readonly) CGFloat screenScale;
@property (nonatomic, assign, readonly) CGFloat statusBarHeight;

@property (nonatomic, assign, getter=isSmalliPhone, readonly) BOOL smalliPhone;

@property (nonatomic, copy, readonly) NSString *modelIdentifier;
@property (nonatomic, copy, readonly) NSString *modelName;

@property (nonatomic, copy, readonly) NSString *systemName;
@property (nonatomic, copy, readonly) NSString *systemVersion;

@property (nonatomic, copy, readonly) NSString *appVersion;
@property (nonatomic, copy, readonly) NSString *appShortVersion;

@property (nonatomic, copy, readonly, nullable) NSString *simCountryCode;
@property (nonatomic, copy, readonly, nullable) NSString *carrierName;

@property (nonatomic, assign, readonly) BOOL iPhoneX;

+ (instancetype)sharedDevice;

+ (BOOL)openAppSettings;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
