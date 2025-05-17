//
//  UIDevice+os.swift
//  CocoaUI
//
//  Created by simy on 2025/5/17.
//

import SwiftUI
#if os(iOS)
import UIKit

public extension UIDevice {
    static func isiPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
#endif

extension View {
    var isiPad: Bool {
#if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad
#else
        return false
#endif
    }
}
