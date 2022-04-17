//
//  CMDelegate.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//
//  https://onevcat.com/2020/03/improve-delegate/

public class CMDelegate<Input, OutPut> {
    private var block: ((Input) -> OutPut?)?
    
    public func delegate<T: AnyObject>(on target: T, block: ((T, Input) -> OutPut)?) {
        self.block = { [weak target] input in
            guard let target = target else { return nil }
            return block?(target, input)
        }
    }
    
    public func call(_ input: Input) -> OutPut? {
        return block?(input)
    }
    
    #if swift(>=5.2)
    public func callAsFunction(_ input: Input) -> OutPut? {
        return block?(input)
    }
    #endif
    
    public init() {}
}

/* 处理OutPut双层可选值情况 */
public protocol OptionalProtocol {
    static var createNil: Self { get }
}

extension Optional: OptionalProtocol {
    public static var createNil: Optional<Wrapped> {
        return nil
    }
}

extension CMDelegate where OutPut: OptionalProtocol {
    public func call(_ input: Input) -> OutPut {
        if let result = block?(input) {
            return result
        } else {
            return .createNil
        }
    }
    
    public func callAsFunction(_ input: Input) -> OutPut {
        if let result = block?(input) {
            return result
        } else {
            return .createNil
        }
    }
}
