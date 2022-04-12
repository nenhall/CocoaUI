//
//  Button.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/1/19.
//

import Foundation
import Cocoa


public extension Button {
    
    enum State: Int, CaseIterable {
        case normal, hover, selected, pressed, disabled
    }
    
    enum ColorableContentType: Int, CaseIterable {
        case title, image, background, border, glow, innerShadow
    }
    
}

public class Button: NSButton, CALayerDelegate {
    
    // MARK: - 接口属性
    public var animationDuration: Double = 0.1
    /// Increase intrinsicContentSize
    public var extraIntrinsicSize: NSSize = .zero
    public var cursor: NSCursor?
    public var stateChangedHandler: ((State) -> Void)?
    
    /// CATextLayer animation may cost ~5% background CPU usage, default is `false`
    public var isTitleAnimatable = false
    public var isImageRenderedAsTemplate: Bool = true {
        didSet {
            guard isImageRenderedAsTemplate != oldValue else { return }
            //            setUpImage(skipRepeat: false)
            needsLayout = true
            if isImageRenderedAsTemplate {
                refreshColor(for: .image, animated: false)
            } else {
                imageLayer.backgroundColor = nil
            }
        }
    }
    
    /// 圆角
    public var cornerRadius: CGFloat = 0 {
        didSet {
            layer!.cornerRadius = cornerRadius
            if hasInnerShadow {
                innerShadowLayer.cornerRadius = cornerRadius
            }
        }
    }
    
    /// The spacing between title and image, default is 1/3 of the blank area.
    public var contentSpacing: CGFloat? {
        didSet {
            //            setUpImage()
            needsLayout = true
            //            relayoutContent()
        }
    }
    /// 边框宽度
    public var borderWidth: CGFloat = 0 {
        didSet {
            layer!.borderWidth = borderWidth
        }
    }
    
    /// 缩放圆角
    public var glowRadius: CGFloat = 0 {
        didSet {
            guard glowRadius != oldValue else { return }
            containerLayer.shadowRadius = glowRadius
            refreshColor(for: .glow)
        }
    }
    
    /// 缩放系数
    public var glowOpacity: Float = 0 {
        didSet {
            guard glowOpacity != oldValue else { return }
            containerLayer.shadowOpacity = glowOpacity
            refreshColor(for: .glow)
        }
    }
    
    /// 内置阴影圆角
    public var innerShadowRadius: CGFloat = 0 {
        didSet {
            guard innerShadowRadius != oldValue else { return }
            innerShadowLayer.shadowRadius = innerShadowRadius
            refreshColor(for: .innerShadow)
        }
    }
    
    /// 内置阴影透过度
    public var innerShadowOpacity: Float = 0 {
        didSet {
            guard innerShadowOpacity != oldValue else { return }
            innerShadowLayer.shadowOpacity = innerShadowOpacity
            refreshColor(for: .innerShadow)
        }
    }
    
    /// 内置阴影Weight度
    public var innerShadowWeight: CGFloat = 1 {
        didSet {
            guard innerShadowWeight != oldValue else { return }
            setUpInnerShadow()
        }
    }
    
    /// 图像
    public override var image: NSImage? {
        didSet {
            guard image != oldValue else { return }
            imageMap[.normal] = image
            if currentImage == image {
                //                setUpImage()
                needsLayout = true
                relayoutContent()
            }
        }
    }
    
    /// 文字
    public override var title: String {
        didSet {
            guard title != oldValue else { return }
            titleMap[.normal] = title
            if currentTitle == title {
                //                setUpTitle()
                //                relayoutContent()
                needsLayout = true
            }
        }
    }
    
    /// 字体
    public override var font: NSFont? {
        didSet {
            guard font != oldValue else { return }
            fontMap[.normal] = font
            if currentFont == font {
                //                setUpTitle()
                //                relayoutContent()
                needsLayout = true
            }
        }
    }
    
    ///位置
    public override var frame: NSRect {
        didSet {
            guard frame.size != oldValue.size else { return }
            containerLayer.frame = bounds
            setUpInnerShadow()
            setUpTransform()
            relayoutContent()
        }
    }
    
