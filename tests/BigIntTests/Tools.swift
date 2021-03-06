//
//  Tools.swift
//  BigInt
//
//  Created by Károly Lőrentey on 2017-7-23.
//  Copyright © 2017 Károly Lőrentey. All rights reserved.
//

import BigInt

@inline(never)
func noop<T>(_ value: T) {
    _ = value
}

// A basic low-quality random number generator.
struct PseudoRandomNumbers: Sequence, IteratorProtocol {
    typealias Element = BigUInt.Digit
    var last: Element

    init(seed: Element) {
        self.last = seed
    }

    mutating func next() -> Element? {
        // Constants are from Knuth's MMIX and Numerical Recipes, respectively
        let a: Element = (MemoryLayout<Element>.size == 8 ? 6364136223846793005 : 1664525)
        let c: Element = (MemoryLayout<Element>.size == 8 ? 1442695040888963407 : 1013904223)
        last = a &* last &+ c
        return last
    }
}

func convertWords<S: Sequence>(_ wideWords: S) -> [UInt] where S.Iterator.Element == UInt64 {
    switch 8 * MemoryLayout<UInt>.size {
    case 64:
        return wideWords.map { UInt($0) }
    case 32:
        return wideWords.flatMap { [UInt($0 & 0xFFFFFFFF), UInt($0 >> 32)]}
    default:
        fatalError("Unexpected word width")
    }
}

extension String {
    func repeated(_ count: Int) -> String {
        var result = ""
        for _ in 0 ..< count {
            result += self
        }
        return result
    }
}


