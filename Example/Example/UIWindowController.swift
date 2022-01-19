//
//  UIWindowController.swift
//  Example
//
//  Created by nenhall on 2021/10/21.
//

import Cocoa
import CocoaUIKit

class UIWindowController: CocoWindowController {

    @IBOutlet weak var label: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()


    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let button = NSButton(title: "我就按钮", target: nil, action: nil)
//        button.frame = NSRect(x: 0, y: 0, width: 50, height: 30)
        ownerWindow?.rightToolBarBox.addSubview(button)
    }
    
    
    override func windowWillCloseNotification(_ note: Notification) {
        super.windowWillCloseNotification(note)
        
    }
    
    deinit {
        debugPrint(className, #function)
    }
    
}
