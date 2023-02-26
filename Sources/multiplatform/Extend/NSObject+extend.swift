//
//  NSObject.swift.swift
//  PDFelement
//
//  Created by nenhall on 2022/2/25.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension NSObject {
    
#if os(macOS)
    var onlyClassName: String {
        return className.components(separatedBy: ".").last ?? ""
    }

    class var onlyClassName: String {
        return Self.className().components(separatedBy: ".").last ?? ""
    }
#endif
}
