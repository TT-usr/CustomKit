//
//  CMEmail.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 邮箱自动判断
///
/// 使用方式
///
/// @CMEmail
/// var name1: String = "momo@immomo.com"
///
/// @CMEmail
/// var name2: String = "momo"
///
/// print("\(name1) Empty: \(name1.isEmpty)")： momo@immomo.com isEmpty: false
/// print("\(name2) Empty: \(name2.isEmpty)")： "" isEmpty: true
@propertyWrapper
public struct CMEmail<Value: StringProtocol> {

    public var value: Value

    public var wrappedValue: Value {
        get {
            return checkEmail(email: value) ? value : ""
        }
        set {
            value = newValue
        }
    }
    
    public init(wrappedValue initialValue: Value) {
        self.value = initialValue
        self.wrappedValue = initialValue
    }

    private func checkEmail(email: Value?) -> Bool {
        guard let email = email else { return false }
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailPred.evaluate(with: email)
    }
}
