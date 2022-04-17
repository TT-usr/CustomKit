//
//  Dictionary+Extention.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

extension Dictionary: CMAny {}

public extension CMWrapper where T == [AnyHashable: Any] {
    
    /// 字典合并
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: T.Key, value: T.Value) {
            for (key, value) in other {
                self.base[key] = value
        }
    }
    
    /// 字典 -> JSONString
    func jsonString() -> String {
        guard JSONSerialization.isValidJSONObject(self.base) else {
            return ""
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self.base, options: []) else {
            return ""
        }
        let JSONString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        return JSONString ?? ""
    }
}

public extension Dictionary {
    
    /// 从字典取值并设置非空的默认值
    subscript(mms key: Key, defaultValue: Value) -> Value {
        return self[key] ?? defaultValue
    }
}

public extension Dictionary where Key == String {
    
    ///字典 -> JSONString
    func jsonString() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            return ""
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""
        }
        let JSONString = NSString(data:data, encoding: String.Encoding.utf8.rawValue) as String?
        return JSONString ?? ""
    }
}
