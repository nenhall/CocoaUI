//
//  AlertView.swift
//  LingRealmUI
//
//  Created by nenhall on 4/10/25.
//

import Foundation

#if os(iOS)
import UIKit

public struct AlertView {
    public let title: String
    private let message: String
    private let style: UIAlertController.Style
    private let alertController: UIAlertController
    
    public init(title: String, message: String, style: UIAlertController.Style) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        self.title = title
        self.message = message
        self.style = style
    }
    
    @discardableResult
    public func addAction(title: String, style: UIAlertAction.Style, handler: ((_ title: String) -> Void)? = nil) -> AlertView {
        let action = UIAlertAction(title: title, style: style) { alert in
            handler?(title)
        }
        alertController.addAction(action)
        return self
    }
    
    public func show() {
        if let topViewController = UIApplication.shared.topViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func hide() {
        alertController.dismiss(animated: true)
    }
}

#endif