    /// 图标的位置
    public override var imagePosition: NSControl.ImagePosition {
        didSet {
            guard imagePosition != oldValue else { return }
            relayoutContent()
        }
    }
    
    /// 图像缩放
    public override var imageScaling: NSImageScaling {
        didSet {
            guard imageScaling != oldValue else { return }
            relayoutContent()
        }
    }
    
    public override var intrinsicContentSize: NSSize {
        return NSSize(width: super.intrinsicContentSize.width + extraIntrinsicSize.width + (contentSpacing ?? 0),
                      height: super.intrinsicContentSize.height + extraIntrinsicSize.height)
    }
    
    // MARK: - State Properties
    private var currentState: State = .normal {
        didSet {
            guard currentState != oldValue else { return }
            let shouldRelayout = currentTitle != previousTitle || currentImage != previousImage || currentFont != previousFont
            //            setUpTitle()
            //            setUpImage()
            if shouldRelayout {
                //                relayoutContent()
            }
            //            refreshColors()
            //            setUpTransform()
            //            shadow = getShadow(of: currentState)
            stateChangedHandler?(currentState)
            self.needsLayout = true
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            guard isEnabled != oldValue else { return }
            updateState()
        }
    }
    
    /// Mouse down
    private var isPressed = false {
        didSet {
            guard isPressed != oldValue else { return }
            updateState()
        }
    }
    
    public var isSelected: Bool = false {
        didSet {
            guard isSelected != oldValue else { return }
            updateState()
        }
    }
    
    public var enablePressed: Bool = true
    public var enableHover: Bool = true {
        didSet {
            if let oldTrackingArea = trackingArea {
                removeTrackingArea(oldTrackingArea)
            }
        }
    }
    
    /// Mouse entered
    public var isHover = false {
        didSet {
            guard isHover != oldValue else { return }
            updateState()
        }
    }
    
    public var isDrawUnderline = false {
        didSet {
            guard isDrawUnderline != oldValue else { return }
            updateState()
        }
    }
    
    open override var state: NSControl.StateValue {
        didSet {
            updateState()
        }
    }
    
    // MARK: - Private Properties
    private lazy var containerLayer: CALayer = {
        let layer = CALayer()
        layer.masksToBounds = false
        layer.shadowOffset = .zero
        layer.shadowRadius = glowRadius
        layer.shadowOpacity = glowOpacity
        layer.shadowColor = getCurrentColor(of: .glow)?.cgColor
        return layer
    }()
    
    private lazy var titleLayer: CATextLayer = {
        let layer = CATextLayer()
        layer.delegate = self
        layer.foregroundColor = getCurrentColor(of: .title)?.cgColor
        return layer
    }()
    
    private lazy var underlineLayer: CALayer = {
        let layer = CALayer()
        layer.delegate = self
        layer.backgroundColor = getCurrentColor(of: .title)?.cgColor
        return layer
    }()
    
    private lazy var imageLayer: CALayer = {
        let layer = CALayer()
        layer.delegate = self
        layer.masksToBounds = true
        layer.zPosition = 1
        layer.backgroundColor = getCurrentColor(of: .image)?.cgColor
        return layer
    }()
    
    private lazy var imageMaskLayer = CALayer()
    private lazy var innerShadowLayer: CALayer = {
        let layer = CALayer()
        layer.masksToBounds = true
        layer.shadowOffset = .zero
        layer.shadowRadius = innerShadowRadius
        layer.shadowOpacity = innerShadowOpacity
        layer.shadowColor = getCurrentColor(of: .innerShadow)?.cgColor
        setUpInnerShadow()
        self.layer?.addSublayer(layer)
        return layer
    }()
    
    private lazy var colorMap: [ColorableContentType: [State: NSColor?]] = {
        var map: [ColorableContentType: [State: NSColor?]] = [:]
        ColorableContentType.allCases.forEach { map[$0] = [State: NSColor?]() }
        return map
    }()
    
    private lazy var imageMap = [State: NSImage?]()
    private lazy var titleMap = [State: String?]()
    private lazy var fontMap = [State: NSFont?]()
    private lazy var shadowMap = [State: NSShadow?]()
    private lazy var scaleMap = [State: CGFloat]()
    private var trackingArea: NSTrackingArea?
    private var previousTitle: String?
    private var previousImage: NSImage?
    private var previousFont: NSFont?
    private var previousScale: CGFloat = 1
    
