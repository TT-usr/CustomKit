//
//  NotificationCenter+Extention.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation
import ObjectiveC

extension NotificationCenter: CMAny {  }

public final class MMSNotificationToken {
    private unowned var notificationCenter: NotificationCenter?
    private var token: NSObjectProtocol
    
    deinit {
        dispose()
    }
    
    public init(notificationCenter: NotificationCenter = .default, token: NSObjectProtocol) {
        self.notificationCenter = notificationCenter
        self.token = token
    }
    
    public func dispose() {
        notificationCenter?.removeObserver(token)
    }
}

extension MMSNotificationToken: Hashable {
    public static func == (lhs: MMSNotificationToken, rhs: MMSNotificationToken) -> Bool {
        return ObjectIdentifier(lhs.token) == ObjectIdentifier(rhs.token)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(token))
    }
}

private var NotificationTokenKey: Void?

public extension CMWrapper where T == NotificationCenter {
    
    private func tokens(_ observer: Any) -> NSMutableSet {
        var set = objc_getAssociatedObject(observer, &NotificationTokenKey) as? NSMutableSet
        guard let value = set else {
            set = NSMutableSet()
            objc_setAssociatedObject(observer, &NotificationTokenKey, set, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return set!
        }
        return value
    }
    
    /// 打破引用环的通知监听；
    /// 需要外界持有`token`，否则出当前作用域后通知就会被移除掉，导致收不到通知
    func addObserver(
        forName name: NSNotification.Name?,
        object obj: Any?,
        queue: OperationQueue?,
        using block: @escaping (Notification) -> Void
    ) -> MMSNotificationToken {
        let token = self.base.addObserver(forName: name, object: obj, queue: queue, using: block)
        return MMSNotificationToken(notificationCenter: self.base, token: token)
    }
    
    /// 自动移除token的通知(Observer析构时)
    func addObserver(
        observer: Any,
        forName name: NSNotification.Name?,
        object obj: Any?,
        queue: OperationQueue?,
        using block: @escaping (Notification) -> Void
    ) {
        let token = self.base.addObserver(forName: name, object: obj, queue: queue, using: block)
        let notificationToken = MMSNotificationToken(notificationCenter: self.base, token: token)
        //print("1 = ", withUnsafePointer(to: &NotificationTokenKey, { $0 }))
        tokens(observer).add(notificationToken)
    }
    
}
