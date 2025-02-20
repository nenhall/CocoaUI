//
//  SwiftUIView.swift
//
//
//  Created by dadi on 2024/7/23.
//

import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

@available(macOS 11.0, iOS 13.0, *)
public struct AsyncImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    let url: URL

    public init(url: URL) {
        self.url = url
        self.imageLoader = ImageLoader(url: url)
    }

    public var body: some View {
        ZStack(alignment: .center) {
            if let data = imageLoader.image, let image = UIImage(data: data) {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4.0)
                }
            } else {
                if #available(iOS 14.0, macOS 11.0, *) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                } else {
                    CocoaAnyView {
#if os(macOS)
                        let indicator = NSProgressIndicator()
                        indicator.style = .spinning
                        indicator.isDisplayedWhenStopped = true
                        return indicator
#else
                        UIProgressView(progressViewStyle: .default)
#endif
                    } updater: { _ in
                    }
                }
            }
        }
    }

    func load() {
        imageLoader.load(url: url)
    }
    
    public func getImage(callback: @escaping (_ image: UIImage?) ->()) {
        DispatchQueue.global().async {
#if os(macOS)
            let image = NSImage(contentsOf: url)
            callback(image)
#else
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                callback(image)
            } else {
                callback(nil)
            }
#endif
        }
    }
}

@available(macOS 11.0, iOS 13.0, *)
#Preview {
    AsyncImageView(url: URL(string: "")!)
}
