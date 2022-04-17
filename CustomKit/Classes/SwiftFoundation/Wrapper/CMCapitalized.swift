//
//  CMCapitalized.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 字母首字母自动大写
///
/// 例如: @CMCapitalized var name: String = "hello"
///
/// print: "Hello"
@propertyWrapper
public struct CMCapitalized {
    public var wrappedValue: String {
        didSet { wrappedValue = wrappedValue.capitalized }
    }

    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.capitalized
    }
}
