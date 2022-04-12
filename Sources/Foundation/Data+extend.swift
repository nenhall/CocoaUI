//
//  Data+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/4/12.
//

import Foundation

public extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
