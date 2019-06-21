//
//  Queue.swift
//  Al-Rafik
//
//  Created by Nour  on 6/9/19.
//  Copyright © 2019 Nour . All rights reserved.
//

import UIKit

// 1
public struct Queue<T> {
    
    // 2
    fileprivate var list = [T]()
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    // 3
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    // 4
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        list.removeFirst()
        return element
    }
    
    // 5
    public func peek() -> T? {
        return list.first
    }
}

