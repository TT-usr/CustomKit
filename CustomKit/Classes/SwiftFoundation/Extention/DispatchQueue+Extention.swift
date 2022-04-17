//
//  DispatchQueue+Extention.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

extension DispatchQueue: CMAny {}

public extension CMWrapper where T == DispatchQueue {
    
    private static var _onceTracker = Set<String>()
    
    static func once(
        token: String,
        block: os_block_t
    ) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        
        guard !_onceTracker.contains(token) else {
            return
        }
        _onceTracker.insert(token)
        block()
    }
    
    static func once(
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        block: os_block_t
    ) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }
    
}
