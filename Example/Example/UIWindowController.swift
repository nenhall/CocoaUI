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


    }
    
    
    override func windowWillCloseNotification(_ note: Notification) {
        super.windowWillCloseNotification(note)
        
    }
    
    deinit {
        debugPrint(className, #function)
    }
    
}
