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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
     
      
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        ((view.window) as? CoWindow)?.titleBarView?.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        debugPrint(keyPath,  ((view.window) as? CoWindow)?.titleBarView?.frame)
    }
    
    override func mouseDown(with event: NSEvent) {
        if let toolbarView = (view.window as? CoWindow)?.toolbarView {
            let button = NSButton(title: "我就按钮", target: nil, action: nil)
            toolbarView.addSubview(button)

            let button2 = NSButton(title: "我就按钮2", target: nil, action: nil)
            toolbarView.addSubview(button2)
   
        }
//        let uiWindowControl = UIWindowController.loadNib()
//        guard let uiWindow = uiWindowControl.window else { return }
//        uiWindow.showModalWindow()
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



