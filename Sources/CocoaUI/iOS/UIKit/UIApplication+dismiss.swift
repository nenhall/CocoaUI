//
//  File.swift
//  
//
//  Created by nenhall on 5/16/25.
//

#if os(iOS)
import Foundation
import UIKit

public extension UIApplication {
    var currentKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }.first
    }
    
    var rootViewController: UIViewController? {
        currentKeyWindow?.rootViewController
    }
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController?.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func dismissPresentedViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        rootViewController?.dismiss(animated: animated, completion: completion)
    }
}
#endif
