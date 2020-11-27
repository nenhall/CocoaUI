//
//  NHSliderCell.swift
//  NHCocoaUI
//
//  Created by wunh on 2020/11/25.
//

import Cocoa




public class NHSliderCell: NSSliderCell {
    
    /// 已加载进度颜色
    @IBInspectable public var progressColor: NSColor? {
        didSet {
            controlView?.display()
        }
    }

    /// 背景色
    @IBInspectable public var backgroundColor: NSColor? {
        didSet {
            guard let controlView = controlView else {
                return
            }
            if let bColor = backgroundColor {
                controlView.wantsLayer = true
                controlView.layer?.backgroundColor = bColor.cgColor
            } else {
                controlView.wantsLayer = false
            }
        }
    }
    
    /// 进度条的高，default: 6
    @IBInspectable public var barHeight: CGFloat = 6 {
        didSet {
            controlView?.display()
        }
    }
    
    /// 进度条的颜色 NSColor.withHex(0xffa500).setFill()
    @IBInspectable public var barColor: NSColor? {
        didSet {
            controlView?.display()
        }
    }
    
    /// 进度条的圆角，default: 2
    @IBInspectable public var barRadius: CGFloat = 3 {
        didSet {
            controlView?.display()
        }
    }
    /// 旋钮的宽，default: 20
    @IBInspectable public var knobWidth: CGFloat = 20 {
        didSet {
            controlView?.display()
        }
    }
    /// 旋钮的高，default: 20
    @IBInspectable public var knobHeight: CGFloat = 20 {
        didSet {
            controlView?.display()
        }
    }
    
    /// 旋钮颜色
    @IBInspectable public var knobColor: NSColor? {
        didSet {
            controlView?.display()
        }
    }
    
    /// 旋钮的背景图，默认会截成圆角
    @IBInspectable public var knobImage: NSImage? {
        didSet {
            controlView?.display()
        }
    }
    
    /// 旋钮的背景图是否使用原图(自动裁剪)，默认`false`，会截成圆角
    @IBInspectable public var knobOriginalImage: Bool = false {
        didSet {
            controlView?.display()
        }
    }
    
    /// 旋钮的的阴影偏移，default：CGSize(2.0, 2.0)，旋钮为图片时无效
    @IBInspectable public var knobShadowOffset = CGSize(width: 2.0, height: -2.0) {
        didSet {
            controlView?.display()
        }
    }
    
    /// 旋钮的文字
    @IBInspectable public var knobTitle: String? {
        didSet {
            needResetTitlePostion = true
            if let knobTitle = knobTitle {
                let attributedString = NSAttributedString(string: knobTitle, attributes: titleAttributes)
                let boundSize = CGSize(width: knobWidth, height: knobHeight)
                let size = attributedString.boundingRect(with: boundSize, options: .usesFontLeading)
                knobTitleSize = size.size
                needResetTitlePostion = false
                controlView?.display()
            }
        }
    }
    
    /// 在旋钮上显示当前值
    @IBInspectable public var showValueOnKnob = false {
        didSet { controlView?.display() }
    }

    /// 旋钮文字的富文本属性,default: fontSize: 10
    public lazy var titleAttributes: [NSAttributedString.Key : Any] = {
        var paragraph = NSMutableParagraphStyle.init()
        paragraph.alignment = NSTextAlignment.center
        let attributes = [NSAttributedString.Key.font : NSFont.systemFont(ofSize: 10),
                           .foregroundColor : NSColor.black,
                           .paragraphStyle : paragraph]
        return attributes
    }()
    
    
    private var barRect = NSRect.zero
    private var needResetTitlePostion = true
    private var knobTitleSize = CGSize.zero
    

    public override init() {
        super.init()
        addKnobView()

    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        addKnobView()

    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        addKnobView()
    }

    
    func addKnobView() {
        
      
    }
    