    private var currentImage: NSImage? {
        return getImage(of: currentState) ?? image
    }
    private var currentTitle: String {
        return getTitle(of: currentState) ?? title
    }
    private var currentFont: NSFont? {
        return getFont(of: currentState) ?? font
    }
    private var currentScale: CGFloat {
        return getScale(of: currentState) ?? 1
    }
    
    private var hasTitle: Bool {
        return imagePosition != .imageOnly && !currentTitle.isEmpty
    }
    private var hasImage: Bool {
        return imagePosition != .noImage && currentImage != nil
    }
    private var hasGlow: Bool {
        return glowRadius > 0 && glowOpacity > 0
    }
    private var hasInnerShadow: Bool {
        return innerShadowRadius > 0 && innerShadowOpacity > 0
    }
    
    // MARK: - Life Cycle
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    
    convenience init(target: AnyObject, action: Selector) {
        self.init(frame: .zero)
        self.target = target
        self.action = action
    }
    
    /// imagePosition == .noImage
    convenience init(title: String, target: AnyObject, action: Selector) {
        self.init(target: target, action: action)
        self.title = title
        imagePosition = .noImage
    }
    
    /// imagePosition == .imageOnly
    convenience init(image: NSImage?, target: AnyObject, action: Selector) {
        self.init(target: target, action: action)
        self.image = image
        imagePosition = .imageOnly
    }
    
    public func setUp() {
        focusRingType = .none
        wantsLayer = true
        layer!.delegate = self
        layer!.masksToBounds = false
        layer!.borderColor = getCurrentColor(of: .border)?.cgColor
        layer!.backgroundColor = getCurrentColor(of: .background)?.cgColor
        layer?.addSublayer(containerLayer)
        
        //        setUpTitle()
        //        setUpImage()
        needsLayout = true
    }
    
    public override func layout() {
        super.layout()
        
        setUpTitle()
        setUpImage(skipRepeat: false)
        refreshColors()
        setUpTransform()
        relayoutContent()
    }
    
    
}

// MARK: - Public Methods
public extension Button {
    
    var imageFrame: CGRect { return imageLayer.frame }
    
    var titleFrame: CGRect { return titleLayer.frame }
    
    // MARK: Color
    func resetColors() {
        ColorableContentType.allCases.forEach { type in
            colorMap[type]?.removeAll()
            refreshColor(for: type, animated: false)
        }
    }
    
    func getCurrentColor(of type: ColorableContentType) -> NSColor? {
        let color = getColor(type: type, state: currentState)
        if color == nil && currentState != .normal {
            //            color = getColor(type: type, state: .normal)
        }
        return color
    }
    
    func getColor(type: ColorableContentType, state: State) -> NSColor? {
        if self.state == .on {
            return colorMap[type]?[.pressed] ?? nil
        }
        guard let color = colorMap[type]?[state] else { return nil }
        return color
    }
    
    func setColor(_ color: NSColor?, to type: ColorableContentType, for state: State) {
        guard color != getColor(type: type, state: state) else { return }
        colorMap[type]?[state] = color
        if currentState == state {
            refreshColor(for: type)
        }
    }
    
    func setColor(_ color: NSColor?, to types: [ColorableContentType], for state: State) {
        types.forEach { setColor(color, to: $0, for: state) }
    }
    
    func setColor(_ color: NSColor?, to type: ColorableContentType, for status: [State]) {
        status.forEach { setColor(color, to: type, for: $0) }
    }
    
    func setColor(_ color: NSColor?, to types: [ColorableContentType], for status: [State]) {
        types.forEach { type in
            status.forEach { state in
                setColor(color, to: type, for: state)
            }
        }
    }
    
    // MARK: Title
    func getTitle(of state: State) -> String? {
        if self.state == .on {
            return titleMap[.pressed] ?? nil
        }
        guard let title = titleMap[state] else { return nil }
        return title
    }
    
    func setTitle(_ title: String?, for state: State) {
        if state == .normal {
            self.title = title ?? ""
            return
        }
        
        titleMap[state] = title
        if currentTitle == title {
            setUpTitle()
            relayoutContent()
        }
    }
    
