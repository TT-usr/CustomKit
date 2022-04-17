//
//  MMSDebouncer.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

/// 防抖器, 类似 Combine 框架中的 debouncer 实现 防抖器作用是在接收到第一个值后，并不是立即将它发布出去，而是会开启一个内部计时器，当一定时间内没有新的事件来到，再将这个值进行发布。如果在计时期间有新的事件，则重置计时器并重复上述等待过程. 因为 Combine 仅支持 iOS 13及以上，为了兼容 iOS 13 以下可使用 CMDebouncer. 常用于短期对某个方法高频调用刷新UI时进行节流使用.
///
/// 使用方式：
///
///     let changeViewDebouncer = CMDebouncer(timeInterval: 0.3)
///
/// bindModel 方法会高频调用, 这里设置 ”300“ 毫秒的节流处理
///
///     func bindModel(_ model : MDSEmotionFMModel?) {
///         changeViewDebouncer.renewInterval()
///         changeViewDebouncer.handler = {
///             action()
///         }
///         func action() {
///             fmModel = model
///             updateUI()
///         }
///     }
 public class CMDebouncer {
    
    private let timeInterval: TimeInterval
    private var timer: Timer?
    
    public typealias Handler = () -> Void
    public var handler: Handler?
    
    public init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    public func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] timer in
            self?.timeIntervalDidFinish(for: timer)
        })
    }
    
    @objc private func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else { return }
        handler?()
        handler = nil
    }
    
    public func cancel() {
        timer?.invalidate()
        handler = nil
    }
    
    deinit {
        cancel()
    }
}
