//
//  NumberType+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/4/12.
//

import Foundation
import CoreGraphics

public extension Int {

    var isEven: Bool {
        return self % 2 == 0
    }

    var isOdd: Bool {
        return self % 2 == 1
    }
}

public extension CGFloat {

    func isMinimum(of values: [CGFloat]) -> Bool {
        return !values.contains { $0 < self }
    }
}

public extension Float {

    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()

    func localizedPrice(_ locale: Locale) -> String {
        Float.currencyFormatter.locale = locale
        return Float.currencyFormatter.string(from: NSNumber(value: self))!
    }
}

protocol BinaryToRadian {
    var toRadian: Self { get }
}

extension Float: BinaryToRadian { }

extension Double: BinaryToRadian { }

extension Int: BinaryToRadian { }

extension CGFloat: BinaryToRadian { }

public extension FloatingPoint {
    /// 转换成弧度
    var toRadian: Self {
        return self / Self(180) * Self.pi
    }
}

public extension BinaryInteger {
    /// 转换成弧度
    var toRadian: Self {
        return self / Self(180) * Self(Double.pi)
    }
}

