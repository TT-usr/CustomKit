//
//  Date+Extention.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

private var MMSDateFormatDict = [String: DateFormatter]()

public enum MMSDateFormat: String {

    case all = "yyyy-MM-dd HH:mm:ss:SS"
    case allOther = "yyyy-MM-dd HH:mm:ss.SS"
    case date = "yyyy-MM-dd HH:mm:ss"
    case dateAndMinite = "yyyy-MM-dd HH:mm"
    case time = "HH:mm:ss"
    case preciseTime = "HH:mm:ss:SS"
    case yearMonthDay = "yyyy-MM-dd"
    case yearMonthDayOther = "yyyy年MM月dd日"
    case yearMonth = "yyyy-MM"
    case monthDay = "MM-dd"

    fileprivate func getDateFormat() -> DateFormatter {
        if let formattter = MMSDateFormatDict[self.rawValue] {
            return formattter
        } else {
            let formattter = DateFormatter()
            formattter.dateFormat = self.rawValue
            MMSDateFormatDict[self.rawValue] = formattter
            return formattter
        }
    }
}

extension Date: CMAny { }

public extension CMWrapper where T == Date {
    
    /// 当前时间戳（秒级） - 10位
    var timeStamp: String {
        let timeInterval: TimeInterval = self.base.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 当前时间戳（ 毫秒级） - 13位
    var milliStamp: String {
        let timeInterval: TimeInterval = self.base.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
    
    /// 时间戳转字符串
    /// - timeIsMill 传入时间为毫秒级/var/folders/cocoapods/MOMO_iOS_Binary/Pods/ArgoUI/0.3.4.a.debug.11/MLN-iOS
    static func timeIntervalToString(time: Int, dateFormat: MMSDateFormat, timeIsMill: Bool = false) -> String {
        var resultTime = time
        if timeIsMill {
            resultTime /= 1000
        }
        let timeInterval = TimeInterval(resultTime)
        let date = Date.init(timeIntervalSince1970: timeInterval)
        let dateFormatter =  dateFormat.getDateFormat()
        return dateFormatter.string(from: date)
    }
    
    /// 字符串转时间戳
    static func timeStringToInterval(timeStr: String?, dateFormat: MMSDateFormat) -> String {
        guard let timeString = timeStr, !timeString.isEmpty else {
            return ""
        }
        let dateFormatter =  dateFormat.getDateFormat()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let date: Date = dateFormatter.date(from: timeString) ?? Date()
        return String(date.timeIntervalSince1970)
    }
}
