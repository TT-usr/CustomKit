//
//  CMDefaultModel.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

#if swift(>=5.1)
/// 为遵守`Codable`协议的`Model`提供默认值
///
/// 限制：对于重写 `decode` 的 `Model`，属性包装器会失效
///
/// Usage:
///
///      fileprivate class Model: Codable {
///          var name: String
///      }
///
///      fileprivate class SubModel: Codable {
///          @CMDefaultModel var model: Model?
///      }
///
@propertyWrapper
public struct CMDefaultModel<T: Codable>: Codable {
    public var wrappedValue: T?
    
    public init() {
        self.wrappedValue = try? T(from: CMEmptySingleValueDecoder(minimumMode: true, codingPath: [], userInfo: [CodingUserInfoKey: Any]()))
    }
    
    public init(wrappedValue: T?) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        guard let container = try? decoder.singleValueContainer(),
              let value = try? container.decode(T.self) else {
            wrappedValue = try? T(from: CMEmptySingleValueDecoder(minimumMode: true, codingPath: [], userInfo: [CodingUserInfoKey: Any]()))
            return
        }
        wrappedValue = value
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try? container.encode(wrappedValue)
    }
}
#endif

public struct CMCodingKey: CodingKey {
    public let stringValue: String
    public let intValue: Int?
    
    public init(stringValue: String) {
        self.stringValue = stringValue
        intValue = nil
    }
    
    public init(intValue: Int) {
        stringValue = String(intValue)
        self.intValue = intValue
    }
}

struct CMEmptyDecoder {
    
    var userInfo: [CodingUserInfoKey: Any] = [:]
    
    public func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let decoder: Decoder = CMEmptySingleValueDecoder(minimumMode: true, codingPath: [], userInfo: userInfo)
        return try T(from: decoder)
    }
}

struct CMEmptySingleValueDecoder: Decoder {
    
    let minimumMode: Bool
    
    var codingPath: [CodingKey]
    
    var userInfo: [CodingUserInfoKey: Any]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        return KeyedDecodingContainer(ZeroKeyedDecodingContainer(minimumMode: minimumMode,
                                                                 codingPath: codingPath,
                                                                 userInfo: userInfo))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        return CMEmptyUnkeyedDecodingContainer(minimumMode: minimumMode,
                                                codingPath: codingPath,
                                                userInfo: userInfo)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}

extension CMEmptySingleValueDecoder: SingleValueDecodingContainer {
    
    func decodeNil() -> Bool {
        return !minimumMode
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        return false
    }
    
    func decode(_ type: String.Type) throws -> String {
        return ""
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        return 0
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        return 0
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        return 0
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        return 0
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        return 0
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        return 0
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        return 0
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        return 0
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        return 0
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        return 0
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        return 0
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        return 0
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        let decoder: Decoder = CMEmptySingleValueDecoder(minimumMode: minimumMode, codingPath: codingPath, userInfo: userInfo)
        return try T(from: decoder)
    }
}

struct CMEmptyUnkeyedDecodingContainer: UnkeyedDecodingContainer {
    
    let minimumMode: Bool
    
    private(set) var userInfo: [CodingUserInfoKey: Any]
    
    let codingPath: [CodingKey]
    
    var count: Int? { return minimumMode ? 0 : 1 }
    
    var isAtEnd: Bool { return currentIndex >= count ?? 0 }
    
    private(set) var currentIndex: Int = 0
    
    init(minimumMode: Bool, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
        self.minimumMode = minimumMode
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    mutating func decodeNil() throws -> Bool {
        return !minimumMode
    }
    
    mutating func decode(_ type: Bool.Type) throws -> Bool {
        currentIndex += 1
        return false
    }
    
    mutating func decode(_ type: String.Type) throws -> String {
        currentIndex += 1
        return ""
    }
    
    mutating func decode(_ type: Double.Type) throws -> Double {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: Float.Type) throws -> Float {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: Int.Type) throws -> Int {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: UInt.Type) throws -> UInt {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        currentIndex += 1
        return 0
    }
    
    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        currentIndex += 1
        return 0
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        let decoder = CMEmptySingleValueDecoder(minimumMode: minimumMode,
                                             codingPath: self.codingPath + [CMCodingKey(intValue: currentIndex)],
                                             userInfo: userInfo)
        currentIndex += 1
        return try T(from: decoder)
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        
        let ret = KeyedDecodingContainer(ZeroKeyedDecodingContainer<NestedKey>(minimumMode: minimumMode, codingPath: codingPath + [CMCodingKey(intValue: currentIndex)], userInfo: userInfo))
        currentIndex += 1
        return ret
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        let ret = CMEmptyUnkeyedDecodingContainer(minimumMode: minimumMode,
                                                   codingPath: codingPath + [CMCodingKey(intValue: currentIndex)],
                                                   userInfo: userInfo)
        currentIndex += 1
        return ret
    }
    
