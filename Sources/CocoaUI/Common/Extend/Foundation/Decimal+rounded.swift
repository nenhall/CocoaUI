//
//  File.swift
//  
//
//  Created by nenhall on 5/9/25.
//

import Foundation

public extension Decimal {
    func rounded(_ scale: Int) -> Decimal {
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, scale, .plain)
        return result
    }
}
