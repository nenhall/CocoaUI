//
//  AlertView.swift
//  LingRealmUI
//
//  Created by nenhall on 4/10/25.
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public struct AlertView {
    public enum ActionStyle {
        case `default`
        case cancel
        case destructive
    }

    public enum AlertStyle : UInt, Sendable {
        case `default` = 10
        case osxWarning = 0
        case osxInformational = 1
        case osxCritical = 2
        case alert
        case sheet
    }
    
    public let title: String
    private let message: String

    #if os(iOS)
    private var alertController: UIAlertController
    #elseif os(macOS)
    private var alert: NSAlert
    #endif
    
    public init(title: String, message: String, osxStyle: AlertView.AlertStyle = .osxInformational, iOSStyle: AlertView.AlertStyle = .alert) {
        self.title = title
        self.message = message
        
        #if os(iOS)
        let preferredStyle: UIAlertController.Style
        switch iOSStyle {
        case .alert: preferredStyle = .alert
        case .sheet: preferredStyle = .actionSheet
        default: preferredStyle = .alert
        }
        alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        #elseif os(macOS)
        alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        let nsAlertStyle: NSAlert.Style
        switch osxStyle {
        case .osxInformational: nsAlertStyle = .informational
        case .osxCritical: nsAlertStyle = .critical
        case .osxWarning: nsAlertStyle = .warning
        default: nsAlertStyle = .informational
        }
        alert.alertStyle = nsAlertStyle
        #endif
    }
    
    @discardableResult
    public func addAction(title: String, style: AlertView.ActionStyle = .default, handler: ((_ title: String) -> Void)? = nil) -> AlertView {
        #if os(iOS)
        let uiAlertActionStyle: UIAlertAction.Style
        switch style {
        case .default: uiAlertActionStyle = .default
        case .cancel: uiAlertActionStyle = .cancel
        case .destructive: uiAlertActionStyle = .destructive
        }
        
        let action = UIAlertAction(title: title, style: uiAlertActionStyle) { _ in
            handler?(title)
        }
        alertController.addAction(action)
        
        #elseif os(macOS)
        alert.addButton(withTitle: title)
        #endif
        
        return self
    }
    
    public func beginSheetModal(completion handler: ((_ responseValue: Int) -> Void)? = nil) {
        #if os(iOS)
        if let topViewController = UIApplication.shared.topViewController {
            topViewController.present(alertController, animated: true) {
                handler?(0)
            }
        }
        #else
        if let window = NSApplication.shared.keyWindow {
            alert.beginSheetModal(for: window) { response in
                handler?(response.rawValue)
            }
        }
        #endif
    }
    
    public func show() {
        #if os(iOS)
        if let topViewController = UIApplication.shared.topViewController {
            topViewController.present(alertController, animated: true, completion: nil)
        }
        #else
        alert.runModal()
        #endif
    }
    
    public func hide() {
        #if os(iOS)
        alertController.dismiss(animated: true)
        #endif
    }
}

//#if os(iOS)
//extension UIApplication {
//    var topViewController: UIViewController? {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootViewController = windowScene.windows.first?.rootViewController else {
//            return nil
//        }
//        
//        var topController = rootViewController
//        while let presentedViewController = topController.presentedViewController {
//            topController = presentedViewController
//        }
//        return topController
//    }
//}
//#endif
