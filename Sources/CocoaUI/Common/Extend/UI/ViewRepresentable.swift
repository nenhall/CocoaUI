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
public typealias UIViewControllerRepresentable = NSViewControllerRepresentable
public typealias UIViewControllerRepresentableContext = NSViewControllerRepresentableContext
//public typealias UIViewControllerType = NSViewControllerType
@available(macOS 10.15, *)
public typealias UIViewRepresentableContext = NSViewRepresentableContext
#else
import UIKit
#endif

@available(macOS 10.15, iOS 13.0, *)
public protocol ViewRepresentable: UIViewRepresentable {
    associatedtype ViewType : UIView
    typealias Context = UIViewRepresentableContext<Self>

    func makeView(context: Context) -> ViewType
    func updateView(_ nsView: ViewType, context: Context)
}

@available(macOS 10.15, iOS 13.0, *)
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

@available(macOS 10.15, iOS 13.0, *)
public protocol ViewControllerRepresentable: UIViewControllerRepresentable {
    associatedtype ViewControllerType : UIViewController

    typealias Context = UIViewControllerRepresentableContext<Self>

    @MainActor func makeViewController(context: Self.Context) -> Self.ViewControllerType
    @MainActor func updateViewController(_ uiViewController: Self.ViewControllerType, context: Self.Context)
    @MainActor static func dismantleViewController(_ uiViewController: Self.ViewControllerType, coordinator: Self.Coordinator)
}

@available(macOS 10.15, iOS 13.0, *)
public extension ViewControllerRepresentable {
    
#if os(macOS)
    @MainActor func makeNSViewController(context: Self.Context) -> Self.ViewControllerType {
        makeViewController(context: context)
    }

    @MainActor func updateNSViewController(_ nsViewController: Self.ViewControllerType, context: Self.Context) {
        updateViewController(nsViewController, context: context)
    }
    
    @MainActor static func dismantleNSViewController(_ nsViewController: Self.ViewControllerType, coordinator: Self.Coordinator) {
        dismantleViewController(nsViewController, coordinator: coordinator)
    }
#else
    @MainActor func makeUIViewController(context: Self.Context) -> Self.ViewControllerType {
        makeViewController(context: context)
    }

    @MainActor func updateUIViewController(_ uiViewController: Self.ViewControllerType, context: Self.Context) {
        updateViewController(uiViewController, context: context)
    }

    @MainActor static func dismantleUIViewController(_ uiViewController: Self.ViewControllerType, coordinator: Self.Coordinator) {
        dismantleViewController(uiViewController, coordinator: coordinator)
    }
#endif
}
