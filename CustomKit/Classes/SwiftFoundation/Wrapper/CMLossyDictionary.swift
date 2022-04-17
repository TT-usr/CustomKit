//
//  CMLossyDictionary.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 对字典中异常的数据结构解析, 自动剔除异常的数据, 目前仅支持 key 为 String, Int 类型的
///
/// 例如如下的 字典数据, 如果你想以 [String: String] 去解析是什么也得不到
/// {
///     "values": {
///         "values1": "1",
///         "values2": "2",
///         "values3":  3
///     }
/// }
///
/// 使用方式
///
/// struct Model: Codable {
///     @CMLossyDictionary
///     var values: [String: String]
/// }
///
/// 会自动剔除 Int, 当然如果针对 json 这样定义模型也不会有问题
/// struct Values: Codable {
///     var values3: Int?
///     var values1: String?
///     var values2: String?

///     enum CodingKeys: String, CodingKey {
///         case values3 = "values3"
///         case values1 = "values1"
///         case values2 = "values2"
///     }
/// }
///
@propertyWrapper
public struct CMLossyDictionary<Key: Codable & Hashable, Value: Codable> {
    
    private struct AnyDecodableValue: Codable {}
    
    public var wrappedValue: [Key: Value]
    
    public init(wrappedValue: [Key: Value]) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        var elements: [Key: Value] = [:]
        
        if Key.self == String.self {
            let container = try decoder.container(keyedBy: DictionaryCodingKey.self)
            for key in container.allKeys {
                do {
                    let value = try container.decode(LossyDecodableValue<Value>.self, forKey: key).value
                    if let iKey = key.stringValue as? Key {
                        elements.updateValue(value, forKey: iKey)
                    }
                } catch {
                    _ = try? container.decode(AnyDecodableValue.self, forKey: key)
                }
            }
        } else if Key.self == Int.self {
            let container = try decoder.container(keyedBy: DictionaryCodingKey.self)
            for key in container.allKeys {
                guard key.intValue != nil else {
                    var codingPath = decoder.codingPath
                    codingPath.append(key)
                    throw DecodingError.typeMismatch(
                        Int.self,
                        DecodingError.Context(
                            codingPath: codingPath,
                            debugDescription: "key 定义的是 Int, 解析中非 Int"))
                }
                
                do {
                    let value = try container.decode(LossyDecodableValue<Value>.self, forKey: key).value
                    if let iKey = key.intValue as? Key {
                        elements.updateValue(value, forKey: iKey)
                    }
                } catch {
                    _ = try? container.decode(AnyDecodableValue.self, forKey: key)
                }
            }
        } else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "key 的类型非 String 或者 Int, 其它类型暂未提供"))
        }
        
        self.wrappedValue = elements
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension CMLossyDictionary: Codable {
    
    struct DictionaryCodingKey: CodingKey {
        let stringValue: String
        let intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = Int(stringValue)
        }
        
        init?(intValue: Int) {
            self.stringValue = intValue.description
            self.intValue = intValue
        }
    }

    struct LossyDecodableValue<Value: Codable>: Codable {
        let value: Value
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            value = try container.decode(Value.self)
        }
    }
}

extension CMLossyDictionary: Equatable where Key: Equatable, Value: Equatable {}
