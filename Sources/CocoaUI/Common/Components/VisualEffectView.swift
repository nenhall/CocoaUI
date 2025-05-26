//
//  File.swift
//  
//
//  Created by nenhall on 5/21/25.
//

import Foundation
import SwiftUI

#if os(macOS)

@available(macOS 11, *)
public struct VisualEffectView: NSViewRepresentable {
    public typealias NSViewType = NSVisualEffectView
    
    public init() { }
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = .hudWindow
        effectView.blendingMode = .withinWindow
        effectView.state = NSVisualEffectView.State.active
        return effectView
    }
    
    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = .hudWindow
        nsView.blendingMode = .withinWindow
    }
}

#else

@available(iOS 14, *)
public struct VisualEffectView: UIViewRepresentable {
    public typealias UIViewType = UIVisualEffectView
    
    public init() { }

    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .systemMaterial)
    }
}

#endif
