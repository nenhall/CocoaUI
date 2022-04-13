//
//  CoWindow.swift
//  CocoaUIKit
//
//  Created by nenhall on 2021/10/09.
//

import AppKit

open class WindowController: NSWindowController {
    
    @IBInspectable public var visualEffectWidth: CGFloat = 0
    @IBInspectable public var visualEffectMode: Int = -1
    @IBInspectable public var titlebarColor: NSColor = .clear
    open var ownerWindow: Window? {
        return window as? Window
    }
    open override func windowDidLoad() {
        super.windowDidLoad()
        
        updateSetting()
    }
    
    private func updateSetting() {
        
        Notify.addObserver(self, selector: #selector(windowWillCloseNotification(_:)), name: NSWindow.willCloseNotification, object: window)
        
        if let coWindow = window as? Window {
            coWindow.visualEffectWidth = visualEffectWidth
            coWindow.visualEffectMode = visualEffectMode
            if titlebarColor != .clear {
                coWindow.titlebarColor = titlebarColor
            }
        }
    }
    
    /// 窗口将要关闭：如果当前窗口是模态弹出，执行此方法时会自动`stopModal()`
    /// - Parameter note: Notification description
    @objc open func windowWillCloseNotification(_ note: Notification) {
        if NSApplication.shared.modalWindow == window {
            NSApp.stopModal()
        }
    }
}

open class Window: NSWindow {
    
    /// 高斯模糊填充模式
    public enum VisualEffectMode {
        case fill /// 完全填充
        case leading(_ width: CGFloat) ///左对齐计算宽度
        case treading(_ width: CGFloat) ///右对齐计算宽度
    }
    private let itemViewerKey = "_itemViewer"
    private var _titleBarView: NSView?
    /// 系统的 NSTitleBarView
    public var titleBarView: NSView? {
        if _titleBarView != nil {
            return _titleBarView
        }
        var titleView = standardWindowButton(.closeButton)?.superview
        if titleView == nil {
            titleView = standardWindowButton(.miniaturizeButton)?.superview
        }
        if titleView == nil {
            titleView = standardWindowButton(.zoomButton)?.superview
        }
        if titleView == nil {
            if let subviews = contentView?.superview?.subviews {
                for item in subviews {
                    if item.className == "NSTitlebarContainerView" {
                        for item2 in item.subviews {
                            if item2.className == "NSTitlebarView" {
                                _titleBarView = item2
                                return item2
                            }
                        }
                    }
                }
            }
        }
        _titleBarView = titleView
        return titleView
    }
    
    private var toolbarViewLeading: NSLayoutConstraint?
    /// 工具栏，可以添加子控件
    public let toolbarView = NSView()
    private var sysToolbarView: NSView? {
        guard let titleBarView = titleBarView else { return self.titleBarView }
        for item in titleBarView.subviews {
            if item.className == "NSToolbarView" {
                return item
            }
        }
        return titleBarView
    }
    
    /// window 的标题栏，原始的标题栏被隐藏了
    public let titleField = NSTextField()
    private var _sysTitleField: NSTextField?
    public var sysTitleField: NSTextField? {
        if _sysTitleField != nil { return _sysTitleField }
        guard let titleBarView = titleBarView else { return nil }
        for item in titleBarView.subviews {
            if let titleField = item as? NSTextField {
                _sysTitleField = titleField
                return item as? NSTextField
            }
        }
        return nil
    }
        
    /// titlebar 背景层，可以在这上面设置颜色/颜色层，不可以添加控件！
    public lazy private(set) var backgroundView: TitlebarBackgroundView = {
        let bgView = TitlebarBackgroundView()
        bgView.fillColor = backgroundColor
        bgView.autoresizingMask = [.height, .width]
        return bgView
    }()
    
    public lazy private(set) var effectView: NSVisualEffectView = {
        let eView = NSVisualEffectView()
        eView.blendingMode = .behindWindow
        eView.material = .titlebar
        eView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        eView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        eView.translatesAutoresizingMaskIntoConstraints = false
        return eView
    }()

    private weak var spaceItem: NSToolbarItem?
    private var effectWidthConstraint: NSLayoutConstraint?
    private var effectLeadingConstraint: NSLayoutConstraint?

    fileprivate var visualEffectWidth: CGFloat = 0
    fileprivate var visualEffectMode: Int = 0 {
        didSet {
            switch visualEffectMode {
            case 0: visualEffectMode(.fill)
            case 1: visualEffectMode(.leading(visualEffectWidth))
            case 2: visualEffectMode(.treading(visualEffectWidth))
            default: break
            }
        }
    }
    