    func setTitle(_ title: String?, for status: [State]) {
        status.forEach { setTitle(title, for: $0) }
    }
    
    // MARK: Image
    func getImage(of state: State) -> NSImage? {
        if self.state == .on {
            return imageMap[.pressed] ?? nil
        }
        guard let image = imageMap[state] else { return nil }
        return image
    }
    
    /// if you want to keep original color of image, make sure `isImageRenderedAsTemplate == false`
    func setImage(_ image: NSImage?, for state: State) {
        if state == .normal {
            self.image = image
            return
        }
        
        imageMap[state] = image
        if currentImage == image {
            //            setUpImage()
            needsLayout = true
            //            relayoutContent()
        }
    }
    
    /// if you want to keep original color of image, make sure `isImageRenderedAsTemplate == false`
    func setImage(_ image: NSImage?, for status: [State]) {
        status.forEach { setImage(image, for: $0) }
    }
    
    // MARK: Font
    func getFont(of state: State) -> NSFont? {
        guard let font = fontMap[state] else { return nil }
        return font
    }
    
    func setFont(_ font: NSFont?, for state: State) {
        if state == .normal {
            self.font = font
            return
        }
        
        fontMap[state] = font
        if currentFont == font {
            //            setUpTitle()
            //            relayoutContent()
            needsLayout = true
        }
    }
    
    func setFont(_ font: NSFont?, for status: [State]) {
        status.forEach { setFont(font, for: $0) }
    }
    
    // MARK: Scale
    func setScale(_ scale: CGFloat, for state: State) {
        scaleMap[state] = scale
        if currentScale == scale {
            setUpTransform()
        }
    }
    
    func setScale(_ scale: CGFloat, for status: [State]) {
        status.forEach { setScale(scale, for: $0) }
    }
    
    func getScale(of state: State) -> CGFloat? {
        return scaleMap[state]
    }
    
    // MARK: Shadow
    func setShadow(_ shadow: NSShadow?, for state: State) {
        shadowMap[state] = shadow
        if state == currentState {
            self.shadow = shadow
        }
    }
    
    func setShadow(_ shadow: NSShadow?, for status: [State]) {
        status.forEach { setShadow(shadow, for: $0) }
    }
    
    func getShadow(of state: State) -> NSShadow? {
        guard let shadow = shadowMap[state] else { return nil }
        return shadow
    }
    
}

// MARK: - Interaction
public extension Button {
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        if enableHover {
            setUpTrackingArea()
        }
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        return isEnabled ? super.hitTest(point) : nil
    }
    
    override func mouseDown(with event: NSEvent) {
        let locationPoint = convert(event.locationInWindow, from: nil)
        guard isEnabled && bounds.contains(locationPoint) else { return }
        if enablePressed {
            isPressed = true
        }
        super.mouseDown(with: event)
        if enablePressed {
            isPressed = false
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        isHover = true
    }
    
    override func mouseExited(with event: NSEvent) {
        isHover = false
    }
    
    override func resetCursorRects() {
        if let cursor = self.cursor {
            addCursorRect(bounds, cursor: cursor)
        } else {
            super.resetCursorRects()
        }
    }
    
}

// MARK: - Drawing
public extension Button {
    
    override func draw(_ dirtyRect: NSRect) {}
    
    func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool {
        return layer != imageLayer
    }
    
    override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        
        guard let scale = window?.backingScaleFactor else { return }
        layer!.contentsScale = scale
        imageLayer.contentsScale = scale
        imageMaskLayer.contentsScale = scale
        underlineLayer.contentsScale = scale
        titleLayer.contentsScale = max(ceil(scale), 2)  // never less than 1, always integer
    }
    
}

// MARK: - Private Methods
private extension Button {
    
