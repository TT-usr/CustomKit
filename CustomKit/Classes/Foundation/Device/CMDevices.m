//
//  CMDevices.m
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

#import "CMDevices.h"
#import <sys/sysctl.h>
#import <net/if.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface CMDevices ()

@property (nonatomic, assign, readwrite) CGFloat screenWidth;
@property (nonatomic, assign, readwrite) CGFloat screenHeight;
@property (nonatomic, assign, readwrite) CGFloat topSafeArea;
@property (nonatomic, assign, readwrite) CGFloat bottomSafeArea;
@property (nonatomic, assign, readwrite) CGFloat screenScale;
@property (nonatomic, assign, readwrite) CGFloat statusBarHeight;

@property (nonatomic, assign, getter=isSmalliPhone, readwrite) BOOL smalliPhone;

@property (nonatomic, copy, readwrite) NSString *simCountryCode;
@property (nonatomic, copy, readwrite) NSString *carrierName;

@end

@implementation CMDevices
@synthesize systemName = _systemName, systemVersion = _systemVersion,
            appVersion = _appVersion, appShortVersion = _appShortVersion;

+ (instancetype)sharedDevice {
    static CMDevices *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (BOOL)openAppSettings {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        return YES;
    }
    return NO;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIApplication *application = [UIApplication sharedApplication];
        UIInterfaceOrientation deviceOrientation = [application statusBarOrientation];
        
        CGRect screenBounds = [UIScreen mainScreen].bounds;
        
        if (deviceOrientation == UIInterfaceOrientationLandscapeLeft ||
            deviceOrientation == UIInterfaceOrientationLandscapeRight) {
            self.screenWidth = CGRectGetHeight([[application.delegate window] bounds]);
            self.screenHeight =  CGRectGetWidth(screenBounds);
        } else {
            self.screenWidth = CGRectGetWidth(screenBounds);
            self.screenHeight = CGRectGetHeight(screenBounds);
        }
        //
        if (@available(iOS 11.0, *)) {
            UIWindow *window = application.keyWindow ?: application.delegate.window;
            if (window == nil) {
                window = application.windows.firstObject;
            }
            UIEdgeInsets safeAreaInsets = window.safeAreaInsets;
            self.topSafeArea = safeAreaInsets.top;
            self.bottomSafeArea = safeAreaInsets.bottom;
        }
        //
        self.smalliPhone = (self.screenWidth < 375.0f);
    }
    return self;
}

- (void)updateIfNeed {
    if (CGRectGetHeight([[[UIApplication sharedApplication].delegate window] bounds]) > CGRectGetWidth([[UIScreen mainScreen] bounds])) {
        self.screenHeight = CGRectGetHeight([[[UIApplication sharedApplication].delegate window] bounds]);
    }
}

- (BOOL)iPhoneX {
    static BOOL _iPhoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone && @available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].delegate.window;
            if (window == nil) {
                window = [UIApplication sharedApplication].windows.firstObject;
            }
            _iPhoneX = (window.safeAreaInsets.bottom > 0.0f);
        }
    });
    return _iPhoneX;
}

- (CGFloat)statusBarHeight {
    if (_statusBarHeight == .0f) {
        _statusBarHeight = self.iPhoneX ? self.topSafeArea : 20.0f;
    }
    return _statusBarHeight;
}

- (NSString *)modelIdentifier {
    static NSString *_modelIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
#if TARGET_IPHONE_SIMULATOR
        _modelIdentifier = NSProcessInfo.processInfo.environment[@"SIMULATOR_MODEL_IDENTIFIER"];
#else
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = (char *)malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        _modelIdentifier = @(machine);
        free(machine);
#endif
    });
    return _modelIdentifier;
}

