//
//  Optional+Extention.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

// MARK: - nonnull

public extension Optional where Wrapped == Bool {
    var nonnull: Bool {
        return self ?? false
    }
}

public extension Optional where Wrapped == Int {
    var nonnull: Int {
        return self ?? 0
    }
}

public extension Optional where Wrapped == Int8 {
    var nonnull: Int8 {
        return self ?? 0
    }
}

public extension Optional where Wrapped == Int16 {
    var nonnull: Int16 {
        return self ?? 0
    }
}

public extension Optional where Wrapped == Int32 {
    var nonnull: Int32 {
        return self ?? 0
    }
}

public extension Optional where Wrapped == Int64 {
    var nonnull: Int64 {
        return self ?? 0
    }
}

public extension Optional where Wrapped == UInt {
    var nonnull: UInt {
        return self ?? 0
    }
}

public extension Optional where Wrapped == UInt8 {
    var nonnull: UInt8 {
        return self ?? 0
    }
}

public extension Optional where Wrapped == UInt16 {
    var nonnull: UInt16 {
        return self ?? 0
    }
}

public extension Optional where Wrapped == UInt32 {
    var nonnull: UInt32 {
        return self ?? 0
    }
}

public extension Optional where Wrapped == UInt64 {
    var nonnull: UInt64 {
        return self ?? 0
    }
}

public extension Optional where Wrapped == Float {
    var nonnull: Float {
        return self ?? 0
    }
}

public extension Optional where Wrapped == Double {
    var nonnull: Double {
        return self ?? 0
    }
}

public extension Optional where Wrapped == CGFloat {
    var nonnull: CGFloat {
        return self ?? 0
    }
}

public extension Optional where Wrapped == Character {
    var nonnull: Character {
        return self ?? Character("")
    }
}

public extension Optional where Wrapped == String {
    var nonnull: String {
        return self ?? ""
    }
    
    var isNilOrEmpty: Bool {
        switch self {
        case .some(let string):
            return string.isEmpty
        case .none:
            return true
        }
    }
}

public extension Optional where Wrapped == URL {
    var nonnull: URL {
        return self ?? URL(fileURLWithPath: "")
    }
}

public extension Optional where Wrapped == Data {
    var nonnull: Data {
        return self ?? Data()
    }
}

public extension Optional where Wrapped == Date {
    var nonnull: Date {
        return self ?? Date.distantPast
    }
}

public extension Optional where Wrapped == [String: Any] {
    var nonnull: [String: Any] {
        return self ?? [String: Any]()
    }
}

// MARK: - nonEmpty

public extension Optional where Wrapped: Collection {
    var nonEmpty: Wrapped? {
        return self?.isEmpty == true ? nil : self
    }
    
    var isNilOrEmpty: Bool {
        switch self {
        case let collection?:
            return collection.isEmpty
        case nil:
            return true
        }
    }
}

public extension Collection {
    var noEmpty: Self? {
        return isEmpty ? nil : self
    }
}

public protocol MMSAnyOptional {
    var isNil: Bool { get }
}

/// 判断可选值是否为 nil
/// nil: true
public extension Optional where Wrapped: MMSAnyOptional {
    var isNil: Bool { self == nil }
}
