//
//  CMRecordData.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 记录历史数据行为
/// 使用方式：@CMRecordData var name: String = "MOMO"
/// name = "MOMO 1"
/// print(_name.values) : ["MOMO", "MOMO 1"]
///
@propertyWrapper
public struct CMRecordData<Value> {
    
    private var index: Int
    public var values: [Value]
    
    public init(wrappedValue: Value) {
        self.values = [wrappedValue]
        self.index = 0
    }
    
    public var wrappedValue: Value {
        get {
            return values[index]
        }
        
        set {
            values.append(newValue)
            index += 1
        }
    }
}
