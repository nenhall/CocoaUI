//
//  File.swift
//  
//
//  Created by nenhall on 5/31/25.
//

#if os(iOS)
import Foundation
import UIKit
public extension UIApplication {
    @discardableResult
    func openSetting(options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:]) -> Bool {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL, options: options, completionHandler: nil)
            return true
        }
        return false
    }
}
#endif
