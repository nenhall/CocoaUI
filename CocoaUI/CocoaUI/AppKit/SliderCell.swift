//
//  NHSlider.swift
//  NHCocoaUI
//
//  Created by wunh on 2020/11/25.
//

import Cocoa



@objc public protocol NHSliderDelegate {
    @objc optional func sliderDidChanged(slider: NHSlider)
    @objc optional func sliderDidMouseUp(slider: NHSlider)
    @objc optional func sliderDidMouseDown(slider: NHSlider)
}


@IBDesignable
public class NHSliderCell: NSSliderCell {
    @IBInspectable public var progressColor: NSColor = .systemBlue
    @IBInspectable public var backgroundColor: NSColor = .knobColor
    @IBInspectable public var knobColor: NSColor = NSColor.white
    @IBInspectable public var sliderHeight: CGFloat = 3.0
    @IBInspectable public var barRadius: CGFloat = 1.5
    @IBInspectable public var knobWidth: CGFloat = 10.0
    @IBInspectable public var knobHeight: CGFloat = 10.0
    
    // save partBar's frame, and use to caculate Knob's frame
    private var partBarRect = NSRect.zero
    
    public override func drawBar(inside orgRect: NSRect, flipped: Bool) {
        var newRect = orgRect
        
        if isVertical {
            newRect.size.width = sliderHeight
            // Knob position depending on control min/max value and current control value.
            let value = CGFloat((doubleValue - minValue) / ( maxValue - minValue))
            // Final Left Part Width
            let finalWidth = ( value) * (controlView?.frame.size.height ?? 0.0 - knobHeight);
            
            // Left Part Rect
            var leftRect = newRect;
            leftRect.origin.y = newRect.height - finalWidth
            leftRect.size.height = finalWidth;
            partBarRect = leftRect;
            
        } else {
            newRect.size.height = sliderHeight
            // Knob position depending on control min/max value and current control value.
            let value = CGFloat((doubleValue - Double(minValue)) / Double((maxValue - minValue)))
            // Left Part Rect
            var leftRect = newRect
            if NSApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                // Final Right Part Width
                let finalWidth = (1 - value) * ((controlView?.frame.size.width ?? 0.0) - knobWidth)
                leftRect.origin.x = finalWidth
                let offWidth = controlView?.frame.size.width ?? 0.0
                leftRect.size.width = offWidth - finalWidth
            } else {
                // Final Left Part Width
                let finalWidth = value * ((controlView?.frame.size.width ?? 0.0) - knobWidth)
                leftRect.size.width = finalWidth
            }
            
            partBarRect = leftRect
        }
        
        print("\(NSStringFromRect(newRect)) > \(NSStringFromRect(partBarRect))")
        
        // Draw Left Part
        let bg = NSBezierPath(roundedRect: newRect, xRadius: barRadius, yRadius: barRadius)
        backgroundColor.setFill()
        bg.fill()

        // Draw Right Part
        let active = NSBezierPath(roundedRect: partBarRect, xRadius: barRadius, yRadius: barRadius)
        progressColor.setFill()
        active.fill()
    }
    
    public override func drawKnob(_ knobRect: NSRect) {
        var newKnobRect = knobRect
        if isVertical {
            newKnobRect = NSRect(x: partBarRect.origin.x + (partBarRect.size.width / 2) - (knobHeight / 2), y: knobRect.origin.y, width: knobWidth, height: knobHeight)
            if partBarRect.size.height == 0 {
//                newKnobRect.origin.y = newKnobRect.origin.y - 1;
            }
         
        } else {
            var x = partBarRect.size.width
            if NSApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                x = partBarRect.origin.x
            }
            //    if (((NSSlider *)self.controlView).highlighted) {
            newKnobRect = NSRect(x: x, y: partBarRect.origin.y + partBarRect.size.height / 2 - knobHeight / 2, width: knobWidth, height: knobHeight)
            //    }
        }
        
        // Draw Left Part
        let bg = NSBezierPath(roundedRect: newKnobRect, xRadius: knobWidth, yRadius: knobWidth / 2.0)
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowColor = NSColor.red
        knobColor.setFill()
        bg.fill()
    }
}

/// 需要配合`NHSliderCell`使用，需要在xib或者使用`NHSlider.cell`=`NHSliderCell()`
@IBDesignable
public class NHSlider: NSSlider {
    
    /// Default：.systemBlue
    @IBInspectable public var progressColor: NSColor {
        set { customCell?.progressColor = newValue }
        get { return customCell?.progressColor ?? .systemBlue }
    }
    /// Default：.knobColor
    @IBInspectable public var backgroundColor: NSColor {
        set { customCell?.backgroundColor = newValue }
        get { return customCell?.backgroundColor ?? .knobColor }
    }
    /// Default：.white
    @IBInspectable public var knobColor: NSColor {
        set { customCell?.knobColor = newValue }
        get { return customCell?.knobColor ?? .white }
    }
    /// Default：3.0
    @IBInspectable public var sliderHeight: CGFloat {
        set { customCell?.sliderHeight = newValue }
        get { return customCell?.sliderHeight ?? 3.0 }
    }
    /// Default：1.5
    @IBInspectable public var sliderBarRadius: CGFloat {
        set { customCell?.barRadius = newValue }
        get { return customCell?.barRadius ?? 1.5 }
    }
    /// Default：10.0
    @IBInspectable public var knobWidth: CGFloat {
        set { customCell?.knobWidth = newValue }
        get { return customCell?.knobWidth ?? 10.0 }
    }
    /// Default：10.0
    @IBInspectable public var knobHeight: CGFloat {
        set { customCell?.knobHeight = newValue }
        get { return customCell?.knobHeight ?? 10.0 }
    }
    
    @IBOutlet public weak var delegate: NHSliderDelegate? {
        willSet {
            if action == nil, target == nil {
                action = #selector(sliderChangedAction)
                target = self
            }
        }
    }
    /// 当前定制的`Cell`，等阶 `.cell`
//    public private(set) var customCell = WSSliderCell()
    public var customCell: NHSliderCell? {
        return cell as? NHSliderCell
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        configCustommCell()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configCustommCell()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configCustommCell() {

    }
    
    @objc func sliderChangedAction()  {
        delegate?.sliderDidChanged?(slider: self)
    }
    
    public override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        delegate?.sliderDidMouseUp?(slider: self)
    }
    
    public override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        delegate?.sliderDidMouseDown?(slider: self)
    }

}

