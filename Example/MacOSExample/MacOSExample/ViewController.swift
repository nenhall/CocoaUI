//
//  ViewController.swift
//  MacOSExample
//
//  Created by nenhall on 2022/4/13.
//

import Cocoa
import CocoaUIMacOS

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let slider = Slider(frame: NSRect(x: 20, y: 20, width: 300, height: 30))
        slider.target = self
        slider.action = #selector(didChangeValue(slider:))
        slider.minValue = 0
        slider.maxValue = 10
        slider.intValue = 2
        slider.barColor = .separatorColor
        slider.progressColor = .controlAccentColor
        slider.knobColor = .orange
        slider.knobSize = CGSize(width: 20, height: 20)
        slider.barHeight = 18
        slider.barRadius = .normal
        view.addSubview(slider)
    }
    
    @objc func didChangeValue(slider: Slider) {
//        print(slider.floatValue)
    }


}
