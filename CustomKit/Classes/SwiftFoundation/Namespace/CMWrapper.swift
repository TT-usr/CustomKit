//
//  CMS.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

public struct CMWrapper<T> {
    
    /// Base object to extend.
    public var base: T

    /// Creates extensions with base object.
    public init(_ base: T) {
        self.base = base
    }
}

public protocol CMAny {

    associatedtype CMType

    var cms: CMWrapper<CMType> { get set }

    static var cms: CMWrapper<CMType>.Type { get set }
}

public extension CMAny {

    var cms: CMWrapper<Self> {
        get {
            return CMWrapper(self)
        }
        set { }
    }

    static var cms: CMWrapper<Self>.Type {
        get {
            return CMWrapper<Self>.self
        }
        set { }
    }
}
