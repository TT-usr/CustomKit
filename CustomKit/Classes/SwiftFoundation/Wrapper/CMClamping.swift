//
//  CMClamping.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

///     值限制范围包装器
///     设置的默认值不可超过设置的区间
///
///     @CMClamping(defaultValue: 8, 0...12) var num: Int
///
///     defaultValue 设置默认值， 第二个参数是区间 0...12.
///
///     规则是大于 ”12“ 取 ”12“， 小于 ”0“ 取 ”0“
///     设置 num = 34
///     打印 print(num) : 12
@propertyWrapper
public struct CMClamping<Value: Comparable> {
    public var value: Value
    public let range: ClosedRange<Value>

    public init(defaultValue value: Value, _ range: ClosedRange<Value>) {
        precondition(range.contains(value))
        self.value = value
        self.range = range
    }

    public var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
}

///  0~1 的浮点数值
///  默认是 0
@propertyWrapper
public struct CMUnitInterval<Value: FloatingPoint> {
    
    @CMClamping(defaultValue: .zero, 0...1) public var wrappedValue: Value

    public init(wrappedValue value: Value) {
        self.wrappedValue = value
    }
}
