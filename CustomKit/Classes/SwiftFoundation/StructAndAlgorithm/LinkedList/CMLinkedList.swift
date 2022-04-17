//
//  CMLinkedList.swift
//  CustomKit
//
//  Created by yao.tiancheng on 04/17/2022.
//  Copyright (c) 2022 yao.tiancheng. All rights reserved.
//

import Foundation

// MARK: - CMLinkedListNode
final class CMLinkedListNode<T> {
    var value: T
    var next: CMLinkedListNode?
    
    init(value: T, next: CMLinkedListNode? = nil) {
        self.value = value
        self.next = next
    }
}
extension CMLinkedListNode: CustomStringConvertible {
    var description: String {
        guard let next = next else { return "\(value)" }
        return "\(value) -> \(String(describing: next)) "
    }
}

// MARK: - CMLinkedList
struct CMLinkedList<T> {
    var head: CMLinkedListNode<T>?
    var tail: CMLinkedListNode<T>?
    init() { }
    
    mutating func copyNodes() {
        guard !isKnownUniquelyReferenced(&head) else { return }
        guard var oldNode = head else { return }

        head = CMLinkedListNode(value: oldNode.value)
        var newNode = head

        while let nextOldNode = oldNode.next {
            let nextNewNode = CMLinkedListNode(value: nextOldNode.value)
            newNode?.next = nextNewNode
            newNode = nextNewNode
            oldNode = nextOldNode
        }

        tail = newNode
    }
}
extension CMLinkedList: CustomStringConvertible {
    var description: String {
        guard let head = head else { return "Empty list" }
        return String(describing: head)
    }
}

// MARK: - Add Values
extension CMLinkedList {
    mutating func append(_ value: T) {
        copyNodes()
        
        guard !isEmpty else {
            let node = CMLinkedListNode(value: value)
            head = node
            tail = node
            return
        }
        let next = CMLinkedListNode(value: value)
        tail?.next = next
        tail = next
    }
    
    mutating func insert(_ value: T, after node: CMLinkedListNode<T>) {
        copyNodes()
        guard tail !== node else { append(value); return }
        node.next = CMLinkedListNode(value: value, next: node.next)
    }
}

// MARK: - Remove Values
extension CMLinkedList {
    mutating func removeLast() -> T? {
        copyNodes()
        
        guard let head = head else { return nil }
        
        guard head.next != nil else {
            let headValue = head.value
            self.head = nil
            tail = nil
            return headValue
        }
        
        var prev = head
        var current = head
        while let next = current.next {
            prev = current
            current = next
        }
        prev.next = nil
        tail = prev
        return current.value
    }
    
    mutating func remove(after node: CMLinkedListNode<T>) -> T? {
        copyNodes()
        
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        
        return node.next?.value
    }
}

// MARK: - Access Values
extension CMLinkedList {
    func node(at index: Int) -> CMLinkedListNode<T>? {
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode!.next
            currentIndex += 1
        }
        
        return currentNode
    }
}

// MARK: - Getters
extension CMLinkedList {
    var isEmpty: Bool {
        return head == nil
    }
}

// MARK: - Collection
extension CMLinkedList: Collection {
    
    struct Index: Comparable {
        var node: CMLinkedListNode<T>?
        
        static func == (lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        
        static func < (lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else { return false }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
    
    var startIndex: Index {
        return Index(node: head)
    }
    
    var endIndex: Index {
        return Index(node: tail?.next)
    }
    
    func index(after index: Index) -> Index {
        return Index(node: index.node?.next)
    }
    
    subscript(index: Index) -> T {
        return index.node!.value
    }
}
