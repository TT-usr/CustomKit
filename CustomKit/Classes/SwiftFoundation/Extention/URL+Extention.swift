//
//  URL+Extention.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 字符串直接转为`URL`
/// - Note: example: `let url: URL = "www.google.com"` or `let url = "www.google.com" as URL`
extension URL: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
