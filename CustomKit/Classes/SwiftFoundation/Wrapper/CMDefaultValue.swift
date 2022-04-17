//
//  MMSDefault.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

public protocol CMDefaultValue {
    /// conflict with Dictionary's Value
    /// so change to `DFValue(default value)`
    associatedtype DFValue: Codable
    
    static var defaultValue: DFValue { get }
}

#if swift(>=5.1)
/// 为属性提供默认值
///
/// [属性包装器介绍](https://swiftgg.gitbook.io/swift/swift-jiao-cheng/10_properties#property-wrappers)
///
/// ## example:
///
///     class Example {
///         @CMSDefault<Int.Empty> var a: Int
///         @CMSDefault<String.Empty>("hello world") var text: String
///         @CMSDefault<Empty> var emptyString: String
///         @CMSDefault<Empty> var emptyArray: [String]
///     }
///
@propertyWrapper
public struct CMSDefault<T: CMDefaultValue> {
    public var wrappedValue: T.DFValue
    
    public init() {
        self.wrappedValue = T.defaultValue
    }
    
    public init(wrappedValue: T.DFValue) {
        self.wrappedValue = wrappedValue
    }
}

public extension CMSDefault {
    typealias True = CMSDefault<Bool.True>
    typealias False = CMSDefault<Bool.False>
    typealias StrEmpty = CMSDefault<String.Empty>
    typealias IntEmpty = CMSDefault<Int.Empty>
}

extension CMSDefault: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            wrappedValue = T.defaultValue
        } else {
            self.wrappedValue = (try? container.decode(T.DFValue.self)) ?? T.defaultValue
        }
    }
}

extension CMSDefault: Equatable where T.DFValue: Equatable {}

public extension KeyedDecodingContainer {
    func decode<T>(
        _ type: CMSDefault<T>.Type,
        forKey key: Key
    ) throws -> CMSDefault<T> where T: CMDefaultValue {
        (try? decodeIfPresent(type, forKey: key)) ?? CMSDefault(wrappedValue: T.defaultValue)
    }
}
#endif

public extension Bool {
    enum False: CMDefaultValue {
        public static let defaultValue = false
    }
    
    enum True: CMDefaultValue {
        public static let defaultValue = true
    }
}

/// 默认为`""`
public extension String {
    /// Empty "".count = 0
    enum Empty: CMDefaultValue {
        public static let defaultValue = ""
    }
}

/// 默认为`0`
public extension Int {
    enum Empty: CMDefaultValue {
        public static let defaultValue = 0
    }
}

/// 默认为`0.0`
public extension Double {
    enum Empty: CMDefaultValue {
        public static let defaultValue = 0.0
    }
}

/// 默认为`0.0`
public extension Float {
    enum Empty: CMDefaultValue {
        public static let defaultValue = 0.0
    }
}

/// 默认为`0.0`
public extension CGFloat {
    enum Empty: CMDefaultValue {
        public static let defaultValue = 0.0
    }
}

/// 默认为空数组
public extension Array {
    enum Empty<Element>: CMDefaultValue where Element: Codable, Element: Equatable {
        public static var defaultValue: [Element] {
            [Element]()
        }
    }
}

/// 默认为空字典
extension Dictionary {
    enum Empty<K, V>: CMDefaultValue where K: Codable & Hashable, V: Codable & Equatable {
        public static var defaultValue: [K: V] {
            [K: V]()
        }
    }
}

/// 默认空集合，e.g: `String`, `Array` ...
public enum Empty<T>: CMDefaultValue where T: Codable, T: Equatable, T: RangeReplaceableCollection {
    public static var defaultValue: T {
        return T()
    }
}
