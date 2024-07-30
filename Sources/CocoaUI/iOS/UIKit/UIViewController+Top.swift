//
//  File.swift
//  
//
//  Created by dadi on 2024/7/29.
//

#if os(iOS)

import Foundation
import UIKit

public extension UIApplication {
    static var currentWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            // For iOS 13 and later, we use the scene's key window
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: { $0.isKeyWindow })
        } else {
            // For iOS 12 and earlier, we use the key window
            return UIApplication.shared.keyWindow
        }
    }
}

public extension UIViewController {
    static var current: UIViewController? {
        return UIApplication.currentWindow?.rootViewController?.topViewController()
    }
}

public extension UIViewController {
    func topViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topViewController()
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topViewController()
        }
        if let presentedViewController = presentedViewController {
            return presentedViewController.topViewController()
        }
        return self
    }
}

public extension UIApplication {
    var topViewController: UIViewController? {
        UIViewController.current
    }
}

#endif
