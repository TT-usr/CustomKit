//
//  WeakSet.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 弱引用的 Set 集合, 不会强持有 Class. 在赋值的时候会自动剔除无用的弱引用，无需关心删除, 不必在 deinit 里面调用. CMWeakSet 暴露的方法均进行过单元测试
public class CMWeakSet<T: AnyObject> {
    
    public typealias WeakObject = CMWeakObject
    
    /// 由 Set 集合类型对 T: AnyObject 进行包装处理的集合. 如果进行其它操作建议使用 objects.WeakObject.object, 不建议直接使用 objects.WeakObject. 对 objects 进行操作的时候参考 CMWeakObject 的数据结构.
    public var objects: Set<WeakObject<T>>

    public init() {
        self.objects = []
    }

    public init(objects: [T]) {
        self.objects = Set<WeakObject<T>>(objects.map { WeakObject(object: $0) })
    }
    
    /// 获取当前集合的所有 AnyObject, 会自动过滤无用 object
    public var allObjects: [T] {
        return objects.compactMap { $0.object }
    }
    
    /// 当前集合中是否包含某个 AnyObject
    /// - Parameter object: object: AnyObject
    /// - Returns: true 包含
    public func contains(_ object: T) -> Bool {
        return self.objects.contains(where: { $0.object === object })
    }
    
    /// 单个添加
    /// - Parameter object: T: AnyObject
    public func addObject(_ object: T) {
        objects = objects.filter { $0.object != nil }
        self.objects.formUnion([WeakObject(object: object)])
    }
    
    /// 批量添加
    /// - Parameter objects: [c1, c2, c3]
    public func addObjects(_ objects: [T]) {
        self.objects = self.objects.filter { $0.object != nil }
        self.objects.formUnion(objects.map { WeakObject(object: $0) })
    }
}

public class CMWeakObject<T: AnyObject>: Equatable, Hashable {
    
    public weak var object: T?
    
    public init(object: T) {
        self.object = object
    }

    public func hash(into hasher: inout Hasher) {
        if let object = object {
            hasher.combine(ObjectIdentifier(object))
        } else {
            hasher.combine(0)
        }
    }

    public static func == (lhs: CMWeakObject<T>, rhs: CMWeakObject<T>) -> Bool {
        return lhs.object === rhs.object
    }
}
