//
//  CoWindow.swift
//  CocoaUIKit
//
//  Created by nenhall on 2021/10/09.
//

import Cocoa

open class CoWindowController: NSWindowController {
    @IBInspectable public var visualEffectWidth: CGFloat = 0
    @IBInspectable public var visualEffectMode: Int = -1
    @IBInspectable public var titlebarColor: NSColor = .clear
    
    open override func windowDidLoad() {
        super.windowDidLoad()
        
        updateSetting()
    }
    
    private func updateSetting() {
        CoNotify.addObserver(self, selector: #selector(windowWillCloseNotification(_:)), name: NSWindow.willCloseNotification, object: window)
        
        if let coWindow = window as? CoWindow {
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

open class CoWindow: NSWindow {
    
    /// 高斯模糊填充模式
    public enum VisualEffectMode {
        case fill /// 完全填充
        case leading(_ width: CGFloat) ///左对齐计算宽度
        case treading(_ width: CGFloat) ///右对齐计算宽度
    }
    
    /// 系统的 NSTitleBarView
    public var titleBarView: NSView? {
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
                                return item2
                            }
                        }
                    }
                }
            }
        }
        return titleView
    }
    
    /// window 的标题栏，原始的标题栏被隐藏了
    private var _titleField: NSTextField?
    public var titleField: NSTextField? {
        if _titleField != nil { return _titleField }
        guard let titleBarView = titleBarView else { return nil }
        for item in titleBarView.subviews {
            if let titleField = item as? NSTextField {
                _titleField = titleField
                titleField.alignment = .center
                titleField.drawsBackground = true
                titleField.lineBreakMode = .byTruncatingMiddle
                titleField.isEditable = false
                titleField.isSelectable = false
                titleField.isBordered = false
                titleField.font = NSFont.boldSystemFont(ofSize: 20)
                titleField.translatesAutoresizingMaskIntoConstraints = false
                titleField.centerXAnchor.constraint(equalTo: titleBarView.centerXAnchor, constant: 0).isActive = true
                titleField.centerYAnchor.constraint(equalTo: titleBarView.centerYAnchor, constant: 0).isActive = true
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

    public var titlebarColor: NSColor = .clear {
        didSet {
            backgroundView.fillColor = titlebarColor
        }
    }
        
    override init(contentRect: NSRect, styleMask: NSWindow.StyleMask, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: styleMask, backing: backing, defer: flag)

        initConfiguration()
        configurationAppearance()
        remakeSystemButtonFrame()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        configurationAppearance()
    }
    
    private func initConfiguration() {
        CoNotify.addObserver(self, selector: #selector(_willEnterFullScreenNotification(_:)) , name: NSWindow.willEnterFullScreenNotification, object: self)

        CoNotify.addObserver(self, selector: #selector(_willExitFullScreenNotification(_:)), name: NSWindow.willExitFullScreenNotification, object: self)
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
        titleField?.needsDisplay = true
        
        layoutSubviews()
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
    
    private func layoutSubviews() {
        guard let titleBarView = titleBarView else { return }
        backgroundView.frame = titleBarView.bounds
        titleBarView.addSubview(backgroundView, positioned: .below, relativeTo: nil)
        
        titleBarView.addSubview(effectView, positioned: .above, relativeTo: backgroundView)
        effectView.topAnchor.constraint(equalTo: titleBarView.topAnchor).isActive = true
        effectView.bottomAnchor.constraint(equalTo: titleBarView.bottomAnchor).isActive = true
    }
    
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
}

extension NSWindow {
    fileprivate static var kIsInFullScreenMode = "kIsInFullScreenMode"
    /// 是否全屏状态
    public var isFullScreen: Bool {
        set {
            objc_setAssociatedObject(self, &NSWindow.kIsInFullScreenMode, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            let isInFull = objc_getAssociatedObject(self, &NSWindow.kIsInFullScreenMode) as? Bool
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
