//
//  CMSourceTimer.swift
//  GCDTimer
//
//  Created by tiger on 2021/3/15.
//

import Foundation


public class CMSourceTimer {
    
    public enum CMSourceTimerMode {
        case active //相对时间, 受设备休眠影响
        case always //绝对时间
    }
    
    public let interval: DispatchTimeInterval
    
    public let userInfo: Any?
    
    private(set) var isValid = false
    
    public let mode: CMSourceTimerMode
    
    public let queue: DispatchQueue
    
    public let leeway: DispatchTimeInterval
    
    public let delay: DispatchTimeInterval
    
    public typealias TimerHandler = (CMSourceTimer) -> Void
    
    private var timer: DispatchSourceTimer?
    
    private let handle: TimerHandler
    
    
    /// 初始化timer
    /// - Parameters:
    ///   - mode: mode
    ///   - delay: 开始执行时当前时间延时间隔
    ///   - leeway: 误差
    ///   - interval: 间隔
    ///   - queue: queue
    ///   - userInfo: 关联信息
    ///   - handle: 回调
    public init(mode: CMSourceTimerMode = .active, delay: DispatchTimeInterval = .nanoseconds(0), leeway: DispatchTimeInterval = .nanoseconds(0), interval: DispatchTimeInterval, queue: DispatchQueue = DispatchQueue.main, userInfo: Any? = nil, handle: @escaping TimerHandler) {
        self.mode = mode
        self.interval = interval
        self.userInfo = userInfo
        self.handle = handle
        self.queue = queue
        self.leeway = leeway
        self.delay = delay
    }
    
    public func fire() {
        timer?.cancel()
        isValid = false
        if !isValid && timer == nil {
            timer = DispatchSource.makeTimerSource(queue: queue)
            timer?.setEventHandler { [weak self] in
                if let ss = self {
                    ss.handle(ss)
                }
            }
            
            let repeats = interval != DispatchTimeInterval.nanoseconds(0)
            if mode == .active {
                if repeats {
                    timer?.schedule(deadline: .now() + delay, repeating: interval, leeway: leeway)
                } else {
                    timer?.schedule(deadline: .now() + delay, leeway: leeway)
                }
            } else if mode == .always {
                if repeats {
                    timer?.schedule(wallDeadline: .now() + delay, repeating: interval, leeway: leeway)
                } else {
                    timer?.schedule(wallDeadline: .now() + delay, leeway: leeway)
                }
            }
            timer?.resume()
            isValid = true
        }
    }
    
    public func suspend() {
        if isValid {
            timer?.suspend()
            isValid = false
        }
    }
    
    public func invalidate() {
        if isValid {
            timer?.cancel()
            timer = nil
            isValid = false
        }
    }
    
    deinit {
        if !isValid {
            timer?.resume()
        }
        invalidate()
    }
}

extension CMSourceTimer {
    
    /// 初始化timer并立即执行
    public static func schedule(mode: CMSourceTimerMode = .active, delay: DispatchTimeInterval = .nanoseconds(0), leeway: DispatchTimeInterval = .nanoseconds(0), interval: DispatchTimeInterval, queue: DispatchQueue = DispatchQueue.main, userInfo: Any? = nil, handle: @escaping TimerHandler) -> CMSourceTimer {
        let t = CMSourceTimer(mode: mode, delay: delay, leeway: leeway, interval: interval, queue: queue, userInfo: userInfo, handle: handle)
        t.fire()
        return t
    }
    
    
    /// 初始化timer并执行一次
    public static func once(_ after: DispatchTimeInterval, queue: DispatchQueue = DispatchQueue.main, handle: @escaping TimerHandler) -> CMSourceTimer {
        let t = CMSourceTimer(delay: after, interval: .nanoseconds(0), queue: queue, handle: handle)
        t.fire()
        return t
    }
}
