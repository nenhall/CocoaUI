//
//  SwiftUIView.swift
//  
//
//  Created by dadi on 2024/7/25.
//

#if os(macOS)
import SwiftUI
import AppKit

public extension Image {
    init(uiImage: NSImage) {
        self.init(nsImage: uiImage)
    }
}
#endif
