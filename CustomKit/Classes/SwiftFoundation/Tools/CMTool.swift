//
//  CMTool.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

public struct CMTool {
    
    /// 详细的 Log 打印. 使用方式：CMTool.printDebug("message")
    /// - Parameters:
    ///   - message: 打印详细
    ///   - file: 文件名称，不需要传
    ///   - method: 方法名称，不需要传
    ///   - line: 所在文件的行数，不需要传
    ///
    ///    控制台输出：
    ///    ------------------20 lineBegin-------------------------
    ///    Class Name: ViewController.swift
    ///    Method Name: viewDidLoad()
    ///    Message: message
    ///    ------------------20 line  End-------------------------
    public static func printDebug<T>(_ message: T,
                           file: String = #file,
                           method: String = #function,
                           line: Int = #line
        )
    {
        #if DEBUG
        print("------------------\(line) lineBegin-------------------------\nClass Name: \((file as NSString).lastPathComponent)\nMethod Name: \(method)\nMessage: \(message)\n------------------\(line) line  End-------------------------")
        #endif
    }
}

// MARK:  延时使用
public extension CMTool {
    
    typealias TaskBlock = (_ cancel : Bool) -> Void
    
    /// 延迟调用一个代码库
    /// - Parameters:
    ///   - time: TimeInterval
    ///   - task: Block 代码块
    /// - Returns: TaskBlock 可供取消使用
    ///
    ///  无取消使用方式:
    ///    _ = EmotionTool.delay(0.1) { [weak self] in
    ///        guard let weakSelf = self else { return }
    ///        /// 代码块
    ///    }
    ///
    ///  取消使用方式:
    ///    let action = CMTool.delay(5) {
    ///        CMTool.printDebug("延迟5秒后执行")
    ///    }
    ///    取消延时执行
    ///    CMTool.cancel(action)
    static func delay(_ time: TimeInterval, task: @escaping ()->()) ->  TaskBlock? {
        
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (()->Void)? = task
        var result: TaskBlock?
        
        let delayedClosure: TaskBlock = {
            cancel in
            if let internalClosure = closure, !cancel {
                DispatchQueue.main.async(execute: internalClosure)
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result
    }
    
    /// 取消延迟执行
    /// - Parameter task: TaskBlock
    static func cancel(_ task: TaskBlock?) {
        task?(true)
    }
}
