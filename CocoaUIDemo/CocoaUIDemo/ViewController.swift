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

       let sliderFive = NHSlider()
        sliderFive.minValue = 1
        sliderFive.maxValue = 1000
//        sliderFive.doubleValue = 1000
        sliderFive.isVertical = false
        sliderFive.target = self
        self.view.addSubview(sliderFive)
        sliderFive.frame = CGRect(x: 10, y: 0, width: 100, height: 30)

        
        let sliderFive2 = NHSlider()
        sliderFive2.minValue = 1
        sliderFive2.maxValue = 1000
 //        sliderFive.doubleValue = 1000
        sliderFive2.isVertical = true
        sliderFive2.target = self
         self.view.addSubview(sliderFive2)
        sliderFive2.frame = CGRect(x: 100, y: 20, width: 30, height: 100)
  
    }

}

