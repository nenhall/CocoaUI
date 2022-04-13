//
//  NSColor.swift
//  NHCocoaUI
//
//  Created by wunh on 2020/11/25.
//

import AppKit

public extension NSColor {
    
    // 16进制颜色值转换成颜色
    class func withHex(_ hex: Int, alpha: CGFloat = 1.0) -> NSColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xFF) / 255.0
        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
