//
//  NSWindow+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2021/10/21.
//

import AppKit

public extension NSWindow {
    
    /// 模态显示窗口
    @discardableResult
    func showModalWindow() -> Bool {
        NSApp.runModal(for: self)
        return true
    }
    
    /// 结束模态窗口显示
    @discardableResult
    func endAndCloseModalWindow() -> Bool {
        close()
        NSApp.stopModal()
        return true
    }
    
}

public extension NSWindowController {
    
    /// 模态显示窗口
    @discardableResult
    func showModalWindow() -> Bool {
        guard let window = window else {
            return false
        }
        NSApp.runModal(for: window)
        return true
    }

    /// 结束模态窗口显示
    @discardableResult
    func endAndCloseModalWindow() -> Bool {
        guard let window = window else {
            return false
        }
        window.close()
        NSApp.stopModal()
        return true
    }
    
}
