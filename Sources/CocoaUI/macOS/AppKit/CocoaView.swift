//
//  CocoaView.swift
//  CocoaUI
//
//  Created by simy on 2025/5/12.
//

#if os(macOS)
import Cocoa

open class CocoaView: UIView {
    private var isEnabled: Bool = true
    /// 黑暗模式改变句柄
    public var darkModeChangedHandler: Handler?
    @IBInspectable var backgroundColor: NSColor? {
        didSet {
            layer?.backgroundColor = backgroundColor?.cgColor
            needsDisplay = true
        }
    }
    @IBInspectable var borderColor: NSColor? {
        didSet {
            layer?.borderColor = borderColor?.cgColor
            needsDisplay = true
        }
    }
    
    public override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setupSubviews()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setupSubviews() {

    }
        
    public convenience init(color: NSColor) {
        self.init(frame: .zero)

        backgroundColor = color
        layer?.backgroundColor = color.cgColor
    }

    open override func updateLayer() {
        super.updateLayer()
        if let color = backgroundColor?.cgColor {
            layer?.backgroundColor = color
        }
        if let color = borderColor?.cgColor {
            layer?.borderColor = color
        }
        darkModeChangedHandler?()
    }

    open override func hitTest(_ point: NSPoint) -> NSView? {
        return isEnabled ? super.hitTest(point) : nil
    }

    /// 设置view和其子控件不响应事件
    open func setEnable(_ enable: Bool) {
        for view in subviews {
            if let control = view as? NSControl {
                control.isEnabled = enable
            }
        }
        isEnabled = enable
    }
}

open class CocoaViewController: UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    open func setupSubviews() {

    }
}
#endif
