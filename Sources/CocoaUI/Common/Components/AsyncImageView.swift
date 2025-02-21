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
import Foundation
import Combine
import os.log

// MARK: - 兼容版异步图片视图
public struct AsyncImageView: View {
    public let url: String
    var placeholder: AnyView = AnyView(CompatProgressView())
    var errorView: AnyView?
    var imageConfiguration: (Image) -> Image = { $0.resizable() }
    @ObservedObject private var loader = ImageLoader()
    
    private var _errorView: AnyView {
        if #available(macOS 11.0, *) {
            AnyView(Image(systemName: "exclamationmark.triangle"))
        } else {
            AnyView(Text("X"))
        }
    }
    
    public init(url: String) {
        self.url = url
        errorView = _errorView
    }
    
    public init(url: URL) {
        self.url = url.absoluteString
        errorView = _errorView
    }
    
    public var body: some View {
        Group {
            if let image = loader.image {
                imageConfiguration(Image(uiImage: image))
            } else if loader.error != nil {
                errorView
            } else {
                placeholder
            }
        }
        .onAppear { loader.load(url: url) }
        .onDisappear { loader.cancel() }
    }
    
    // MARK: 配置方法
    public func placeholder<Content: View>(@ViewBuilder _ content: () -> Content) -> Self {
        var copy = self
        copy.placeholder = AnyView(content())
        return copy
    }
    
    public func errorView<Content: View>(@ViewBuilder _ content: () -> Content) -> Self {
        var copy = self
        copy.errorView = AnyView(content())
        return copy
    }
    
    public func configureImage(_ transform: @escaping (Image) -> Image) -> Self {
        var copy = self
        copy.imageConfiguration = transform
        return copy
    }
}

// MARK: - 兼容进度指示器
struct CompatProgressView: View {
    var body: some View {
        Group {
            if #available(iOS 14.0, macOS 11.0, *) {
                ProgressView()
            } else {
#if os(iOS)
                ActivityIndicator(style: .medium)
#else
                Text("Loading...")
#endif
            }
        }
    }
}

#if os(iOS)
fileprivate struct ActivityIndicator: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
    
}
#endif

#if DEBUG
// MARK: - 使用示例
@available(macOS 11.0, *)
struct AyncImageContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            AsyncImageView(url: "https://img0.baidu.com/it/u=2191392668,814349101&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=1399")
                .configureImage { image in
                    image
                        .resizable()
                }
                .frame(width: 200, height: 200)
                .clipped()
                .cornerRadius(10)
            
            AsyncImageView(url: "<https://invalid.url>")
                .placeholder {
                    VStack {
                        CompatProgressView()
                        Text("加载中...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .errorView {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                        Text("加载失败")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
        }
        .padding()
    }
}

@available(macOS 11.0, *)
struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        AyncImageContentView()
    }
}
#endif