    public override func drawBar(inside rect: NSRect, flipped: Bool) {
        var newRect = rect
        if isVertical {
            //垂直
            newRect.size.width = barHeight

            // Knob position depending on control min/max value and current control value.
            let value = CGFloat((doubleValue - minValue) / (maxValue - minValue))

            // Left Part Rect
            barRect = newRect
            if let controlView = controlView {
                // Final Left Part Width

                let finalWidth = value * (controlView.frame.size.height - knobHeight)
                barRect.size.height = finalWidth
                if barRect.height != 0 {
//                    barRect.size.height = finalWidth + newRect.origin.y
                }
//                debugPrint(newRect, barRect)

                barRect.origin.y = rect.height - finalWidth + newRect.origin.y
            }
            
        } else {
            //水平
            newRect.size.height = barHeight

            // Knob position depending on control min/max value and current control value.
            let value = CGFloat((doubleValue - minValue) / (maxValue - minValue))

            // Left Part Rect
            barRect = newRect
            if let controlView = controlView {
                // Final Left Part Width
                let finalWidth = value * (controlView.frame.size.width - knobWidth)
                barRect.size.width = finalWidth
            }
        }

        if barColor == nil && progressColor == nil {
            super.drawBar(inside: rect, flipped: flipped)
        } else {
            if barColor == nil || progressColor == nil {
                super.drawBar(inside: newRect, flipped: flipped)
            }
        }
        
        if let barColor = barColor {
            // Draw bar backgroundColor
            let barBezier = NSBezierPath(roundedRect: newRect, xRadius: barRadius, yRadius: barRadius)
            barColor.setFill()
            barBezier.fill()
        }

        if let progressColor = progressColor {
             // Draw progressColor Part
            let pBezier = NSBezierPath(roundedRect: barRect, xRadius: barRadius, yRadius: barRadius)
            progressColor.setFill()
            pBezier.fill()
        }
    }

    public override func drawKnob(_ knobRect: NSRect) {

        let isOverrun = knobHeight <= knobRect.height && knobWidth <= knobRect.width
        assert(isOverrun, "旋钮的宽或者高超出系统最大限制[\(knobRect.size)]，渲染无法正常进行")
        
        var newRect = NSRect.zero
        if isVertical {
            newRect = NSRect(x: barRect.origin.x + barRect.size.width / 2 - knobHeight / 2, y: knobRect.origin.y, width: knobWidth, height: knobHeight)
//            if barRect.size.height == 0 {
                newRect.origin.y = newRect.origin.y + 2
//            }
        } else {
            newRect = NSRect(x: barRect.size.width, y: barRect.origin.y + barRect.size.height / 2 - knobHeight / 2, width: knobWidth, height: knobHeight)
        }
        
        if NSApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
            newRect.origin.x = knobRect.maxX - knobWidth - 2
        }
        
        var isCustom = false
        
        if let knobColor = knobColor {
            let bgBezier = NSBezierPath(roundedRect: newRect, xRadius: knobWidth, yRadius: knobHeight)
            let shadow = NSShadow()
            shadow.shadowOffset = knobShadowOffset
            shadow.shadowColor = knobColor.withAlphaComponent(0.5)
            knobColor.setFill()
            bgBezier.fill()
            isCustom = true
        }
        
        if let knobImage = knobImage {
            if knobOriginalImage {
                knobImage.draw(in: newRect, from: NSZeroRect, operation: .copy, fraction: 1, respectFlipped: true, hints: nil)
            } else {
                if knobColor == nil {
                    knobColor = .white
                }
                knobImage.draw(in: newRect, from: NSZeroRect, operation: .sourceIn, fraction: 1, respectFlipped: true, hints: nil)
            }
            isCustom = true
        }
        
        if isCustom == false {
            super.drawKnob(knobRect)
        }
        
        if showValueOnKnob == true {
            let aTitle = NSMutableAttributedString(string: stringValue, attributes: titleAttributes)
            newRect.origin.y = (newRect.minY + (newRect.height * 0.5) + 3)
            aTitle.draw(with: newRect, options: .usesFontLeading)
        } else {
            if let knobTitle = knobTitle  {
                let aTitle = NSMutableAttributedString(string: knobTitle, attributes: titleAttributes)
                newRect.origin.y += (knobTitleSize.height + 1)
                aTitle.draw(with: newRect, options: .usesFontLeading)
            }
        }
    }
}
