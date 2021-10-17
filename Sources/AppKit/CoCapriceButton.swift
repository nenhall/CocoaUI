//
//  CoCapriceButton.swift
//  CocoaUIKit
//
//  Created by nenhall on 2021/10/15.
//

import Cocoa


/// 这个是一个多状态自动切换按钮：Highlight、Disable、Selected、Normal，支持图片或者颜色作为背景
/// 需要配合 CoCapriceButtonCell使用
public class CoCapriceButton: NSButton {

    /// `Highlight`背景填充图
    @IBInspectable public var highlightImage: NSImage? {
        didSet {
            buttonCell?.highlightImage = highlightImage
            needsDisplay = true
        }
    }
    
    /// `Disable`背景填充图
    @IBInspectable public var disableImage: NSImage? {
        didSet {
            buttonCell?.disableImage = disableImage
            needsDisplay = true
        }
    }
    
    /// `Highlight` 按钮背景填充色
    @IBInspectable public var highlightColor: NSColor? {
        didSet {
            buttonCell?.highlightColor = highlightColor
            needsDisplay = true
        }
    }
    
    /// `Disable`背景填充图
    @IBInspectable public var disableColor: NSColor? {
        didSet {
            buttonCell?.disableImage = disableImage
            needsDisplay = true
        }
    }
    
    /// `Normal`按钮文字颜色
    @IBInspectable public var titleColor: NSColor? = NSColor(calibratedRed: 1.00, green: 1.00, blue: 1.00, alpha: 1.0) {
        didSet {
            buttonCell?.titleColor = titleColor
            needsDisplay = true
        }
    }
    
    /// `Highlight`按钮文字颜色
    @IBInspectable public var titleHighlightColor: NSColor? {
        didSet {
            buttonCell?.titleHighlightColor = titleHighlightColor
            needsDisplay = true
        }
    }
    
    /// `Disable`按钮文字颜色
    @IBInspectable public var titleDisableColor: NSColor? {
        didSet {
            buttonCell?.titleDisableColor = titleDisableColor
            needsDisplay = true
        }
    }
    
    /// 是否选中
    @IBInspectable public var isSelected: Bool {
        get { return buttonCell?.isSelected ?? false }
        set {
            buttonCell?.isSelected = newValue
            needsDisplay = true
        }
    }
    
    /// 是否高亮
    public override var isHighlighted: Bool {
        set {
            super.isHighlighted = newValue
            buttonCell?.isHighlighted = newValue
            needsDisplay = true
        }
        get { return buttonCell?.isHighlighted ?? false }
    }
    
    private var isMouseDown: Bool {
        set {
            buttonCell?.isMouseDown = newValue
            needsDisplay = true
        }
        get { return buttonCell?.isMouseDown ?? false }
    }
    
    public var defautlValue: Any?
    public var tagString: String?
    
    /// 开启/禁止`Highlight`状态自动变化
    @IBInspectable public var enableHighlight: Bool = true {
        didSet {
            if enableHighlight {
                addTrackingAreaObserver()
            } else {
                if let area = trackingArea {
                    removeTrackingArea(area)
                }
            }
        }
    }

    private var trackingArea: NSTrackingArea?
    
    /// 重写自定义的Cell，替换了原此的Cell，等价`.Cell`
    public var buttonCell: CoCapriceButtonCell? {
        return cell as? CoCapriceButtonCell
    }

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        cell = CoCapriceButtonCell()
        configCell()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }

    //MARK:- 私有方法
    private func configCell() {
        bezelStyle = .regularSquare
        isBordered = false
        setButtonType(.momentaryChange)
        addTrackingAreaObserver()
    }
    
    private func addTrackingAreaObserver() {
        if let area = trackingArea {
            removeTrackingArea(area)
        }
        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect, .activeInKeyWindow]
        trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        if let trackingArea = trackingArea {
            addTrackingArea(trackingArea)
        }
    }
    
    //MARK: Mouse Event
    public override func mouseEntered(with theEvent: NSEvent) {
        buttonCell?.isHighlighted = true
        super.mouseEntered(with: theEvent)
    }
    
    public override func mouseExited(with theEvent: NSEvent) {
        buttonCell?.isHighlighted = false
        super.mouseExited(with: theEvent)
    }
    
    public override func mouseDown(with event: NSEvent) {
        buttonCell?.isMouseDown = true
        super.mouseDown(with: event)
    }
    
    public override func mouseUp(with event: NSEvent) {
        buttonCell?.isMouseDown = false
        super.mouseUp(with: event)
    }
    
}


