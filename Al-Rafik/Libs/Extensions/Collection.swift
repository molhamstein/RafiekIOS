//
//  Utils.swift
//  VerbTool
//
//  Created by Hani on 2/29/16.
//  Copyright © 2016 BrainSocket. All rights reserved.
//

import UIKit

// MARK: Extensions
/// Collection Type shuffle
extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffle2()
        return list
    }
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffle2() {
        // empty and single-element collections don't shuffle
        if count < 2 {
            return
        }
        // swap places
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                self.swapAt(i, j)
            }
        }
    }
}

extension Array where Element: Equatable {
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

