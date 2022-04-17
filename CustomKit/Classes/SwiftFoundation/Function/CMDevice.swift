//
//  CMDevice.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import UIKit
import AdSupport

public struct CMDeviceInfo {
    private init() {}
}
public extension CMDeviceInfo {
    /// 广告位标识符：在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在设置|隐私|广告追踪里重置此id的值，或限制此id的使用，故此id有可能会取不到值
    static var idfa: String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    
    /// idfv
    static var idfv: String? = UIDevice.current.identifierForVendor?.uuidString
}

public struct CMApplicationInfo {
    private init() {}
}

public extension CMApplicationInfo {
    /// 应用名
    static var displayName: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    
    /// 工程名
    static var projectName: String? =  Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        
    /// App 的内部版本
    static var build: String? = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    
    /// App 的版本
    static var shortVersion: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    
    /// 设备的唯一标识字符串,
    static var identifier: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
    }
}