    func setUpTrackingArea() {
        if let oldTrackingArea = trackingArea {
            removeTrackingArea(oldTrackingArea)
        }
        
        trackingArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeInActiveApp, .inVisibleRect, .activeInKeyWindow], owner: self, userInfo: nil)
        addTrackingArea(trackingArea!)
    }
    
    func setUpTitle() {
        let title = currentTitle
        titleLayer.string = title
        
        let font = currentFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        guard (!title.isEmpty && title != previousTitle) || font != previousFont else { return }
        titleLayer.font = font
        titleLayer.fontSize = font.pointSize
        previousTitle = title
        previousFont = font
        drawUnderline()
    }
    
    func setUpImage(skipRepeat: Bool = true) {
        if isImageRenderedAsTemplate {
            //            imageMaskLayer.contents = currentImage
            //            imageLayer.mask = imageMaskLayer
            imageLayer.contents = currentImage?.cgImage
            //            imageLayer.backgroundColor = nil
        } else {
            //            imageLayer.mask = nil
            imageLayer.contents = currentImage?.cgImage
        }
        
        previousImage = image
    }
    
    func setUpImageSize() {
        guard hasImage else { return }
        var size = currentImage!.size
        switch imageScaling {
        case .scaleAxesIndependently:      size = bounds.size
        case .scaleProportionallyDown:     size = size.scaleAspectFit(bounds.size)
        case .scaleProportionallyUpOrDown: size = size.scaleAspectUpOrDownFit(bounds.size)
        case .scaleNone:                   break
        @unknown default:                  break
        }
        imageLayer.frame = NSRect(origin: .zero, size: size)
        imageMaskLayer.frame = imageLayer.bounds
    }
    
    func relayoutContent() {
        guard bounds.isEmpty else { return }
        
        let (hasImage, hasTitle, isDraw) = (self.hasImage, self.hasTitle, self.isDrawUnderline)
        hasImage ? containerLayer.addSublayer(imageLayer) : imageLayer.removeFromSuperlayer()
        hasTitle ? containerLayer.addSublayer(titleLayer) : titleLayer.removeFromSuperlayer()
        isDraw   ? containerLayer.addSublayer(underlineLayer) : underlineLayer.removeFromSuperlayer()
        guard hasImage || hasTitle else { return }
        
        setUpImageSize()
        let font = currentFont ?? NSFont.systemFont(ofSize: NSFont.systemFontSize)
        var titleMax = title.size(withAttributes: [.font: font])
        titleMax = NSMakeSize(min(titleMax.width, NSWidth(self.frame)), min(titleMax.height, NSHeight(self.frame)))
        titleLayer.frame = NSRect(origin: .zero, size: titleMax)
        
        let titleSize = hasTitle ? titleMax : .zero
        let imageSize = hasImage ? imageLayer.frame.size : .zero
        
        let imagePosition = !hasTitle ? .imageOnly : (!hasImage ? .noImage : self.imagePosition)
        switch imagePosition {
        case .noImage:
            titleLayer.frame.origin = NSPoint(x: (bounds.width - titleSize.width) / 2, y: (bounds.height - titleSize.height) / 2)
            
        case .imageOnly:
            imageLayer.frame.origin = NSPoint(x: (bounds.width - imageSize.width) / 2, y: (bounds.height - imageSize.height) / 2)
            
        case .imageOverlaps:
            titleLayer.frame.origin = NSPoint(x: (bounds.width - titleSize.width) / 2, y: (bounds.height - titleSize.height) / 2)
            imageLayer.frame.origin = NSPoint(x: (bounds.width - imageSize.width) / 2, y: (bounds.height - imageSize.height) / 2)
            
        case .imageAbove:
            let spacing = bounds.height - imageSize.height - titleSize.height
            let topSpacing = contentSpacing == nil ? (spacing / (spacing > 0 ? 3 : 2)) : (spacing - contentSpacing!) / 2
            imageLayer.frame.origin = NSPoint(x: (bounds.width - imageSize.width) / 2, y: topSpacing)
            titleLayer.frame.origin = NSPoint(x: (bounds.width - titleSize.width) / 2, y: bounds.height - titleSize.height - topSpacing)
            
        case .imageBelow:
            let spacing = bounds.height - imageSize.height - titleSize.height
            let topSpacing = contentSpacing == nil ? (spacing / (spacing > 0 ? 3 : 2)) : (spacing - contentSpacing!) / 2
            titleLayer.frame.origin = NSPoint(x: (bounds.width - titleSize.width) / 2, y: topSpacing)
            imageLayer.frame.origin = NSPoint(x: (bounds.width - imageSize.width) / 2, y: bounds.height - imageSize.height - topSpacing)
            
        case .imageLeft, .imageLeading:
            if characterDirection == .rightToLeft {
                let spacing = bounds.width - imageSize.width - titleSize.width
                let leftSpacing = contentSpacing == nil ? (spacing / (spacing > 0 ? 3 : 2)) : (spacing - contentSpacing!) / 2
                titleLayer.frame.origin = NSPoint(x: leftSpacing, y: (bounds.height - titleSize.height) / 2)
                imageLayer.frame.origin = NSPoint(x: bounds.width - imageSize.width - leftSpacing, y: (bounds.height - imageSize.height) / 2)
            }else{
                let spacing = bounds.width - imageSize.width - titleSize.width
                let leftSpacing = contentSpacing == nil ? (spacing / (spacing > 0 ? 3 : 2)) : (spacing - contentSpacing!) / 2
                imageLayer.frame.origin = NSPoint(x: leftSpacing, y: (bounds.height - imageSize.height) / 2)
                titleLayer.frame.origin = NSPoint(x: bounds.width - titleSize.width - leftSpacing, y: (bounds.height - titleSize.height) / 2)
            }
            
        case .imageRight, .imageTrailing:
            if characterDirection == .rightToLeft {
                let spacing = bounds.width - imageSize.width - titleSize.width
                let leftSpacing = contentSpacing == nil ? (spacing / (spacing > 0 ? 3 : 2)) : (spacing - contentSpacing!) / 2
                imageLayer.frame.origin = NSPoint(x: leftSpacing, y: (bounds.height - imageSize.height) / 2)
                titleLayer.frame.origin = NSPoint(x: bounds.width - titleSize.width - leftSpacing, y: (bounds.height - titleSize.height) / 2)
            }else{
                let spacing = bounds.width - imageSize.width - titleSize.width
                let leftSpacing = contentSpacing == nil ? (spacing / (spacing > 0 ? 3 : 2)) : (spacing - contentSpacing!) / 2
                titleLayer.frame.origin = NSPoint(x: leftSpacing, y: (bounds.height - titleSize.height) / 2)
                imageLayer.frame.origin = NSPoint(x: bounds.width - imageSize.width - leftSpacing, y: (bounds.height - imageSize.height) / 2)
            }
        @unknown default:
            break
        }
        
        drawUnderline()
    }
    
    func setUpTransform() {
        let scale = currentScale
        guard scale != previousScale && scale > 0 else { return }
        previousScale = scale
        containerLayer.transform = CATransform3DMakeScale(scale, scale, 1)
        titleLayer.contentsScale = max(ceil(layer!.contentsScale * scale), 2)
    }
    
    func setUpInnerShadow() {
        guard hasInnerShadow && innerShadowLayer.frame != bounds else { return }
        innerShadowLayer.cornerRadius = cornerRadius
        innerShadowLayer.frame = bounds
        innerShadowLayer.shadowPath = {
            let path = CGMutablePath()
            path.move(to: .zero)
            path.addLine(to: NSPoint(x: 0, y: bounds.maxY))
            path.addLine(to: NSPoint(x: bounds.maxX, y: bounds.maxY))
            path.addLine(to: NSPoint(x: bounds.maxX, y: 0))
            path.closeSubpath()
            path.addRect(bounds.insetBy(dx: -innerShadowWeight, dy: -innerShadowWeight))
            return path
        }()
    }
    
    func refreshColor(for type: ColorableContentType, animated: Bool = true) {
        guard let color = getCurrentColor(of: type) else { return }
        switch type {
        case .title:
            if isTitleAnimatable && animated {
                titleLayer.removeAllAnimations()
                titleLayer.animate(color: color, keyPath: #keyPath(CATextLayer.foregroundColor), duration: animationDuration)
            } else {
                titleLayer.foregroundColor = color.cgColor
                underlineLayer.backgroundColor = color.cgColor
            }
            
        case .image:
            guard isImageRenderedAsTemplate else { return }
            if animated {
                imageLayer.removeAllAnimations()
                imageLayer.animate(color: color, keyPath: #keyPath(CALayer.backgroundColor), duration: animationDuration)
            } else {
                imageLayer.backgroundColor = color.cgColor
            }
            
        case .background:
            if animated {
                layer!.removeAllAnimations()
                layer!.animate(color: color, keyPath: #keyPath(CALayer.backgroundColor), duration: animationDuration)
            } else {
                layer!.backgroundColor = color.cgColor
            }
            
        case .border:
            if animated {
                layer!.removeAllAnimations()
                layer!.animate(color: color, keyPath: #keyPath(CALayer.borderColor), duration: animationDuration)
            } else {
                layer!.borderColor = color.cgColor
            }
            
        case .glow:
            guard hasGlow else { break }
            if animated {
                containerLayer.removeAllAnimations()
                containerLayer.animate(color: color, keyPath: #keyPath(CALayer.shadowColor), duration: animationDuration)
            } else {
                containerLayer.shadowColor = color.cgColor
            }
            
        case .innerShadow:
            guard hasInnerShadow else { break }
            if animated {
                innerShadowLayer.removeAllAnimations()
                innerShadowLayer.animate(color: color, keyPath: #keyPath(CALayer.shadowColor), duration: animationDuration)
            } else {
                innerShadowLayer.shadowColor = color.cgColor
            }
        }
    }
    
    func refreshColors() {
        layer!.removeAllAnimations()
        layer!.sublayers?.forEach { $0.removeAllAnimations() }
        
        if let backgroundColor = getCurrentColor(of: .background) {
            layer!.animate(color: backgroundColor, keyPath: #keyPath(CALayer.backgroundColor), duration: animationDuration)
        }
        
        if let borderColor = getCurrentColor(of: .border) {
            layer!.animate(color: borderColor, keyPath: #keyPath(CALayer.borderColor), duration: animationDuration)
        }
        
        if let titleColor = getCurrentColor(of: .title) {
            if isTitleAnimatable {
                titleLayer.animate(color: titleColor, keyPath: #keyPath(CATextLayer.foregroundColor), duration: animationDuration)
            } else {
                titleLayer.foregroundColor = titleColor.cgColor
                underlineLayer.backgroundColor = titleColor.cgColor
            }
        }
        
        if isImageRenderedAsTemplate {
            /// 这段代码会导致有图片时，改变了 imageLayer 的背景
            //            let imageColor = getCurrentColor(of: .image)
            //            let imageColor = getColor(type: .background, state: .normal)
            //            imageLayer.animate(color: imageColor, keyPath: #keyPath(CALayer.backgroundColor), duration: animationDuration)
        }
        
        if hasGlow {
            if let glowColor = getCurrentColor(of: .glow) {
                containerLayer.animate(color: glowColor, keyPath: #keyPath(CALayer.shadowColor), duration: animationDuration)
            }
        }
        
        if hasInnerShadow {
            if let innerShadowColor = getCurrentColor(of: .innerShadow) {
                innerShadowLayer.animate(color: innerShadowColor, keyPath: #keyPath(CALayer.shadowColor), duration: animationDuration)
            }
        }
    }
    
    func updateState() {
        if !isEnabled {
            currentState = .disabled
        } else if isPressed {
            currentState = .pressed
        } else if isSelected {
            currentState = .selected
        } else if isHover {
            currentState = .hover
        } else {
            currentState = .normal
        }
    }
    
    private func drawUnderline() {
        let titleFrame = NSInsetRect(titleLayer.frame, -1, 0)
        if self.hasTitle {
            underlineLayer.frame = NSMakeRect(titleFrame.origin.x, titleFrame.origin.y + NSHeight(titleFrame) + 2, NSWidth(titleFrame), 1)
        }else{
            underlineLayer.frame = NSZeroRect
        }
    }
}

private extension Button.ColorableContentType {
    
    var defaultColor: NSColor {
        switch self {
        case .title, .image, .border:
            return .gray
        case .background, .glow, .innerShadow:
            return .clear
        }
    }
    
}

private extension CALayer {
    
    func animate(color: NSColor, keyPath: String, duration: Double) {
        let cgColor = value(forKey: keyPath) as! CGColor?
        guard cgColor != color.cgColor else { return }
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.toValue = color.cgColor
        animation.fromValue = value(forKey: keyPath)
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        add(animation, forKey: keyPath)
        setValue(color.cgColor, forKey: keyPath)
    }
    
}
