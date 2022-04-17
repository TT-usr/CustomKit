//
//  MMSChain.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//
//  链式调用

#if canImport(Foundation)
import Foundation

extension NSObject: CMChainProtocol {}
#endif

@dynamicMemberLookup
public struct CMChain<T> {
    
    private let base: T
    
    public init(_ base: T) {
        self.base = base
    }
    
    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> (Value) -> T {
        { value in
            var object = base
            object[keyPath: keyPath] = value
            return object
        }
    }
    
    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> (Value) -> CMChain<T> {
        { value in
            var object = base
            object[keyPath: keyPath] = value
            return Self(object)
        }
    }
}

public protocol CMChainProtocol {
    associatedtype T
    var chain: CMChain<T> { get set }
}

extension CMChainProtocol {
    
    public var chain: CMChain<Self> {
        get { CMChain(self) }
        set {}
    }
}


