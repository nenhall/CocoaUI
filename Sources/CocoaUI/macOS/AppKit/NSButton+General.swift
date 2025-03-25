//
//  NSButton+General.swift
//  CocoaUI
//
//  Created by nenhall on 2020/12/30.
//  Copyright © 2020 nenhall. All rights reserved.
//

#if os(macOS)
import AppKit

public extension NSButton {
    
    func addAction(_ action: Selector, target: AnyObject) {
        self.action = action
        self.target = target
    }
    
}
#endif
