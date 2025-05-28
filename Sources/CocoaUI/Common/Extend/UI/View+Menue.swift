//
//  View+File.swift
//  CocoaUI
//
//  Created by simy on 2025/5/28.
//

import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import Foundation

//public extension View {
//    @ViewBuilder
//    func contextMenuButton(title: String, action: @escaping () ->()) -> some View {
//        contextMenu(menuItems: {
//            Button {
//                action()
//            } label: {
//                Text(title)
//            }
//        })
//    }
//    
//    func copyContextMenu(content: String) -> some View {
//        contextMenu(menuItems: {
//            Button("Copy") {
//                self.copyToClipboard(content)
//            }
//        })
//    }
//    
//    func copyToClipboard(_ string: String) {
//#if os(macOS)
//        let pasteboard = NSPasteboard.general
//        pasteboard.clearContents()
//        pasteboard.setString(string, forType: .string)
//#elseif os(iOS)
//        UIPasteboard.general.string = string
//#endif
//    }
//}
