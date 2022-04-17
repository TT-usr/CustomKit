//
//  CMNilPositioning.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 如果在构建参数的时候进行强制 ”!“ 的时候建议加上 CMNilPositioning. 它会告诉你崩溃的原因
/// 当然不建议对未初始化的变量、常量加上 ”!“,
///
/// 使用方式: @CMNilPositioning var name: String!
///
/// 未赋值直接使用会崩溃并提示: ”你还未给该值赋值就开始获取使用了“
///
@propertyWrapper
public struct CMNilPositioning<Value> {
    var storage: Value?
    
    public init() {
        storage = nil
    }
    
    public var wrappedValue: Value {
        get {
            guard let storage = storage else {
                fatalError("你还未给该值赋值就开始获取使用了")
            }
            return storage
        }
        set {
            storage = newValue
        }
    }
}
