//
//  String+Json.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

public extension CMWrapper where T == String {
    
    /// JSONString -> 数组
    func jsonToArray() -> [Any] {
        let jsonData: Data = self.base.data(using: .utf8)!
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return (array as? [Any]) ?? []
    }

    /// JSONString -> 字典
    func jsonToDictionary() -> [String: Any] {
        let jsonData: Data = self.base.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return (dict as? [String: Any]) ?? [String: Any]()
    }
}

public extension Array {
    
    /// 数组 -> JSONString
    func jsonString() -> String {
        guard JSONSerialization.isValidJSONObject(self) else {
            return ""
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""
        }
        let JSONString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        return JSONString ?? ""
    }
}
