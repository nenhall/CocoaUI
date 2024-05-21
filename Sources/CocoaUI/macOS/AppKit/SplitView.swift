//
//  CoSplitView.swift
//  CocoaUIKit
//
//  Created by nenhall on 2021/10/15.
//

#if os(macOS)
import AppKit

public class SplitView: NSSplitView {

    lazy public private(set) var expandButton: NSButton = {
        let button = NSButton()
        button.title = ""
        button.setButtonType(.toggle)
        button.state = .on
        addSubview(button)
        return button
    }()

    @IBInspectable public var customDividerColor: NSColor? = .controlBackgroundColor {
        didSet { needsDisplay = true }
    }
    @IBInspectable public var handleColor: NSColor? = .controlBackgroundColor {
        didSet { needsDisplay = true }
    }
    @IBInspectable public var hiddenExpandButton: Bool = false {
        didSet { expandButton.isHidden = hiddenExpandButton }
    }
    /// 是否允许拖拽，默认 `true`
    @IBInspectable public var enableDrag: Bool = true
    /// 是否允许自动折叠或展开，默认 `true`
    @IBInspectable public var autoCollapseOrExpand: Bool = true
    /// 收起时的图片
    @IBInspectable public var clickCollapseOrExpand: Bool = true
    @IBInspectable public var collapseImage: NSImage? {
        didSet {
            expandButton.image = collapseImage
        }
    }
    /// 展开图片
    @IBInspectable public var expandImage: NSImage? {
        didSet {
            expandButton.alternateImage = expandImage
        }
    }
    
    /// 拖拽条最小的位置（宽），建议保持与`SplitView` Subview的最小宽一致
    /// - Note: eg. 点击需要左边的view，则设置此属性为左边的view的最小宽
    @IBInspectable public var minPositionOfDivider: CGFloat = 0.0

    public private(set) var draging: Bool = false
    
    lazy private(set) var leftLine: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.isHidden = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        addSubview(view)
        return view
    }()

    lazy private(set) var rightLine: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.isHidden = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        addSubview(view)
        return view
    }()
    
    public override var dividerColor: NSColor {
        if let customDividerColor = customDividerColor {
            return customDividerColor
        }
        return super.dividerColor
    }
        
    public override func awakeFromNib() {
        super.awakeFromNib()
        expandButton.isBordered = false
        addSubview(expandButton)
    }
    
    public override func layout() {
        super.layout()
        setNeedsDisplay(self.bounds)
    }
    
    private func didClickButton() {
        guard clickCollapseOrExpand == true else { return }
        
        if expandButton.state == .off {
            setPosition(minPositionOfDivider, ofDividerAt: 0)
        } else {
            setPosition(0, ofDividerAt: 0)
        }
    }
    
    public override func mouseDragged(with event: NSEvent) {
        if enableDrag == false {
            draging = true
        }
        super.mouseDragged(with: event)
    }
    
    public override func mouseUp(with event: NSEvent) {
        draging = false
        super.mouseUp(with: event)
    }
        
    public override func mouseDown(with event: NSEvent) {
        if enableDrag == false {
            return
        }
        let clickPoint = event.locationInWindow
        let convertPoint = convert(clickPoint, from: nil)
        var responeRect = NSInsetRect(expandButton.frame, -3, 0)
        if isVertical {
            responeRect = NSInsetRect(expandButton.frame, 0, -3)
        }
        if NSPointInRect(convertPoint, responeRect) {
            didClickButton()
        } else {
        }
        super.mouseDown(with: event)

    }
    
    private func drawSplitLine(in rect: NSRect) {
        let hLinePoint = NSPoint(x: rect.origin.x + rect.size.width, y: rect.origin.y)
        let vLinePoint = NSPoint(x: rect.origin.x, y: rect.origin.y + rect.size.height)

        leftLine.frame = NSRect(origin: rect.origin, size: CGSize(width: 1, height: rect.size.height))
        rightLine.frame = NSRect(origin: hLinePoint, size: CGSize(width: 1, height: rect.size.height))
        
        if isVertical == false {
            leftLine.frame = NSRect(origin: rect.origin, size: CGSize(width: rect.size.width, height: 1))
            rightLine.frame = NSRect(origin: vLinePoint, size: CGSize(width: rect.size.width, height: 1))
        }
        if let firstView = arrangedSubviews.first {
            expandButton.state = firstView.frame.width == 0 ? .off : .on
        }
    }
    
    public override func drawDivider(in rect: NSRect) {
        
        drawSplitLine(in: rect)
        
        if let customDividerColor = customDividerColor {
            customDividerColor.set()
            NSBezierPath.fill(rect)
        }
        
        let pointFrame: NSRect
        if isVertical {
            let widthHeight = rect.size.width - 2
            let x = (rect.width - widthHeight) * 0.5
            let y = (rect.height * 0.5) - (rect.size.width * 0.5)
            pointFrame = NSRect(x: rect.origin.x + x, y: y, width: widthHeight, height: widthHeight)
        } else {
            let widthHeight = rect.size.height - 2
            let x = (rect.width * 0.5) - (rect.size.height * 0.5)
            let y = (rect.height - widthHeight) * 0.5
            pointFrame = NSRect(x: x, y: rect.origin.y + y, width: widthHeight, height: widthHeight)
        }
        
        if let handleColor = handleColor {
            let path = NSBezierPath(roundedRect: pointFrame, xRadius: pointFrame.width * 0.5, yRadius: pointFrame.height * 0.5)
            handleColor.setFill()
            path.fill()
        }
                
        if enableDrag == false {
            super.drawDivider(in: rect)
            return
        }
        
        guard arrangedSubviews.first != nil else {
            super.drawDivider(in: rect)
            return
        }
        expandButton.frame = pointFrame
    }
    
}
#endif