    public var toolbarBoxSpace: CGFloat {
        return 20
    }
    
    /// 左边的工具类容器，右到左的语言下回自动翻转
    lazy public private(set) var leftToolBarBox: NSStackView = {
        let box = NSStackView()
        box.distribution = .fill
        box.orientation = .horizontal
        box.spacing = 20
        toolbarView.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        box.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        box.leadingAnchor.constraint(equalTo: toolbarView.leadingAnchor, constant: toolbarBoxSpace).isActive = true
        box.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor, constant: 0).isActive = true
        box.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return box
    }()
    
    /// 右边的工具类容器，右到左的语言下回自动翻转
    lazy public private(set) var rightToolBarBox: NSStackView = {
        let box = NSStackView()
        box.distribution = .fill
        box.orientation = .horizontal
        box.spacing = 20
        toolbarView.addSubview(box)
        box.translatesAutoresizingMaskIntoConstraints = false
        box.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        box.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        box.trailingAnchor.constraint(equalTo: toolbarView.trailingAnchor, constant: -toolbarBoxSpace).isActive = true
        box.centerYAnchor.constraint(equalTo: toolbarView.centerYAnchor, constant: 0).isActive = true
        box.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return box
    }()
    
    /// 系统按钮的最大X
    /// - Note: 关闭、最小化、最大化按钮，以最右边的为准
    public private(set) var sysButtonMaxX: CGFloat = 0
    open override var title: String {
        didSet {
            sysTitleField?.stringValue = String()
            titleField.stringValue = title
        }
    }
    
    public var titlebarColor: NSColor = .clear {
        didSet { backgroundView.fillColor = titlebarColor }
    }
    
    open var isVisibleTitle: Bool = true {
        didSet { titleField.isHidden = !isVisibleTitle }
    }
    
    /// 是否自动补偿/固定toolbarView与系统按钮的偏移，true：x 的起点即关闭按钮的最右边
    open var autoFixedToolbarView: Bool = true {
        didSet { updateToolbarViewFrame() }
    }
    
    open override var toolbar: NSToolbar? {
        didSet {
            toolbar?.addObserver(self, forKeyPath: "items", options: [.new, .initial], context: nil)
        }
    }
    
    override init(contentRect: NSRect, styleMask: NSWindow.StyleMask, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: flag)

