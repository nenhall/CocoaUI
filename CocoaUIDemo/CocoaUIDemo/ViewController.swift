//
//  ViewController.swift
//  CocoaUIDemo
//
//  Created by wunh on 2020/11/25.
//

import Cocoa
import CocoaUI


class ViewController: NSViewController {

    @IBOutlet weak var customSlider: NHSlider!
    @IBOutlet weak var vSlider: NHSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let image = NSImage(named: NSImage.Name("bb.png"))
        customSlider.knobImage = image
//        vSlider.knobImage = image

        
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
     
//        customSlider.progressColor = .red
        customSlider.showValueOnKnob = true
//        customSlider.knobTitle = "100"
        
//        vSlider.progressColor = .red
//        vSlider.barColor = .white
//        vSlider.showValueOnKnob = true
//        vSlider.knobTitle = "100"

    }


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

