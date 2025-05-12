//
//  UI+extent.swift
//  
//
//  Created by nenhall on 2022/8/20.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

#if os(macOS)
extension NSTextField {
    public func setBackground(color: NSColor) {
        backgroundColor = color
    }
}
#endif


public extension UIWindow {
#if os(iOS)
    static var safeAreaInsets: UIEdgeInsets {
        guard let window = UIApplication.shared.windows.first else {
            return .zero
        }
        return window.safeAreaInsets
    }
#else
    static var safeAreaInsets: UIEdgeInsets {
        if #available(macOS 12.0, *) {
            guard let keyWindow = NSApplication.shared.keyWindow, let screen = keyWindow.screen else {
                return UIEdgeInsets()
            }
            return screen.safeAreaInsets
        } else {
            return UIEdgeInsets()
        }
    }
    
    static var navigationBarHeight: CGFloat {
        guard let keyWindow = NSApplication.shared.keyWindow else {
            return 0
        }
        let windowHeight = keyWindow.frame.height
        let contentViewHeight = keyWindow.contentView?.frame.height ?? 0
        let navigationBarHeight = windowHeight - contentViewHeight
        print("导航栏高度: \(navigationBarHeight)")
        return navigationBarHeight
    }
#endif
}
