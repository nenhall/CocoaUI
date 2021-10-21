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

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    deinit {
        debugPrint(#function)
    }
    
}
