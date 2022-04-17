//
//  MMSTrimmed.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 字符串通过属性包装器自动去除前后空格
///
/// @CMTrimmed(wrappedValue: "默认值") var userName: String
///
/// userName = " 我会自动去除前后空格 "
///
/// print(userName): "我会自动去除前后空格"
///
@propertyWrapper
public struct CMTrimmed {
    private(set) var value: String = ""

    public var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    public init(wrappedValue initialValue: String) {
        self.wrappedValue = initialValue
    }
}
