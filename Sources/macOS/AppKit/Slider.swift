//
//  Slider.swift
//  NHCocoaUI
//
//  Created by wunh on 2020/11/25.
//

import AppKit

@objc public protocol SliderDelegate {
    @objc optional func sliderDidChanged(slider: Slider)
    @objc optional func sliderDidMouseUp(slider: Slider)
    @objc optional func sliderDidMouseDown(slider: Slider)
}

@IBDesignable
open class SliderCell: NSSliderCell {
    public enum RadiusStyle {
        case normal, coustom(_ value: CGFloat)
    }

    @IBInspectable open var progressColor: NSColor = .controlAccentColor
    @IBInspectable open var barHeight: CGFloat = 3.0
    /// 默认为 .normal，barHeight * 0.5
    open var barRadius: RadiusStyle = .normal
    @IBInspectable open var barColor: NSColor = .separatorColor {
        didSet { controlView?.needsDisplay = true }
    }

    @IBInspectable open var knobColor: NSColor = .white
    /// 默认为 .normal，knobSize.height * 0.5
    open var knobRadius: RadiusStyle = .normal
    @IBInspectable open var knobSize = CGSize(width: 10, height: 10)
    @IBInspectable open var disableBarColor: NSColor = .disabledControlTextColor
    @IBInspectable open var disableKnobColor: NSColor = .disabledControlTextColor
    override open var isEnabled: Bool {
        didSet { controlView?.needsDisplay = true }
    }

    // save partBar's frame, and use to caculate Knob's frame
    private var partBarRect = NSRect.zero
    override open var knobThickness: CGFloat {
        return knobSize.width
    }

    private var newKnobRect = NSRect.zero
    override open func knobRect(flipped _: Bool) -> NSRect {
        return newKnobRect
    }

    override open func barRect(flipped: Bool) -> NSRect {
        let rect = super.barRect(flipped: flipped)
        return NSRect(x: 0, y: rect.minY, width: rect.width + knobSize.width, height: barHeight)
    }

    override open func drawBar(inside orgRect: NSRect, flipped: Bool) {
        guard let controlView = controlView else {
            super.drawBar(inside: orgRect, flipped: flipped)
            return
        }
        var newRect = orgRect

        // Knob position depending on control min/max value and current control value.
        let value = CGFloat((doubleValue - minValue) / (maxValue - minValue))
        if isVertical {
            newRect.size.width = barHeight
            // Final Left Part Width
            let finalWidth = value * (controlView.frame.size.height - knobSize.height)

            // Left Part Rect
            var leftRect = newRect
            leftRect.origin.y = newRect.height - finalWidth
            leftRect.size.height = finalWidth
            partBarRect = leftRect

        } else {
            newRect.size.height = barHeight
//            // Knob position depending on control min/max value and current control value.
//            let value = CGFloat((doubleValue - Double(minValue)) / Double(maxValue - minValue))
            // Left Part Rect
            var leftRect = newRect
            if NSApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                // Final Right Part Width
                let finalWidth = (1 - value) * ((controlView.frame.size.width) - knobSize.width)
                leftRect.origin.x = finalWidth
                let offWidth = controlView.frame.size.width
                leftRect.size.width = offWidth - finalWidth
            } else {
                // Final Left Part Width
                let finalWidth = value * ((controlView.frame.size.width) - knobSize.width)
                leftRect.size.width = finalWidth
            }
            partBarRect = leftRect
        }

        let radius: CGFloat
        switch barRadius {
        case let .coustom(value):
            radius = value
        default:
            radius = barHeight * 0.5
        }

        // Draw Left Part
        let leftPartPath = NSBezierPath(roundedRect: CGRect(x: newRect.minX, y: newRect.minY, width: controlView.bounds.width, height: newRect.height), xRadius: radius, yRadius: radius)

        if isEnabled {
            barColor.setFill()
        } else {
            disableBarColor.setFill()
        }
        leftPartPath.fill()

