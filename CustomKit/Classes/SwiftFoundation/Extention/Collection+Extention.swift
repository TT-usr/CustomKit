//
//  Collection+Extention.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

public extension Collection {
    
    /// 安全取值
    /// - Parameters index: 下标
    /// - Notes 来源：https://github.com/Luur/SwiftTips
    subscript(cms index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// 安全取值并提供默认值
    /// - Parameters
    ///     - index: 下标
    ///     - defaultValue: 默认值
    /// - Notes
    subscript(cms index: Index, defaultValue: Element) -> Element {
        return indices.contains(index) ? self[index] : defaultValue
    }
}
