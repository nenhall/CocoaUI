//
//  UIWindowController.swift
//  Example
//
//  Created by nenhall on 2021/10/21.
//

import Cocoa
import CocoaUIKit

class UIWindowController: CoWindowController {

    @IBOutlet weak var label: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(windowWillCloseNotification2(_:)), name: NSWindow.willCloseNotification, object: self)

    }
    
    
    @objc func windowWillCloseNotification2(_ note: Notification) {
        NSApp.stopModal()
    }
    
    override func windowWillCloseNotification(_ note: Notification) {
        NSApp.stopModal()
    }
    
    deinit {
        debugPrint(#function)
    }
    
}