        remakeSystemButtonFrame()
        initConfiguration()
        configurationAppearance()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        configurationAppearance()
        initToolbarView()
    }
    
    open func configurationAppearance() {
        if #available(OSX 11.0, *) {
            titlebarSeparatorStyle = .none
            toolbarStyle = .unifiedCompact
        }
        toolbar?.sizeMode = .regular
        toolbar?.displayMode = .iconOnly
        tabbingMode = .disallowed
        toolbar?.showsBaselineSeparator = false
    }
    
    private func initConfiguration() {
        Notify.addObserver(self, selector: #selector(_willEnterFullScreenNotification(_:)) , name: NSWindow.willEnterFullScreenNotification, object: self)

        Notify.addObserver(self, selector: #selector(_willExitFullScreenNotification(_:)), name: NSWindow.willExitFullScreenNotification, object: self)
        
        if (titleVisibility == .hidden) {
            titleField.isHidden = true
        } else {
            titleField.isHidden = false
        }
        titleVisibility = .hidden
        
        initSetupTitleField()
        layoutSubviews()
    }
    
    private func initSetupTitleField() {
        guard let titleBarView = titleBarView else { return }
        titleBarView.addSubview(titleField,positioned: .above, relativeTo: nil)
        titleField.alignment = sysTitleField?.alignment ?? .center
        titleField.textColor = sysTitleField?.textColor
        titleField.drawsBackground = false
        titleField.lineBreakMode = .byTruncatingMiddle
        titleField.isEditable = false
        titleField.isSelectable = false
        titleField.isBordered = false
        titleField.font = sysTitleField?.font
        titleField.translatesAutoresizingMaskIntoConstraints = false
        titleField.centerXAnchor.constraint(equalTo: titleBarView.centerXAnchor, constant: 0).isActive = true
        titleField.topAnchor.constraint(equalTo: titleBarView.topAnchor, constant: sysTitleField?.frame.minY ?? 3).isActive = true
    }

    private func initToolbarView() {
        guard let sysToolbarView = sysToolbarView else { return }

        toolbar?.allowsExtensionItems = false
        toolbar?.allowsUserCustomization = false
        if spaceItem == nil {
            toolbar?.insertItem(withItemIdentifier: .space, at: 0)
            spaceItem = toolbar?.items.first
        }

        sysToolbarView.addSubview(toolbarView, positioned: .below, relativeTo: nil)
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolbarView.topAnchor.constraint(equalTo: sysToolbarView.topAnchor, constant: 0),
            toolbarView.bottomAnchor.constraint(equalTo: sysToolbarView.bottomAnchor, constant: 0),
            toolbarView.trailingAnchor.constraint(equalTo: sysToolbarView.trailingAnchor, constant: 0)
        ])
        let lastItem = toolbar?.items.last?.view
        toolbarViewLeading = toolbarView.leadingAnchor.constraint(equalTo: sysToolbarView.leadingAnchor, constant: lastItem?.frame.maxX ?? 0)
        toolbarViewLeading?.isActive = true
    }
    
    private func layoutSubviews() {
        guard let titleBarView = titleBarView else { return }
        backgroundView.frame = titleBarView.bounds
        titleBarView.addSubview(backgroundView, positioned: .below, relativeTo: nil)
        
        titleBarView.addSubview(effectView, positioned: .above, relativeTo: backgroundView)
        effectView.topAnchor.constraint(equalTo: titleBarView.topAnchor).isActive = true
        effectView.bottomAnchor.constraint(equalTo: titleBarView.bottomAnchor).isActive = true
    }
    
    open override func update() {
        super.update()
        
        updateToolbarViewFrame()
    }
    
    private func updateToolbarViewFrame() {
        var constant: CGFloat = 8
        
        if autoFixedToolbarView {
            if let btn = standardWindowButton(.closeButton) {
                sysButtonMaxX = btn.frame.maxX
            }
            
            if let btn = standardWindowButton(.miniaturizeButton) {
                sysButtonMaxX = btn.frame.maxX
            }
            
            if let btn = standardWindowButton(.zoomButton) {
                sysButtonMaxX = btn.frame.maxX
            }
            if NSApplication.shared.userInterfaceLayoutDirection == .rightToLeft {
                constant = frame.size.width - sysButtonMaxX
            } else {
                constant = sysButtonMaxX
            }
        }
        
        toolbarViewLeading?.constant = constant
        let maxWidth = frame.size.width - (max(leftToolBarBox.frame.maxX, rightToolBarBox.frame.size.width) * 2)  - (toolbarBoxSpace * 2) - (sysButtonMaxX * 2)
        titleField.preferredMaxLayoutWidth = maxWidth
    }
    
    @objc private func _willEnterFullScreenNotification(_ note: Notification) {
        isFullScreen = true
        willEnterFullScreenNotification(note)
    }
    
    @objc private func _willExitFullScreenNotification(_ note: Notification) {
        isFullScreen = false
        willExitFullScreenNotification(note)
    }
    
    open func willEnterFullScreenNotification(_ note: Notification) { }
    
    open func willExitFullScreenNotification(_ note: Notification) { }
    
    /// 设置高斯模糊的填充模式
    public func visualEffectMode(_ mode: VisualEffectMode) {
        guard let titleBarView = titleBarView else { return }
        switch mode {
        case .fill:
            if let leading = effectLeadingConstraint {
                titleBarView.removeConstraint(leading)
            }
            effectLeadingConstraint = effectView.leadingAnchor.constraint(equalTo: titleBarView.leadingAnchor)
            effectLeadingConstraint?.isActive = true
            
            if let widthConstraint = effectWidthConstraint {
                if widthConstraint.secondAnchor == nil {
                    effectView.removeConstraint(widthConstraint)
                } else {
                    titleBarView.removeConstraint(widthConstraint)
                }
            }
            effectWidthConstraint = effectView.trailingAnchor.constraint(equalTo: titleBarView.trailingAnchor, constant: 0)
            effectWidthConstraint?.isActive = true
            
        case .leading(let width):
            if let leading = effectLeadingConstraint {
                titleBarView.removeConstraint(leading)
            }
            effectLeadingConstraint = effectView.leadingAnchor.constraint(equalTo: titleBarView.leadingAnchor)
            effectLeadingConstraint?.isActive = true
            
            if let widthConstraint = effectWidthConstraint {
                if widthConstraint.secondAnchor == nil {
                    effectView.removeConstraint(widthConstraint)
                } else {
                    titleBarView.removeConstraint(widthConstraint)
                }
            }
            let width = effectView.widthAnchor.constraint(equalToConstant: width)
            effectWidthConstraint = width
            effectWidthConstraint?.isActive = true
            effectView.addConstraints([width])
            
        case .treading(let width):
            if let leading = effectLeadingConstraint {
                titleBarView.removeConstraint(leading)
            }
            effectLeadingConstraint = effectView.trailingAnchor.constraint(equalTo: titleBarView.trailingAnchor, constant: 0)
            effectLeadingConstraint?.isActive = true
            
            if let widthConstraint = effectWidthConstraint {
                if widthConstraint.secondAnchor == nil {
                    effectView.removeConstraint(widthConstraint)
                } else {
                    titleBarView.removeConstraint(widthConstraint)
                }
            }
            let width = effectView.widthAnchor.constraint(equalToConstant: width)
            effectWidthConstraint = width
            effectWidthConstraint?.isActive = true
            effectView.addConstraints([width])
        }
    }
    
    open override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        
        if isFullScreen {
            exitFullScreen()
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        debugPrint(#function)
    }
    
}

