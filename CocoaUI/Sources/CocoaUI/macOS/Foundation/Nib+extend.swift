//
//  Nib+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2021/10/21.
//

import Cocoa

// MARK: - NSViewController xib
public extension NSViewController {
    class func loadNib() -> Self {
        return self.init(nibName: NSNib.Name(className()), bundle: nil)
    }
}


// MARK: - NSWindowController xib
public extension NSWindowController {
    
    class func nibName() -> NSNib.Name {
        let subNames = className().split(separator: ".")
        if let name = subNames.last {
            return NSNib.Name(name)
        }
        return NSNib.Name(className())
    }
    
    class func loadNib() -> Self {
        return Self.init(windowNibName: nibName())
    }
}
