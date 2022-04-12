//
//  NumberType+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/4/12.
//

import Foundation

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

