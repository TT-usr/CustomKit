//
//  String+Extention.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

extension String: CMAny {}

public extension CMWrapper where T == String {
    
    /// 截取，从开始位置截取到`length`
    func cutOut(_ length: Int) -> String {
        if length <= 0 {
            return self.base
        }
        let index = self.base.index(self.base.startIndex, offsetBy: length)
        return String(self.base.prefix(upTo: index))
    }
}

// MARK: - 校验
public extension CMWrapper where T == String {
    
    func isEmpty() -> Bool {
        return self.base.isEmpty || self.base == ""
    }
    
    func isNotEmpty() -> Bool {
        return !isEmpty()
    }
    
    /// 是否为空（过滤空格）
    func isEmptyWithNoBlank() -> Bool {
        let str = self.base.replacingOccurrences(of: " ", with: "")
        return str.isEmpty
    }
    
    /// 是否为空（过滤前后空格）
    func isEmptyWithNoPrefixSufixBlank() -> Bool {
        let str = self.base.trimmingCharacters(in: .whitespaces)
        return str.isEmpty
    }
    
    /// 是否是字符
    func isChar() -> Bool {
        return regexControlString(pattern: "[a-zA-ZğüşöçıİĞÜŞÖÇ]")
    }

    /// 是否是数字
    func isNumber() -> Bool {
        return regexControlString(pattern: "^[0-9]*$")
    }

    /// 验证是否是邮箱
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self.base)
    }
    
    /// 正则
    func regexControlString(pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let numberOfMatches = regex.numberOfMatches(in: self.base, options: [], range: NSRange(location: 0, length: self.base.count))
            return numberOfMatches == self.base.count
        } catch {
            return false
        }
    }
}

// MARK: - range、NSRange转换
public extension CMWrapper where T == String {
    
    /// range -> NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self.base)
    }
    
    /// NSRange -> range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = self.base.utf16.index(self.base.utf16.startIndex, offsetBy: nsRange.location, limitedBy: self.base.utf16.endIndex),
            let to16 = self.base.utf16.index(from16, offsetBy: nsRange.length, limitedBy: self.base.utf16.endIndex),
            let fromIndex = String.Index(from16, within: self.base),
            let toIndex = String.Index(to16, within: self.base)
            else { return nil }
          return fromIndex ..< toIndex
    }
}

// MARK: - 获取字符串size
public extension CMWrapper where T == String {
    
    func getTextHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return self.getTextSize(constrainedSize: CGSize(width: width, height: CGFloat(MAXFLOAT)), attributes: attributes).width
    }
    
    func getTextHeight(width: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        return self.getTextSize(constrainedSize: CGSize(width: width, height: CGFloat(MAXFLOAT)), attributes: attributes).width
    }
    
    func getTextWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return self.getTextSize(constrainedSize: CGSize(width: CGFloat(MAXFLOAT), height: height), attributes: attributes).width
    }
    
    func getTextWidth(height: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        return self.getTextSize(constrainedSize: CGSize(width: CGFloat(MAXFLOAT), height: height), attributes: attributes).width
    }
    
    func getTextSize(constrainedSize: CGSize, font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return self.getTextSize(constrainedSize: constrainedSize, attributes: attributes)
    }
    
    func getTextSize(constrainedSize: CGSize, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        let rect = self.base.boundingRect(with: constrainedSize, options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine], attributes: attributes, context: nil)
        return CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
    }
}