    mutating func superDecoder() throws -> Decoder {
        let ret =  CMEmptySingleValueDecoder(minimumMode: minimumMode,
                                              codingPath: codingPath + [CMCodingKey(intValue: currentIndex)],
                                              userInfo: userInfo)
        currentIndex += 1
        return ret
    }
}

struct ZeroKeyedDecodingContainer<K: CodingKey>: KeyedDecodingContainerProtocol {
    
    let minimumMode: Bool
    
    let codingPath: [CodingKey]
    
    var userInfo: [CodingUserInfoKey: Any]
    
    var allKeys: [K] { return [] }
    
    func contains(_ key: K) -> Bool {
        return !minimumMode
    }
    
    func decodeNil(forKey key: K) throws -> Bool {
        return !minimumMode
    }
    
    func decode(_ type: Bool.Type, forKey key: K) throws -> Bool {
        return false
    }
    
    func decode(_ type: String.Type, forKey key: K) throws -> String {
        return ""
    }
    
    func decode(_ type: Double.Type, forKey key: K) throws -> Double {
        return 0
    }
    
    func decode(_ type: Float.Type, forKey key: K) throws -> Float {
        return 0
    }
    
    func decode(_ type: Int.Type, forKey key: K) throws -> Int {
        return 0
    }
    
    func decode(_ type: Int8.Type, forKey key: K) throws -> Int8 {
        return 0
    }
    
    func decode(_ type: Int16.Type, forKey key: K) throws -> Int16 {
        return 0
    }
    
    func decode(_ type: Int32.Type, forKey key: K) throws -> Int32 {
        return 0
    }
    
    func decode(_ type: Int64.Type, forKey key: K) throws -> Int64 {
        return 0
    }
    
    func decode(_ type: UInt.Type, forKey key: K) throws -> UInt {
        return 0
    }
    
    func decode(_ type: UInt8.Type, forKey key: K) throws -> UInt8 {
        return 0
    }
    
    func decode(_ type: UInt16.Type, forKey key: K) throws -> UInt16 {
        return 0
    }
    
    func decode(_ type: UInt32.Type, forKey key: K) throws -> UInt32 {
        return 0
    }
    
    func decode(_ type: UInt64.Type, forKey key: K) throws -> UInt64 {
        return 0
    }
    
    func decode<T>(_ type: T.Type, forKey key: K) throws -> T where T: Decodable {
        let decoder = CMEmptySingleValueDecoder(minimumMode: minimumMode,
                                             codingPath: codingPath + [key],
                                             userInfo: userInfo)
        return try T(from: decoder)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        
        return KeyedDecodingContainer(ZeroKeyedDecodingContainer<NestedKey>(minimumMode: minimumMode, codingPath: codingPath + [key], userInfo: userInfo))
    }
    
    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        
        return CMEmptyUnkeyedDecodingContainer(minimumMode: minimumMode,
                                            codingPath: codingPath + [key],
                                            userInfo: userInfo)
    }
    
    func superDecoder() throws -> Decoder {
        return CMEmptySingleValueDecoder(minimumMode: minimumMode,
                                          codingPath: codingPath + [CMCodingKey(stringValue: "super")],
                                          userInfo: userInfo)
    }
    
    func superDecoder(forKey key: K) throws -> Decoder {
        return CMEmptySingleValueDecoder(minimumMode: minimumMode,
                                          codingPath: codingPath + [key],
                                          userInfo: userInfo)
    }
}
