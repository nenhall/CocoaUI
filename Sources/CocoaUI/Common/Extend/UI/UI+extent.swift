//
//  UI+extent.swift
//  
//
//  Created by nenhall on 2022/8/20.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

open class CocoaView: UIView {
    public override init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        setupSubviews()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setupSubviews() {

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

#if os(macOS)
extension NSTextField {
    public func setBackground(color: NSColor) {
        backgroundColor = color
    }
}
#endif
