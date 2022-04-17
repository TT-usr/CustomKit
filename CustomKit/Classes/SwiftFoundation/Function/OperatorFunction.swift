//
//  OperatorFunction.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2020/11/19.
//

import Foundation

@discardableResult
postfix func ++(value: inout Int) -> Int {
    defer {
        value += 1
    }
    return value
}

@discardableResult
prefix func --(value: inout Int) -> Int {
    value -= 1
    return value
}

//@discardableResult
//public func == <L: Hashable, R: Hashable> (left: L, right: R) -> Bool {
//
//    guard type(of: left) != type(of: right) else {
//        return left == right
//    }
//
//    // 将`String`、`Int`转成`Bool`，以支持`Bool`与`Int`相比较
//    let castAnyToBool: (AnyHashable) -> Bool = { value in
//        var ret = false
//        if let value = value as? Int {
//            ret = value != 0
//        } else if let value = value as? Bool {
//            ret = value
//        } else if let value = value as? String {
//            switch value {
//            case "1", "true", "True", "Yes", "Y", "y":
//                ret = true
//            default:
//                ret = false
//            }
//        } else if let value = value as? Float {
//            ret = Int(value) != 0
//        } else if let value = value as? Double {
//            ret = Int(value) != 0
//        }
//
//        return ret
//    }
//
//    let left = castAnyToBool(left)
//    let right = castAnyToBool(right)
//
//    return left == right
//}
