//
//  NSocalized+Extension.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/1/19.
//

import AppKit

public extension NSMenuItem {
    
    @IBInspectable var localizedString: String {
        set {
            title = NSLocalizedString(newValue, comment: newValue)
        }
        get {
            return title
        }
    }
}

public extension NSControl {
    @IBInspectable var localizedString: String {
        set {
            if let button = self as? NSButton {
                button.title = NSLocalizedString(newValue, comment: newValue)
            } else {
                stringValue = NSLocalizedString(newValue, comment: newValue)
            }
        }
        get {
            return stringValue
        }
    }
}

public extension NSView {
    @IBInspectable var localizedTip: String {
        set {
            toolTip = NSLocalizedString(newValue, comment: newValue)
        }
        get {
            return toolTip ?? String()
        }
    }
}
