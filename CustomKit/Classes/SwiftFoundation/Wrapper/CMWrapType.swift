//
//  CMTypeWrap.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import UIKit
prefix operator *

public protocol CMWrapTypeProtocol {}
extension String: CMWrapTypeProtocol {}
extension CGFloat: CMWrapTypeProtocol {}
extension Double: CMWrapTypeProtocol {}
extension Int: CMWrapTypeProtocol {}
extension Bool: CMWrapTypeProtocol {}

/// 类型包裹器
/// 解决重写`Decode`协议函数时类型不匹配或者没有导致解析失败问题
///
/// 目前只支持了`String`,`Int`,`CGFloat`,`Bool`等少数类型
///
/// 用法:
///
///     class SuperClass: Codable {
///         var name: CMTypeWrap<String>
///         var sex: CMTypeWrap<String>
///         var age: CMTypeWrap<Int>
///         var xx: CMTypeWrap<String>
///
///         private enum CodingKeys: String, KeyedKey {
///             case name, sex, age, xx
///         }
///
///         // 如果不涉及继承，这个可以不写
///         required init(from decoder: Decoder) throws {
///             let container = try decoder.container(keyedBy: CodingKeys.self)
///             name = try container.decode(CMTypeWrap.self, forKey: .name)
///             sex = try container.decode(CMTypeWrap.self, forKey: .sex)
///             age = try container.decode(CMTypeWrap.self, forKey: .age)
///             xx = try container.decode(CMTypeWrap.self, forKey: .xx)
///     }
///
public struct CMTypeWrap<T>: Codable {
    
    var intValue: Int = 0
    var stringValue: String = ""
    var floatValue: CGFloat = 0.0
    var boolValue: Bool = false
    
    public init(_ value: CMWrapTypeProtocol) {
        if let value = value as? String {
            intValue = Int(value) ?? 0
            self.stringValue = value
            floatValue = CGFloat(Double(value) ?? 0.0)
            boolValue = floatValue != 0
        } else if let value = value as? Int {
            self.intValue = value
            stringValue = String(value)
            floatValue = CGFloat(value)
            boolValue = value != 0
        } else if let value = value as? Double {
            intValue = Int(value)
            stringValue = String(value)
            self.floatValue = CGFloat(value)
            boolValue = floatValue != 0
        } else if let value = value as? CGFloat {
            intValue = Int(value)
            stringValue = String(Double(value))
            self.floatValue = value
            boolValue = floatValue != 0
        } else if let value = value as? Bool {
            intValue = value ? 1 : 0
            stringValue = value ? "1" : "0"
            floatValue = value ? 1.0 : 0.0
            self.boolValue = value
        }
    }
    
    // MARK: - Decodable
    
    public init(from decoder: Decoder) throws {
        let singleValueContainer = try decoder.singleValueContainer()
        
        if let aValue = try? singleValueContainer.decode(String.self) {
            stringValue = aValue
            if let intValue = Int(aValue) {
                self.intValue = intValue
                floatValue = CGFloat(intValue)
            } else if let doubleValue = Double(aValue) {
                intValue = Int(doubleValue)
                floatValue = CGFloat(doubleValue)
            }
            
            switch stringValue.lowercased() {
            case "0", "false", "null", "<null>", "no", "n":
                boolValue = false
            case "1", "true", "yes", "y":
                boolValue = true
            default:
                boolValue = false
            }
            
        } else if let intValue = try? singleValueContainer.decode(Int.self) {
            self.intValue = intValue
            self.stringValue = String(intValue)
            self.floatValue = CGFloat(intValue)
            boolValue = intValue != 0
        } else if let doubleValue = try? singleValueContainer.decode(CGFloat.self) {
            self.intValue = Int(doubleValue)
            self.stringValue = String(Double(doubleValue))
            self.floatValue = doubleValue
            boolValue = doubleValue != 0.0
        } else {
            self.intValue = 0
            self.stringValue = String(0)
            self.floatValue = CGFloat(0)
            boolValue = false
        }
    }
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(intValue)
        try container.encode(floatValue)
        try container.encode(stringValue)
        try container.encode(boolValue)
    }
    
    // MARK: - Func
    
    public static func &= (lhs: inout CMTypeWrap, rhs: CMWrapTypeProtocol) {
        lhs = CMTypeWrap(rhs)
    }
}

// MARK: - Literal

extension CMTypeWrap: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = Self.init(value)
    }
}

extension CMTypeWrap: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self = Self.init(value)
    }
}

extension CMTypeWrap: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self = Self.init(CGFloat(value))
    }
}

extension CMTypeWrap: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = Self.init(value)
    }
}

extension CMTypeWrap: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = Self.init(0)
    }
}

// MARK: - Prefix Operator Func

extension String {
    public static prefix func * (_ value: Self) -> CMTypeWrap<Self> {
        return CMTypeWrap(value)
    }
}

extension Int {
    public static prefix func * (_ value: Self) -> CMTypeWrap<Self> {
        return CMTypeWrap(value)
    }
}

extension CGFloat {
    public static prefix func * (_ value: Self) -> CMTypeWrap<Self> {
        return CMTypeWrap(value)
    }
}

extension Bool {
    public static prefix func * (_ value: Self) -> CMTypeWrap<Self> {
        return CMTypeWrap(value)
    }
}
