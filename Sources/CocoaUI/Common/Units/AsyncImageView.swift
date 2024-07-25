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
                if #available(iOS 14.0, *) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                } else {
                    CocoaAnyView {
                        UIProgressView(progressViewStyle: .default)
                    } updater: { _ in
                    }
                }
            }
        }
    }

    func load() {
        imageLoader.load(url: url)
    }

    public func saveImage() {
        let name = "lingrealm-\(url.lastPathComponent)"
#if os(macOS)
        guard let url = Panel.showSave(directoryPath: "/Users/\(NSUserName())", name: name) else { return }
        DispatchQueue.global().async {
            guard let image = NSImage(contentsOf: self.url) else { return }
            image.save(to: url, with: .png)
        }
#else

#endif
    }
}

@available(macOS 11.0, iOS 13.0, *)
#Preview {
    AsyncImageView(url: URL(string: "")!)
}
