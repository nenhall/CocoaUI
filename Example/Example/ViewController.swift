//
//  ViewController.swift
//  Example
//
//  Created by nenhall on 2021/10/17.
//

import Cocoa
import CocoaUIKit

class ViewController: NSViewController {

    @IBOutlet weak var customSlider: CocoSlider!
    @IBOutlet weak var vSlider: CocoSlider!
    
    @IBOutlet weak var hoveButton: CocoButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSlider()
        addButtonToToolbar()
        
        
        
        hoveButton.stringValue = "CocoButton"
        hoveButton.setColor(.red, to: .title, for: .normal)
        hoveButton.setColor(.black, to: .title, for: .pressed)
        hoveButton.setColor(.orange, to: .background, for: .normal)
        hoveButton.setColor(.gray, to: .background, for: .pressed)
        hoveButton.setImage(NSImage.image(size: CGSize(width: 30, height: 30), color: .purple, radius: 5), for: .normal)
        
        var support1 = SupportDirectory2.support
        var support2 = SupportDirectory3.support
        var main = AppDirectoryAdapter.app

        let _ = FileManager.path22(from: .applicationDirectory, subPath: main.append(support1.append(support2)))
        debugPrint("")
    }

    
    func addButtonToToolbar() {
        if let toolbarView = (view.window as? CocoWindow)?.leftToolBarBox {
            let button = NSButton(title: "我就按钮", target: nil, action: nil)
            toolbarView.addArrangedSubview(button)

            let button2 = NSButton(title: "我就按钮2", target: nil, action: nil)
            toolbarView.addArrangedSubview(button2)
        }
    }
    
    func showModalWindow() {
        let uiWindowControl = UIWindowController.loadNib()
        guard let uiWindow = uiWindowControl.window else { return }
        uiWindow.showModalWindow()
    }

}

extension ViewController: CocoSliderDelegate {
    
    func addSlider() {
        let sliderFive = CocoSlider()
        sliderFive.cell = CocoSliderCell()
        sliderFive.minValue = 1
        sliderFive.maxValue = 1000
        sliderFive.isVertical = false
        sliderFive.target = self
        sliderFive.action = #selector(sliderDidChanged(slider:))
        sliderFive.delegate = self
        sliderFive.isContinuous = false
        self.view.addSubview(sliderFive)
        sliderFive.frame = CGRect(x: 10, y: 0, width: 100, height: 30)
    }
    
    func sliderDidChanged(slider: CocoSlider) {
        debugPrint(#function, slider.doubleValue)
    }
    
    func sliderDidMouseUp(slider: CocoSlider) {
        debugPrint(#function)
    }
    
    func sliderDidMouseDown(slider: CocoSlider) {
        debugPrint(#function)
    }
}



