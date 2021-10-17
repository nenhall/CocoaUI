//
//  ViewController.swift
//  Example
//
//  Created by nenhall on 2021/10/17.
//

import Cocoa
import CocoaUIKit

class ViewController: NSViewController {

    @IBOutlet weak var customSlider: CoSlider!
    @IBOutlet weak var vSlider: CoSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlider()
  
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    override func mouseDown(with event: NSEvent) {
        
    }
    
    

}

extension ViewController: CoSliderDelegate {
    
    func addSlider() {
        let sliderFive = CoSlider()
        sliderFive.cell = CoSliderCell()
        sliderFive.minValue = 1
        sliderFive.maxValue = 1000
        sliderFive.isVertical = false
        sliderFive.target = self
        sliderFive.action = #selector(sliderDidChanged(slider:))
        sliderFive.delegate = self
        self.view.addSubview(sliderFive)
        sliderFive.frame = CGRect(x: 10, y: 0, width: 100, height: 30)
    }
    
    func sliderDidChanged(slider: CoSlider) {
        debugPrint(#function, slider.doubleValue)
    }
    
    func sliderDidMouseUp(slider: CoSlider) {
        debugPrint(#function)
    }
    
    func sliderDidMouseDown(slider: CoSlider) {
        debugPrint(#function)
    }
}