extension NSWindow {
    
    fileprivate static var kIsFullScreenKey = "IsFullScreenKey"
    /// 是否全屏状态
    public var isFullScreen: Bool {
        set {
            objc_setAssociatedObject(self, &NSWindow.kIsFullScreenKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            let isInFull = objc_getAssociatedObject(self, &NSWindow.kIsFullScreenKey) as? Bool
            return isInFull ?? false
        }
    }
    
    /// 进入全屏
    public func enterFullScreen() {
        let lastCollectionBehavior = collectionBehavior
        collectionBehavior = [lastCollectionBehavior, .fullScreenPrimary, .fullScreenAuxiliary]
        toggleFullScreen(self)
        isFullScreen = true
    }
    
    /// 退出全屏
    public func exitFullScreen() {
        toggleFullScreen(self)
        isFullScreen = false
    }
    
}

extension NSWindow {
    
    /// 重设`toolBar`系统按钮的位置
    public func remakeSystemButtonFrame() {
        let space: CGFloat = 6
        let width: CGFloat = 14
        let height: CGFloat = 14
        let closeButton = standardWindowButton(.closeButton)
        let miniaturizeButton = standardWindowButton(.miniaturizeButton)
        let zoomButton = standardWindowButton(.zoomButton)
        guard let titleBarView = closeButton?.superview else { return }
        if let closeButton = closeButton {
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                closeButton.centerYAnchor.constraint(equalTo: titleBarView.centerYAnchor, constant: 0),
                closeButton.widthAnchor.constraint(equalToConstant: width),
                closeButton.heightAnchor.constraint(equalToConstant: height),
                closeButton.leadingAnchor.constraint(equalTo: titleBarView.leadingAnchor, constant: space)
            ])
        }
        
        if let miniaturizeButton = miniaturizeButton {
            miniaturizeButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                miniaturizeButton.centerYAnchor.constraint(equalTo: titleBarView.centerYAnchor, constant: 0),
                miniaturizeButton.widthAnchor.constraint(equalToConstant: width),
                miniaturizeButton.heightAnchor.constraint(equalToConstant: height)
            ])
            if let closeButton = closeButton {
                miniaturizeButton.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: space).isActive = true
            } else {
                miniaturizeButton.leadingAnchor.constraint(equalTo: titleBarView.leadingAnchor, constant: space).isActive = true
            }
        }
        
        if let zoomButton = zoomButton {
            zoomButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                zoomButton.centerYAnchor.constraint(equalTo: titleBarView.centerYAnchor, constant: 0),
                zoomButton.widthAnchor.constraint(equalToConstant: width),
                zoomButton.heightAnchor.constraint(equalToConstant: height)
            ])
            
            if let miniaturizeButton = miniaturizeButton {
                zoomButton.leadingAnchor.constraint(equalTo: miniaturizeButton.trailingAnchor, constant: space).isActive = true
            } else {
                if let closeButton = closeButton {
                    zoomButton.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: space).isActive = true
                } else {
                    zoomButton.leadingAnchor.constraint(equalTo: titleBarView.leadingAnchor, constant: space).isActive = true
                }
            }
        }
    }
    
}


open class TitlebarBackgroundView: NSView {
    
    public var fillColor: NSColor? = NSColor(named: NSColor.Name("background_surface1")) {
        didSet{ needsDisplay = true }
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        if let color = fillColor {
            color.setFill()
        }
        let path = NSBezierPath(rect: self.bounds)
        path.fill()
    }
    
}

extension NSToolbarItem {
    
    open override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
}
