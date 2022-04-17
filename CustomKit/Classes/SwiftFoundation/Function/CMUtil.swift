//
//  MMSUtil.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import UIKit

public enum CMUtil {}

public extension CMUtil {
    
    // https://twitter.com/johnsundell/status/1055562781070684162
    func combine<A, B>(_ value: A, with closure: @escaping (A) -> B) -> () -> B {
        return { closure(value) }   // <==> { () in closure(value) }
    }
    
    /// 字符串格式化
    static func stringFormat(_ string: String?, defaultString: String? = "") -> String {
        if isStringNil(string) {
            if self.isStringNil(defaultString) {
                return ""
            }
            return defaultString!
        }
        return string!
    }
}

// MARK: - Thread
public extension CMUtil {
    
    static func isMainThread() -> Bool {
        return 0 != pthread_main_np()
    }

    static func assertMainThread() {
        assert(isMainThread(), "Must execute on main thread")
    }

    static func executeOnMainThread(_ closure: @escaping ()-> Void) {
        if isMainThread() {
            closure()
        } else {
            DispatchQueue.main.async(execute: closure)
        }
    }
}

// MARK: - Verify
public extension CMUtil {

    /// 字符串是否为空
    static func isStringNil(_ string: String?) -> Bool {
        if let str = string {
            return str.isEmpty
        }
        return false
    }
    
    /// array是否为空
    static func isArrayNil(_ array: Array<Any?>?) -> Bool {
        if let arr = array, arr.count > 0 {
            return true
        }
        return false
    }
    
    /// 判断是否是整数
    static func isInt(float: Float) -> Bool {
        if floor(float) == ceil(float) { // 向下取整 == 向上取整
            return true
        }
        return false
    }
}