- (NSString *)modelName {
    static NSString *_modelName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *models = @{
            @"AppleTV2,1": @"Apple TV 2",
            @"AppleTV3,1": @"Apple TV 3",
            @"AppleTV3,2": @"Apple TV 3",
            @"AppleTV5,3": @"Apple TV 4",
            @"AppleTV6,2": @"Apple TV 4K",
            @"iPad1,1": @"iPad",
            @"iPad2,1": @"iPad 2",
            @"iPad2,2": @"iPad 2",
            @"iPad2,3": @"iPad 2",
            @"iPad2,4": @"iPad 2",
            @"iPad2,5": @"iPad mini",
            @"iPad2,6": @"iPad mini",
            @"iPad2,7": @"iPad mini",
            @"iPad3,1": @"iPad 3",
            @"iPad3,2": @"iPad 3",
            @"iPad3,3": @"iPad 3",
            @"iPad3,4": @"iPad 4",
            @"iPad3,5": @"iPad 4",
            @"iPad3,6": @"iPad 4",
            @"iPad4,1": @"iPad Air",
            @"iPad4,2": @"iPad Air",
            @"iPad4,3": @"iPad Air",
            @"iPad4,4": @"iPad mini 2",
            @"iPad4,5": @"iPad mini 2",
            @"iPad4,6": @"iPad mini 2",
            @"iPad4,7": @"iPad mini 3",
            @"iPad4,8": @"iPad mini 3",
            @"iPad4,9": @"iPad mini 3",
            @"iPad5,1": @"iPad mini 4",
            @"iPad5,2": @"iPad mini 4",
            @"iPad5,3": @"iPad Air 2",
            @"iPad5,4": @"iPad Air 2",
            @"iPad6,3": @"iPad Pro (9.7-inch)",
            @"iPad6,4": @"iPad Pro (9.7-inch)",
            @"iPad6,7": @"iPad Pro (12.9-inch)",
            @"iPad6,8": @"iPad Pro (12.9-inch)",
            @"iPad6,11": @"iPad 5",
            @"iPad6,12": @"iPad 5",
            @"iPad7,1": @"iPad Pro 2 (12.9-inch)",
            @"iPad7,2": @"iPad Pro 2 (12.9-inch)",
            @"iPad7,3": @"iPad Pro 2 (10.5-inch)",
            @"iPad7,4": @"iPad Pro 2 (10.5-inch)",
            @"iPad7,5": @"iPad 6",
            @"iPad7,6": @"iPad 6",
            @"iPad7,11": @"iPad 7",
            @"iPad7,12": @"iPad 7",
            @"iPad8,1": @"iPad Pro 3 (11-inch)",
            @"iPad8,2": @"iPad Pro 3 (11-inch)",
            @"iPad8,3": @"iPad Pro 3 (11-inch)",
            @"iPad8,4": @"iPad Pro 3 (11-inch)",
            @"iPad8,5": @"iPad Pro 3 (12.9-inch)",
            @"iPad8,6": @"iPad Pro 3 (12.9-inch)",
            @"iPad8,7": @"iPad Pro 3 (12.9-inch)",
            @"iPad8,8": @"iPad Pro 3 (12.9-inch)",
            @"iPad8,9": @"iPad Pro 4 (11-inch)",
            @"iPad8,10": @"iPad Pro 4 (11-inch)",
            @"iPad8,11": @"iPad Pro 4 (12.9-inch)",
            @"iPad8,12": @"iPad Pro 4 (12.9-inch)",
            @"iPad11,1": @"iPad mini 5",
            @"iPad11,2": @"iPad mini 5",
            @"iPad11,3": @"iPad Air 3",
            @"iPad11,4": @"iPad Air 3",
            @"iPhone1,1": @"iPhone",
            @"iPhone1,2": @"iPhone 3G",
            @"iPhone2,1": @"iPhone 3GS",
            @"iPhone3,1": @"iPhone 4",
            @"iPhone3,2": @"iPhone 4",
            @"iPhone3,3": @"iPhone 4",
            @"iPhone4,1": @"iPhone 4S",
            @"iPhone5,1": @"iPhone 5",
            @"iPhone5,2": @"iPhone 5",
            @"iPhone5,3": @"iPhone 5c",
            @"iPhone5,4": @"iPhone 5c",
            @"iPhone6,1": @"iPhone 5s",
            @"iPhone6,2": @"iPhone 5s",
            @"iPhone7,1": @"iPhone 6 Plus",
            @"iPhone7,2": @"iPhone 6",
            @"iPhone8,1": @"iPhone 6s",
            @"iPhone8,2": @"iPhone 6s Plus",
            @"iPhone8,4": @"iPhone SE",
            @"iPhone9,1": @"iPhone 7",
            @"iPhone9,2": @"iPhone 7 Plus",
            @"iPhone9,3": @"iPhone 7",
            @"iPhone9,4": @"iPhone 7 Plus",
            @"iPhone10,1": @"iPhone 8",
            @"iPhone10,2": @"iPhone 8 Plus",
            @"iPhone10,3": @"iPhone X",
            @"iPhone10,4": @"iPhone 8",
            @"iPhone10,5": @"iPhone 8 Plus",
            @"iPhone10,6": @"iPhone X",
            @"iPhone11,2": @"iPhone XS",
            @"iPhone11,4": @"iPhone XS Max",
            @"iPhone11,6": @"iPhone XS Max",
            @"iPhone11,8": @"iPhone XR",
            @"iPhone12,1": @"iPhone 11",
            @"iPhone12,3": @"iPhone 11 Pro",
            @"iPhone12,5": @"iPhone 11 Pro Max",
            @"iPhone12,8": @"iPhone SE (2nd generation)",
            @"iPhone13,1": @"iPhone 12 mini",
            @"iPhone13,2": @"iPhone 12",
            @"iPhone13,3": @"iPhone 12 Pro",
            @"iPhone13,4": @"iPhone 12 Pro Max",
            @"iPhone14,4": @"iPhone13 mini",
            @"iPhone14,5": @"iPhone13",
            @"iPhone14,2": @"iPhone13 Pro",
            @"iPhone14,3": @"iPhone13 Pro Max",
            @"iPod1,1": @"iPod touch",
            @"iPod2,1": @"iPod touch 2",
            @"iPod3,1": @"iPod touch 3",
            @"iPod4,1": @"iPod touch 4",
            @"iPod5,1": @"iPod touch 5",
            @"iPod7,1": @"iPod touch 6",
            @"iPod9,1": @"iPod touch 7",
            @"Watch1,1": @"Apple Watch (38mm)",
            @"Watch1,2": @"Apple Watch (42mm)",
            @"Watch2,3": @"Apple Watch Series 2 (38mm)",
            @"Watch2,4": @"Apple Watch Series 2 (42mm)",
            @"Watch2,6": @"Apple Watch Series 1 (38mm)",
            @"Watch2,7": @"Apple Watch Series 1 (42mm)",
            @"Watch3,1": @"Apple Watch Series 3 (38mm, LTE)",
            @"Watch3,2": @"Apple Watch Series 3 (42mm, LTE)",
            @"Watch3,3": @"Apple Watch Series 3 (38mm)",
            @"Watch3,4": @"Apple Watch Series 3 (42mm)",
            @"Watch4,1": @"Apple Watch Series 4 (40mm)",
            @"Watch4,2": @"Apple Watch Series 4 (44mm)",
            @"Watch4,3": @"Apple Watch Series 4 (40mm, LTE)",
            @"Watch4,4": @"Apple Watch Series 4 (44mm, LTE)",
            @"Watch5,1": @"Apple Watch Series 5 (40mm)",
            @"Watch5,2": @"Apple Watch Series 5 (44mm)",
            @"Watch5,3": @"Apple Watch Series 5 (40mm, LTE)",
            @"Watch5,4": @"Apple Watch Series 5 (44mm, LTE)",
            @"i386": @"Simulator",
            @"x86_64": @"Simulator",
        };
        _modelName = models[self.modelIdentifier] ?: self.modelIdentifier;
    });
    return _modelName;
}

