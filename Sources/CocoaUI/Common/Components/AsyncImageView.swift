//
//  SwiftUIView.swift
//
//
//  Created by dadi on 2024/7/23.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import Foundation
import Combine
import os.log
import SwiftUI


// MARK: - 兼容版异步图片视图
public struct AsyncImageView: View {
    // MARK: - 公共属性
    public let url: String
    var placeholder: AnyView = AnyView(CompatProgressView())
    var errorView: AnyView?
    var imageConfiguration: (Image) -> Image = { $0.resizable() }
    var onStateChange: ((ImageLoader) -> Void)?
    let fileName: String

    // MARK: - 状态管理
    @StateObject private var loader = ImageLoader()
    
    // MARK: - 初始化
    public init(url: String, saveName: String = "") {
        self.url = url
        self.fileName = saveName
        self.errorView = _errorView
    }

    public init(url: URL, saveName: String = "") {
        self.url = url.absoluteString
        self.fileName = saveName
        self.errorView = _errorView
    }
    
    // MARK: - 视图构建
    public var body: some View {
        Group {
            switch loader.state {
            case .idle:
                placeholder
            case .loading(let progress):
                if #available(macOS 11.0, iOS 14.0, *) {
                    AnyView(
                        VStack {
                            ProgressView(value: progress)
                            Text("加载中...")
                        }
                    )
                } else {
                    placeholder
                }
            case let .success( image, _):
                imageConfiguration(Image(uiImage: image) )
                    .scaledToFit()
            case .failure:
                errorView ?? _errorView
            }
        }
        .onReceive(loader.$state) { state in
            onStateChange?(loader)
        }
        .onAppear {
            loader.load(url: url)
        }
        .onDisappear {
            loader.cancel()
        }
    }
    
    // MARK: - 私有辅助属性
    private var _errorView: AnyView {
        if #available(macOS 11.0, iOS 14.0, *) {
            return AnyView(
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                    Text("加载失败")
                }
            )
        } else {
            return AnyView(Text("X"))
        }
    }
    
    // MARK: - 配置方法
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
    
    public func onStateChange(_ action: @escaping (ImageLoader) -> Void) -> Self {
        var copy = self
        copy.onStateChange = action
        return copy
    }
}

// MARK: - 兼容进度视图
struct CompatProgressView: View {
    var body: some View {
        if #available(macOS 11.0, iOS 14.0, *) {
            ProgressView()
        } else {
            Text("Loading...")
        }
    }
}

// MARK: - 预览
struct AsyncImageView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AsyncImageView(url: "https://example.com/image.jpg")
                .previewDisplayName("正常加载")
            
            AsyncImageView(url: "invalid_url")
                .previewDisplayName("错误状态")
        }
    }
}
