//
//  CMDateValue.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

public protocol CMDateValueCodableStrategy {
    associatedtype RawValue: Codable

    static func decode(_ value: RawValue) throws -> Date
    static func encode(_ date: Date) -> RawValue
}

/// 日期自动转换
///
/// 对于接口返回的的日期如: { "date": "1996-12-19T16:39:57-08:00" }
/// 可以自动映射为 Date
///
/// 使用方式：@CMDateValue<MMSISO8601Strategy> var date: Date
/// 对于更多的日期格式: 你可以实现协议: CMDateValueCodableStrategy 即可, 在模型构造的时候，传入自定义的 @MMSDateValue<MMSDateValueCodableStrategy 协议> 即可
///
/// 这样就不用每次自己手动转换时间了. 默认提供三种
/// 1、  MMSISO8601Strategy
/// 2、  MMSTimeIntervalToDate
/// 3、  MMSTimestampToDate
///
@propertyWrapper
public struct CMDateValue<Formatter: CMDateValueCodableStrategy>: Codable {
    private let value: Formatter.RawValue
    public var wrappedValue: Date

    public init(wrappedValue: Date) {
        self.wrappedValue = wrappedValue
        self.value = Formatter.encode(wrappedValue)
    }
    
    public init(from decoder: Decoder) throws {
        self.value = try Formatter.RawValue(from: decoder)
        self.wrappedValue = try Formatter.decode(value)
    }
    
    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

/// 接受转换字符串为: 1996-12-19T16:39:57-08:00 的日期
public struct CMISO8601Strategy: CMDateValueCodableStrategy {
    public static func decode(_ value: String) throws -> Date {
        if #available(macCatalyst 13.1, *) {
            guard let date = ISO8601DateFormatter().date(from: value) else {
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "无效的日期格式"))
            }
            return date
        } else {
            // Fallback on earlier versions
            return Date()
        }
    }
    
    public static func encode(_ date: Date) -> String {
        if #available(macCatalyst 13.1, *) {
            return ISO8601DateFormatter().string(from: date)
        } else {
            // Fallback on earlier versions
            return ""
        }
    }
}

/// 接受转换字符串为 timeIntervalSince1970 的日期
public struct CMTimeIntervalToDate: CMDateValueCodableStrategy {
    public static func decode(_ value: String) throws -> Date {
        guard let timeInterval = TimeInterval(value) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "无效的日期格式"))
        }
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    public static func encode(_ date: Date) -> String {
        return date.timeIntervalSince1970.description
    }
}


/// 接受 TimeInterval (Double) 类型的数据转换为 Date
public struct CMTimestampToDate: CMDateValueCodableStrategy {
    public static func decode(_ value: TimeInterval) throws -> Date {
        return Date(timeIntervalSince1970: value)
    }
    
    public static func encode(_ date: Date) -> TimeInterval {
        return date.timeIntervalSince1970
    }
}

