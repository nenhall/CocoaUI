//
//  Array.swift
//  PDFelement
//
//  Created by nenhall on 2022/2/25.
//

import Foundation

public extension Array where Element: Equatable {

    mutating func move(_ item: Element, to newIndex: Index) {
        if let index = firstIndex(of: item) {
            move(at: index, to: newIndex)
        }
    }
}

public extension Array {

    mutating func move(at index: Index, to newIndex: Index) {
        insert(remove(at: index), at: newIndex)
    }
}
