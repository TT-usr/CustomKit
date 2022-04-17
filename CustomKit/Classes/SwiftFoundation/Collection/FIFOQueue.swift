//
//  FIFOQueue.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// Swift 队列集合类型的实现, enqueue 是入队, dequeue 是出队. 该集合类型实现了 Collection 协议, 基本的对数据操作都是满足的, 已通过单元测试
/// 常规使用:
///
///          var strs: FIFOQueue<String> = ["a", "b", "c", "d"]
///          var arr: FIFOQueue<Int> = [1,2,3,4,5]
///
///          arr.first
///          arr.isEmpty
///          arr.last
///          arr.count
///
///          strs.map { $0.uppercased() }
///          strs.filter { $0.count > 1 }
///          strs.joined(separator: " ")
///          strs.compactMap { Int($0) }
///
public struct FIFOQueue<T> {
    
    private var left: [T] = []
    
    private var right: [T] = []
    
    public mutating func enqueue(_ newValue: T) {
        right.append(newValue)
    }
    
    public mutating func dequeue() -> T? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

extension FIFOQueue: Collection {
    
    public subscript(position: Int) -> T {
        precondition(startIndex..<endIndex ~= position, "index 使用超出范围")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
    
    public func index(after i: Int) -> Int {
        precondition(startIndex..<endIndex ~= i, "index 使用超出范围")
        return i + 1
    }
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return left.count + right.count
    }
    
    public var indices: Range<Int> {
        return startIndex..<endIndex
    }
    
    public var last: T? {
        return isEmpty ? nil : self[endIndex - 1]
    }
}

extension FIFOQueue: ExpressibleByArrayLiteral {
    
    public init(arrayLiteral elements: T...) {
        self.init(left: elements.reversed(), right: [])
    }
}
