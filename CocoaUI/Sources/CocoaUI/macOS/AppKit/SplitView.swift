//
//  CoSplitView.swift
//  CocoaUIKit
//
//  Created by nenhall on 2021/10/15.
//

import AppKit

public class SplitView: NSSplitView {

    lazy public private(set) var expandButton: NSButton = {
        let button = NSButton()
        button.image = NSImage(named: NSImage.Name(""))
        button.alternateImage = NSImage(named: NSImage.Name(""))
        addSubview(button)
        return button
    }()

    @IBInspectable public var customDividerColor: NSColor? = .controlBackgroundColor {
        didSet { needsDisplay = true }
    }
    
    @IBInspectable public var hiddenExpandButton: Bool = false {
        didSet { expandButton.isHidden = hiddenExpandButton }
    }
    
    /// 是否允许拖拽，默认 `true`
    @IBInspectable public var enableDrag: Bool = true
    /// 是否允许自动折叠或展开，默认 `true`
    @IBInspectable public var autoCollapseOrExpand: Bool = true
    /// 点击展开或者收起，默认 `true`
    @IBInspectable public var clickCollapseOrExpand: Bool = true
    
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
        if clickCollapseOrExpand == false {
            return
        }
        guard let firstView = arrangedSubviews.first else {
            return
        }
        
        if isSubviewCollapsed(firstView) {
            setPosition(minPositionOfDivider, ofDividerAt: 0)
            expandButton.image = NSImage(named: NSImage.Name(""))
            expandButton.alternateImage = NSImage(named: NSImage.Name(""))
        } else {
            setPosition(0, ofDividerAt: 0)
            expandButton.image = NSImage(named: NSImage.Name(""))
            expandButton.alternateImage = NSImage(named: NSImage.Name(""))
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
    }
    
    public override func drawDivider(in rect: NSRect) {

        drawSplitLine(in: rect)
        
        if let customDividerColor = customDividerColor {
            customDividerColor.set()
            NSBezierPath.fill(rect)
        }
        
        if enableDrag == false {
            super.drawDivider(in: rect)
            return
        }
        
        guard let firstView = arrangedSubviews.first else {
            super.drawDivider(in: rect)
            return
        }
        
        if isSubviewCollapsed(firstView) {
//            expandButton.image = NSImage.init(named: NSImage.Name("downpull_n"))
//            expandButton.alternateImage = NSImage.init(named: NSImage.Name("downpull_n"))
            expandButton.toolTip = ""
        } else {
//            expandButton.image = NSImage.init(named: NSImage.Name("downpull_n"))
//            expandButton.alternateImage = NSImage.init(named: NSImage.Name("downpull_n"))
            expandButton.toolTip = ""
        }
        
        if isVertical {
            let widthHeight = rect.size.width - 2
            let x = (rect.width - widthHeight) * 0.5
            let y = (rect.height * 0.5) - (rect.size.width * 0.5)
            expandButton.frame = NSRect(x: rect.origin.x + x, y: y, width: widthHeight, height: widthHeight)
        } else {
            let widthHeight = rect.size.height - 2
            let x = (rect.width * 0.5) - (rect.size.height * 0.5)
            let y = (rect.height - widthHeight) * 0.5
            expandButton.frame = NSRect(x: x, y: rect.origin.y + y, width: widthHeight, height: widthHeight)
        }
    }
    
}
