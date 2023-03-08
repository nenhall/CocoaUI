//
//  UI+extent.swift
//  
//
//  Created by nenhall on 2022/8/20.
//

import Foundation

open class View: UIView {

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupSubviews()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setupSubviews() {

    }

}

open class ViewController: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }

    open func setupSubviews() {

    }

}