- (NSString *)systemName {
    if (!_systemName) {
        _systemName = [UIDevice currentDevice].systemName;
    }
    return _systemName;
}

- (NSString *)systemVersion {
    if (!_systemVersion) {
        _systemVersion = [UIDevice currentDevice].systemVersion;
    }
    return _systemVersion;
}

- (CGFloat)screenScale {
    if (_screenScale == 0) {
        _screenScale = [UIScreen mainScreen].scale;
    }
    return _screenScale;
}

- (NSString *)appVersion {
    if (!_appVersion) {
        _appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _appVersion;
}

- (NSString *)appShortVersion {
    if (!_appShortVersion) {
        _appShortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    }
    return _appShortVersion;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4 {
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)simCountryCode {
    if (!_simCountryCode) {
        CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = nil;
        if (@available(iOS 12.1, *)) {
            NSDictionary<NSString *, CTCarrier *> *carriers = [telephonyNetworkInfo serviceSubscriberCellularProviders];
            if ([carrier isKindOfClass:[NSDictionary class]]) {
                carrier = carriers.allValues.firstObject;
            }
        } else if (@available(iOS 12, *)) {
            NSDictionary<NSString *, CTCarrier *> *carriers = [telephonyNetworkInfo valueForKey:@"serviceSubscriberCellularProvider"];
            if ([carrier isKindOfClass:[NSDictionary class]]) {
                carrier = carriers.allValues.firstObject;
            }
        }
        // 低版本兼容
        if (carrier == nil && [telephonyNetworkInfo respondsToSelector:@selector(subscriberCellularProvider)]) {
            carrier = [telephonyNetworkInfo subscriberCellularProvider];
        }
        _simCountryCode = carrier.isoCountryCode.uppercaseString;
    }
    return _simCountryCode;
}

- (NSString *)carrierName {
    if (!_carrierName) {
        CTTelephonyNetworkInfo *telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
        CTCarrier *carrier = nil;
        if (@available(iOS 12.1, *)) {
            NSDictionary<NSString *, CTCarrier *> *carriers = [telephonyNetworkInfo serviceSubscriberCellularProviders];
            if ([carrier isKindOfClass:[NSDictionary class]]) {
                carrier = carriers.allValues.firstObject;
            }
        } else if (@available(iOS 12, *)) {
            NSDictionary<NSString *, CTCarrier *> *carriers = [telephonyNetworkInfo valueForKey:@"serviceSubscriberCellularProvider"];
            if ([carrier isKindOfClass:[NSDictionary class]]) {
                carrier = carriers.allValues.firstObject;
            }
        }
        // 低版本兼容
        if (carrier == nil && [telephonyNetworkInfo respondsToSelector:@selector(subscriberCellularProvider)]) {
            carrier = [telephonyNetworkInfo subscriberCellularProvider];
        }
        if (carrier.isoCountryCode) {
            _carrierName = carrier.carrierName;
        }
    }
    return _carrierName;
}

@end
