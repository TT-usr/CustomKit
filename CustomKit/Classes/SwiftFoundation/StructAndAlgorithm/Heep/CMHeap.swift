//
//  CMHeap.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

struct CMHeap<Element: Comparable> {
    private(set) var elements: [Element] = []
    private let order: (Element, Element) -> Bool

    init(order: @escaping (Element, Element) -> Bool, startingValues: [Element] = []) {
        self.order = order
        
        elements = startingValues
        var index = elements.count/2 - 1
        while index >= 0 {
            heapifyDown(from: index)
            index -= 1
        }
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }

    var count: Int {
        return elements.count
    }

    var peek: Element? {
        return elements.first
    }
    
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible
extension CMHeap: CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String { return elements.description }
    public var debugDescription: String { return elements.debugDescription }
}

// MARK: - Remove & Insert
extension CMHeap {
    @discardableResult
    mutating func removePeek() -> Element? {
        guard !isEmpty else {
            return nil
        }
        elements.swapAt(0, count - 1)
        defer {
            heapifyDown(from: 0)
        }
        return elements.removeLast()
    }

    @discardableResult
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count else {
            return nil
        }
        if index == elements.count - 1 {
            return elements.removeLast()
        } else {
            elements.swapAt(index, elements.count - 1)
            defer {
                heapifyDown(from: index)
                heapifyUp(from: index)
            }
            return elements.removeLast()
        }
    }

    mutating func insert(_ element: Element) {
        elements.append(element)
        heapifyUp(from: elements.count - 1)
    }
    
    mutating func clear() {
        elements.removeAll(keepingCapacity: false)
    }
    
    /// Removes the first occurence of a particular item. Finds it by value comparison using ==. O(n)
    /// Silently exits if no occurrence found.
    ///
    /// - parameter item: The item to remove the first occurrence of.
    public mutating func removeFirstItem(_ item: Element) {
        if let index = elements.firstIndex(of: item) {
           remove(at: index)
        }
    }
    
    /// Removes all occurences of a particular item. Finds it by value comparison using ==. O(n)
    /// Silently exits if no occurrence found.
    ///
    /// - parameter item: The item to remove.
    public mutating func removeAll(_ item: Element) {
        var lastCount = elements.count
        removeFirstItem(item)
        var count = elements.count
        
        while count < lastCount {
            lastCount = elements.count
            removeFirstItem(item)
            count = elements.count
        }
    }
    
    /// 通过将元素移向队头的方式恢复堆排序。 上浮
    /// - Parameter index: 要移动的元素的索引值。
    private mutating func heapifyUp(from index: Int) {
        var childIndex = index
        var parentIndex = childIndex.parent

        while childIndex > 0 &&
            order(elements[parentIndex], elements[childIndex]) {
                elements.swapAt(childIndex, parentIndex)
                childIndex = parentIndex
            parentIndex = childIndex.parent
        }
    }
    
    /// 通过将根元素移向队尾的方式恢复队列的堆排序。 下沉
    /// - Parameter index: 要移动的元素的索引值。
    private mutating func heapifyDown(from index: Int) {
        var parentIndex = index
        while true {
            let leftIndex = parentIndex.left
            let rightIndex = parentIndex.right
            var targetParentIndex = parentIndex
            
            if leftIndex < count &&
                order(elements[targetParentIndex], elements[leftIndex]) {
                targetParentIndex = leftIndex
            }
            
            if rightIndex < count &&
                order(elements[targetParentIndex], elements[rightIndex]) {
                targetParentIndex = rightIndex
            }
            
            if targetParentIndex == parentIndex {
                return
            }
            
            elements.swapAt(parentIndex, targetParentIndex)
            parentIndex = targetParentIndex
        }
    }
}

// MARK: - Search
extension CMHeap {
    func index(of element: Element,
               searchingFrom index: Int = 0) -> Int? {
        if index >= count {
            return nil
        }
        if order(element, elements[index]) {
            return nil
        }
        if element == elements[index] {
            return index
        }
        
        let leftIndex = index.left
        if let index = self.index(of: element,
                              searchingFrom: leftIndex) {
            return index
        }
        
        let rightIndex = index.right
        if let index = self.index(of: element,
                              searchingFrom: rightIndex) {
            return index
        }
        
        return nil
    }
}
// MARK: - CollectionType
extension CMHeap: Collection {
    
    public typealias Index = Int
    
    public var startIndex: Int { return elements.startIndex }
    public var endIndex: Int { return elements.endIndex }
    
    public subscript(index: Int) -> Element { return elements[index] }
    
    public func index(after index: CMHeap.Index) -> CMHeap.Index {
        return elements.index(after: index)
    }
}

private extension Int {
  var left: Int {
    return (2 * self) + 1
  }
  
  var right: Int {
    return (2 * self) + 2
  }
  
  var parent: Int {
    return (self - 1) / 2
  }
}
