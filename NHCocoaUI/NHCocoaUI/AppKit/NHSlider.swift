//
//  NHSlider.swift
//  NHCocoaUI
//
//  Created by wunh on 2020/11/25.
//

import Cocoa


/// 使用此`NHSlider`自动绑定的`NHSliderCell`，无法更绑其它cell
public class NHSlider: NSSlider {
    
    /// 当前Cell，使用此slider自动绑定的`NHSliderCell`，无法更绑其它cell
    public private(set) var sliderCell = NHSliderCell.init()
    
    /// 进度颜色，代表已读取的进长区域
    @IBInspectable public var progressColor: NSColor? {
        set {
            sliderCell.progressColor = newValue
        }
        get {
           return sliderCell.progressColor
        }
    }
    
    /// 背景色
    @IBInspectable public var backgroundColor: NSColor? {
        set {
            sliderCell.backgroundColor = newValue
        }
        get {
           return sliderCell.backgroundColor
        }
    }
    
    /// 进度条的高，default: 6
    @IBInspectable public var barHeight: CGFloat {
        set {
            sliderCell.barHeight = newValue
        }
        get {
            return sliderCell.barHeight
        }
    }
    
    /// 进度条的圆角值，default: 3
    @IBInspectable public var barRadius: CGFloat {
        set {
            sliderCell.barRadius = newValue
        }
        get {
            return sliderCell.barRadius
        }
    }
    
    /// 进度条颜色 NSColor.withHex(0xffa500).setill()
    @IBInspectable public var barColor: NSColor? {
        set {
            sliderCell.barColor = newValue
        }
        get {
            return sliderCell.barColor
        }
    }
    
    /// 旋钮的宽度，default: 20
    @IBInspectable public var knobWidth: CGFloat {
        set {
            sliderCell.knobWidth = newValue
        }
        get {
            return sliderCell.knobWidth
        }
    }
    
    /// 旋钮的高度，default: 20
    @IBInspectable public var knobHeight: CGFloat {
        set {
            sliderCell.knobHeight = newValue
        }
        get {
            return sliderCell.knobHeight
        }
    }
    
    /// 旋钮的颜色
    @IBInspectable public var knobColor: NSColor? {
        set {
            sliderCell.knobColor = newValue
        }
        get {
            return sliderCell.knobColor
        }
    }
    
    /// 旋钮的背景图，默认会截成圆角
    @IBInspectable public var knobImage: NSImage? {
        set {
            sliderCell.knobImage = newValue
        }
        get {
           return sliderCell.knobImage
        }
    }
    
    /// 旋钮的背景图是否使用原图(自动裁剪)，默认`false`，会截成圆角
    @IBInspectable public var knobOriginalImage: Bool {
        set {
            sliderCell.knobOriginalImage = newValue
        }
        get {
           return sliderCell.knobOriginalImage
        }
    }
    
    /// 旋钮的文字
    @IBInspectable public var knobTitle: String? {
        set {
            sliderCell.knobTitle = newValue
        }
        get {
            return sliderCell.knobTitle
        }
    }
    
    /// 旋钮的的阴影偏移，default：CGSize(2.0, 2.0)，旋钮为图片时无效
    @IBInspectable public var knobShadowOffset: CGSize {
        set {
            sliderCell.knobShadowOffset = newValue
        }
        get {
            return sliderCell.knobShadowOffset
        }
    }
    
    /// 在旋钮上显示当前值: default is `false`，设置此值为`true`时，自定义的`knobTitle`属性将失效
    @IBInspectable public var showValueOnKnob: Bool {
        set {
            sliderCell.showValueOnKnob = newValue
        }
        get {
            return sliderCell.showValueOnKnob
        }
    }
    
    /// 旋钮文字的富文本属性,default: fontSize: 10
    public var titleAttributes: [NSAttributedString.Key : Any] {
        set {
            sliderCell.titleAttributes = newValue
        }
        get {
           return sliderCell.titleAttributes
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        resetCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        resetCell()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        resetCell()
    }
    
    private func resetCell() {
        cell = sliderCell
    }
    
}
