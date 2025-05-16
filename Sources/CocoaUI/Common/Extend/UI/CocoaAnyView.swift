//
//  SwiftUIView.swift
//  
//
//  Created by nenhall on 5/16/25.
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, *)
public struct CocoaAnyView<Wrapper: UIView>: ViewRepresentable {
    public typealias ViewType = Wrapper

    public var makeView: () -> Wrapper
    public var update: (_ nsView: Wrapper, Context) -> Void

    public init(makeView: @escaping () -> Wrapper,
                updater update: ((_ nsView: Wrapper) -> Void)? = nil) {
        self.makeView = makeView
        self.update = { view, _ in update?(view) }
    }
    
    public func makeView(context: Context) -> Wrapper {
        makeView()
    }
    
    public func updateView(_ nsView: Wrapper, context: Context) {
        update(nsView, context)
    }
}