        // Draw Right Part
        let rightPartPath = NSBezierPath(roundedRect: CGRect(x: partBarRect.minX, y: partBarRect.minY, width: partBarRect.width + knobSize.width, height: partBarRect.height), xRadius: radius, yRadius: radius)
        if isEnabled {
            progressColor.setFill()
        } else {
            disableBarColor.setFill()
        }
        rightPartPath.fill()
    }

    override open func drawKnob(_ knobRect: NSRect) {
        var newKnobRect = knobRect
        if isVertical {
            newKnobRect = NSRect(
                x: partBarRect.origin.x + (partBarRect.size.width / 2) - (knobSize.height / 2),
                y: knobRect.origin.y,
                width: knobSize.width,
                height: knobSize.height
            )
            if partBarRect.size.height == 0 {
//                newKnobRect.origin.y = newKnobRect.origin.y - 1;
            }
        } else {
            var x = partBarRect.size.width
            if NSApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                x = partBarRect.origin.x
            }
            //    if (((NSSlider *)self.controlView).highlighted) {
            newKnobRect = NSRect(
                x: x,
                y: partBarRect.origin.y + partBarRect.size.height / 2 - knobSize.height / 2,
                width: knobSize.width,
                height: knobSize.height
            )
            //    }
        }
        self.newKnobRect = newKnobRect

        let bezierpath: NSBezierPath
        switch knobRadius {
        case let .coustom(value):
            bezierpath = NSBezierPath(
                roundedRect: newKnobRect,
                xRadius: value,
                yRadius: value
            )
        default:
            bezierpath = NSBezierPath(
                roundedRect: newKnobRect,
                xRadius: knobSize.height * 0.5,
                yRadius: knobSize.height * 0.5
            )
        }
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 2, height: 2)
        shadow.shadowColor = knobColor.withAlphaComponent(0.5)
        if isEnabled {
            knobColor.setFill()
        } else {
            disableKnobColor.setFill()
        }
        bezierpath.fill()
    }
}

/// 暂不支持竖直模式
@IBDesignable
open class Slider: NSSlider {
    /// Default：.controlAccentColor
    @IBInspectable open var progressColor: NSColor {
        get { return customCell?.progressColor ?? .controlAccentColor }
        set { customCell?.progressColor = newValue }
    }

    /// Default：.white
    @IBInspectable open var knobColor: NSColor {
        get { return customCell?.knobColor ?? .white }
        set { customCell?.knobColor = newValue }
    }

    /// Default：.separatorColor
    @IBInspectable open var barColor: NSColor {
        get { return customCell?.barColor ?? .separatorColor }
        set { customCell?.barColor = newValue }
    }

    /// Default：.knobColor
    @IBInspectable open var disableBarColor: NSColor {
        get { return customCell?.disableBarColor ?? .knobColor }
        set { customCell?.disableBarColor = newValue }
    }

    @IBInspectable open var disableKnobColor: NSColor {
        get { return customCell?.disableKnobColor ?? .white }
        set { customCell?.disableKnobColor = newValue }
    }

    /// Default：3.0
    @IBInspectable open var barHeight: CGFloat {
        get { return customCell?.barHeight ?? 3.0 }
        set { customCell?.barHeight = newValue }
    }

    /// 默认为 .normal，knobSize.height * 0.5
    open var knobRadius: SliderCell.RadiusStyle = .normal

    /// 默认为 .normal，barHeight * 0.5
    open var barRadius: SliderCell.RadiusStyle = .normal

    @IBInspectable open var knobSize: CGSize {
        get { return customCell?.knobSize ?? .zero }
        set { customCell?.knobSize = newValue }
    }

    @IBOutlet public weak var delegate: SliderDelegate?

    /// 当前定制的`Cell`，等价 `.cell`
    public var customCell: SliderCell? {
        return cell as? SliderCell
    }

    override open var cell: NSCell? {
        get { return super.cell }
        set {
            newValue?.target = cell?.target
            newValue?.action = cell?.action
            super.cell = newValue
        }
    }

    private var isMouseUp: Bool = false

    override open func awakeFromNib() {
        super.awakeFromNib()
        configCustommCell()
    }

    public convenience init(frame frameRect: NSRect = .zero, knobColor: NSColor, knobSize: NSSize = .init(width: 10, height: 10), barColor: NSColor, barHeight: CGFloat) {
        self.init(frame: frameRect)

        self.knobColor = knobColor
        self.knobSize = knobSize
        self.barColor = barColor
        self.barHeight = barHeight
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configCustommCell()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configCustommCell() {
        cell = SliderCell()
        cell?.action = #selector(sliderChangedAction)
        cell?.target = self
        cell?.isContinuous = true
    }

    @objc private func sliderChangedAction() {
        delegate?.sliderDidChanged?(slider: self)
    }

    override open func mouseUp(with event: NSEvent) {
        if isMouseUp == false {
            isMouseUp = true
            delegate?.sliderDidMouseUp?(slider: self)
        }
        super.mouseUp(with: event)
    }

    override open func mouseDown(with event: NSEvent) {
        isMouseUp = false
        delegate?.sliderDidMouseDown?(slider: self)
        super.mouseDown(with: event)
        if isMouseUp == false {
            if let event = NSApp.currentEvent, event.type == .leftMouseUp {
                delegate?.sliderDidMouseUp?(slider: self)
            }
        }
    }

    override open func mouseDragged(with _: NSEvent) {
        delegate?.sliderDidChanged?(slider: self)
    }
}
