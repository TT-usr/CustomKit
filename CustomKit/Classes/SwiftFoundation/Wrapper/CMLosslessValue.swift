//
//  CMLosslessValue.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 自动纠正接口返回的错误数据
///
/// 解决场景1: 接口在某天把某个状态值由 String 类型 改为 Int 类型, 由于 Swift 的解析特性导致解析失败，造成一些业务问题. 使用 CMLosslessValue 可以解决.
///
/// 案例：1
/// {
///     "values1": "1",
///     "values2": 2
/// }
///
/// struct Model: Codable {
///     var values1: String
///     var values2: Int
/// }
///
/// 当接口数据变为
/// {
///     "values1": 1,
///     "values2": "2"
/// }
///
/// 就会造成解析失败, 当然这种原因是后端的数据类型的问题，但是由于移动端发版的原因, 当问题发生的时候总会造成一部分用户产生异常情况，所以解决这种情况可以使用 CMLosslessValue
///
/// 使用方式：@CMLosslessValue var values1: String 即可
///
/// 需要注意：使用 CMLosslessValue 也不是能解决所有的问题，当数据类型比较复杂或者与原定义的类型相差胜远的时候还是转换不成功, 比如：字符串 转 Bool 这种
///
@propertyWrapper
public struct CMLosslessValue<Value: LosslessStringConvertible & Codable> {
    
    typealias ValueType = LosslessStringConvertible & Codable
    
    private let type: ValueType.Type
    
    public var wrappedValue: Value
    
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        self.type = Value.self
    }
    
    public init(from decoder: Decoder) throws {
        do {
            self.wrappedValue = try Value.init(from: decoder)
            self.type = Value.self
        } catch let error {
            func decode<T: ValueType>(_: T.Type) -> (Decoder) -> ValueType? {
                return { try? T.init(from: $0) }
            }
            
            let types: [(Decoder) -> ValueType?] = [
                decode(String.self),
                decode(Bool.self),
                decode(Int.self),
                decode(Int8.self),
                decode(Int16.self),
                decode(Int64.self),
                decode(UInt.self),
                decode(UInt8.self),
                decode(UInt16.self),
                decode(UInt64.self),
                decode(Double.self),
                decode(Float.self),
            ]
            
            guard let rawValue = types.lazy.compactMap({ $0(decoder) }).first,
                let value = Value.init("\(rawValue)")
                else { throw error }
            
            self.wrappedValue = value
            self.type = Swift.type(of: rawValue)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        let string = String(describing: wrappedValue)
        
        guard let original = type.init(string) else {
            let description = "无法解析: \(wrappedValue)' 类型为: '\(type)'"
            throw EncodingError.invalidValue(string, .init(codingPath: [], debugDescription: description))
        }
        
        try original.encode(to: encoder)
    }
}

extension CMLosslessValue: Codable {}

extension CMLosslessValue: Equatable where Value: Equatable {
    public static func == (lhs: CMLosslessValue<Value>, rhs: CMLosslessValue<Value>) -> Bool {
        return lhs.wrappedValue == rhs.wrappedValue
    }
}

extension CMLosslessValue: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(wrappedValue)
    }
}
