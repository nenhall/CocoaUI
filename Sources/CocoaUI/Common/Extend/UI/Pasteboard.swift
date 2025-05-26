//
//  File.swift
//  
//
//  Created by nenhall on 5/23/25.
//

import Foundation
#if os(iOS)
import UIKit
#else
import Cocoa
#endif

/// 将文本写入剪贴板
public func writeToClipboard(text: String) {
    #if os(iOS)
    UIPasteboard.general.string = text
    #elseif os(macOS)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(text, forType: .string)
    #endif
}
