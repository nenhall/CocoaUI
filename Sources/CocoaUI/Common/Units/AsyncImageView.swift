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

@available(macOS 11.0, *)
public struct AsyncImageView: View {
    @ObservedObject var imageLoader: ImageLoader
    let url: URL

    public init(url: URL) {
        self.url = url
        self.imageLoader = ImageLoader(url: url)
    }

    public var body: some View {
        ZStack(alignment: .center) {
            if let data = imageLoader.image, let image = NSImage(data: data) {
                ZStack {
                    Image(nsImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(4.0)
                        
//                    Button {
////                        saveImage()
//                    } label: {
//                        Image(systemName: "square.and.arrow.down")
//                            .frame(width: 100)
//                    }
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
            }
        }
    }

    func load() {
        imageLoader.load(url: url)
    }
}

#Preview {
    if #available(macOS 11.0, *) {
        AsyncImageView(url: URL(string: "")!)
    } else {
        Text("")
    }
}
