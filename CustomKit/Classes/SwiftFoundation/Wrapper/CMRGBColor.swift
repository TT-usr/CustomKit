//
//  CMRGBColor.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 关于颜色的 Wrapper
///
/// 使用方式：
/// @CMRGBColor(255, 0, 0) var redRed: UIColor
///
/// 或者这样：
/// @CMRGBColor(255, 0, 0)
/// var redRed: UIColor
///
/// 代码结构简洁
@propertyWrapper
public struct CMRGBColor {
    private var r: CGFloat
    private var g: CGFloat
    private var b: CGFloat
    private var alpha: CGFloat
    
    public var wrappedValue: UIColor { UIColor.init(red: r, green: g, blue: b, alpha: alpha) }
    
    public init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ alpha: CGFloat = 1) {
        self.r = r / 255
        self.g = g / 255
        self.b = b / 255
        self.alpha = alpha
    }
}