public class CoCapriceButtonCell: NSButtonCell {
    @IBInspectable public var highlightImage: NSImage?
    @IBInspectable public var disableImage: NSImage?
    @IBInspectable public var highlightColor: NSColor?
    @IBInspectable public var disableColor: NSColor?
    @IBInspectable public var titleColor: NSColor?
    @IBInspectable public var titleHighlightColor: NSColor?
    @IBInspectable public var titleDisableColor: NSColor?
    public var isMouseDown = false {
        didSet { controlView?.needsDisplay = true }
    }
    public var isSelected = false {
        didSet {
            isMouseDown = false
            controlView?.needsDisplay = true
        }
    }
    public override var isEnabled: Bool {
        didSet {
            isMouseDown = false
            controlView?.needsDisplay = true
        }
    }
    public override var isHighlighted: Bool {
        didSet {
            isMouseDown = false
            controlView?.needsDisplay = true
        }
    }
    
    public override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        if isSelected == false {
            checkCurrentEventStatus(in: controlView)
        }
        var imageIsExist = false
        if isEnabled == false {
            imageIsExist = drawDisableImage(frame: cellFrame, controlView: controlView)
        } else if isSelected || isMouseDown {
            imageIsExist = drawSelectableImage(frame: cellFrame, controlView: controlView)
        } else if isHighlighted {
            imageIsExist = drawHiglightImage(frame: cellFrame, controlView: controlView)
        }
        if imageIsExist == false {
            super.draw(withFrame: cellFrame, in: controlView)
        }
    }
    
    private func checkCurrentEventStatus(in controlView: NSView) {
        if let currentEvent = controlView.window?.currentEvent {
            if currentEvent.type == .mouseEntered {
                isMouseDown = false
                isHighlighted = true
            } else if currentEvent.type == .mouseExited {
                isHighlighted = false
                isMouseDown = false
            } else if currentEvent.type == .leftMouseUp {
//                let loc = currentEvent.locationInWindow
//                let convertLoc = controlView.convert(loc, from: nil)
//                let inRect = NSPointInRect(convertLoc, controlView.frame)
//                isHighlighted = inRect
            } else if currentEvent.type == .leftMouseDown {
//                isHighlighted = false
            } else {
                isHighlighted = false
            }
        }
    }
    
    private func drawHiglightImage(frame: NSRect, controlView: NSView) -> Bool {
        if let hImage = highlightImage {
            hImage.draw(in: NSRect(x: (frame.size.width - hImage.size.width) / 2, y: frame.size.height - hImage.size.height , width: hImage.size.width, height: hImage.size.height))
            return true
        }
        return false
    }
    
    private func drawSelectableImage(frame: NSRect, controlView: NSView) -> Bool {
        if let aImage = alternateImage {
            aImage.draw(in: NSRect(x: (frame.size.width - aImage.size.width) / 2, y: frame.size.height - aImage.size.height , width: aImage.size.width, height: aImage.size.height))
            return true
        }
        return false
    }
    
    private func drawDisableImage(frame: NSRect, controlView: NSView) -> Bool {
        if let dImage = disableImage {
            dImage.draw(in: NSRect(x: (frame.size.width - dImage.size.width) / 2, y: frame.size.height - dImage.size.height , width: dImage.size.width, height: dImage.size.height))
            return true
        }
        return false
    }
    
    private func drawNormalImage(frame: NSRect, controlView: NSView) -> Bool {
        if let image = image {
            image.draw(in: NSRect(x: (frame.size.width - image.size.width) / 2, y: frame.size.height - image.size.height , width: image.size.width, height: image.size.height))
            return true
        }
        return false
    }
    
}
