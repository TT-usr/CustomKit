//
//  MMSStack.swift
//  MMSBaseFoundation
//
//  Created by Jack on 2021/2/7.
//

import Foundation

struct CMStack<Element> {
    private var elements: [Element] = []
    init() { }
}

extension CMStack: CustomStringConvertible {
    var description: String {
        let topDivider = "====top====\n"
        let bottomDivider = "\n====bottom====\n"
        let MMSStackElements = elements
            .reversed()
            .map { "\($0)" }
            .joined(separator: "\n")
        return topDivider + MMSStackElements + bottomDivider
    }
}

// MARK: - Push & Pop
extension CMStack {
    mutating func push(_ element: Element) {
        elements.append(element)
    }
    
    @discardableResult
    mutating func pop() -> Element? {
        return elements.popLast()
    }
}

// MARK: - Getters
extension CMStack {
    var top: Element? {
        return elements.last
    }
    
    var isEmpty: Bool {
        return elements.isEmpty
    }
    
    var count: Int {
        return elements.count
    }
}
