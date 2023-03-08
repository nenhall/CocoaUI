//
//  ViewRepresentable.swift
//
//
//  Created by nenhall on 2023/3/08.
//

import SwiftUI

#if os(macOS)
import Cocoa
@available(macOS 10.15, *)
public typealias UIViewRepresentable = NSViewRepresentable
@available(macOS 10.15, *)
public typealias UIViewRepresentableContext = NSViewRepresentableContext
#else
import UIKit
#endif

@available(macOS 10.15, *)
public protocol ViewRepresentable: UIViewRepresentable {
    associatedtype ViewType : UIView
    typealias Context = UIViewRepresentableContext<Self>

    func makeView(context: Context) -> ViewType
    func updateView(_ nsView: ViewType, context: Context)
}

@available(macOS 10.15, *)
public extension ViewRepresentable {

    #if os(macOS)
    func makeNSView(context: Context) -> ViewType {
        return makeView(context: context)
    }

    func updateNSView(_ nsView: ViewType, context: Context) {
        updateView(nsView, context: context)
    }

    #else
    func makeUIView(context: Context) -> ViewType {
        return makeView(context: context)
    }

    func updateUIView(_ nsView: ViewType, context: Context) {
        updateView(nsView, context: context)
    }
    #endif

    func updateView(_ nsView: ViewType, context: Context) { }
}

@available(macOS 10.15, *)
public struct AnyView<Wrapper: UIView>: ViewRepresentable {
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
