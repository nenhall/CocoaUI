//
//  File.swift
//
//
//  Created by dadi on 2024/7/23.
//

import Combine
import Foundation
import os.log
#if os(macOS)
import AppKit
#else
import UIKit
#endif

public class ImageLoader: ObservableObject {
    // MARK: - 静态属性
    public static let cache = NSCache<NSString, UIImage>()
    
    @available(macOS 11.0, iOS 14.0, *)
    private static let logger = Logger(subsystem: "com.example", category: "ImageLoader")
    
    // MARK: - 状态枚举
    public enum LoadState {
        case idle
        case loading(progress: Double)
        case success(UIImage, String)
        case failure(Error)
        
        var isLoading: Bool {
            if case .loading = self { return true }
            return false
        }
    }
    
    // MARK: - 发布属性
    @Published public private(set) var state: LoadState = .idle
    @Published public private(set) var image: UIImage?
    @Published public private(set) var isLoading = false
    @Published public private(set) var error: Error?
    @Published public private(set) var progress: Double = 0
    @Published public private(set) var lastLoadedURL: String?
    @Published public private(set) var lastSuccessTime: Date?
    @Published public private(set) var retryCount: Int = 0
    @Published public private(set) var imageSize: CGSize = .zero
    private var urlString: String = ""
    
    // MARK: - 私有属性
    private var cancellable: AnyCancellable?
    private let downloadQueue = DispatchQueue(label: "com.example.image-download", qos: .utility)
    private let processingQueue = DispatchQueue(label: "com.example.image-processing", qos: .userInitiated)
    private let maxRetryCount = 3
    
    // MARK: - 公共方法
    
    /// 加载图片
    /// - Parameters:
    ///   - urlString: 图片URL字符串
    ///   - forceRefresh: 是否强制刷新（忽略缓存）
    public func load(url urlString: String, forceRefresh: Bool = false) {
        self.urlString = urlString
        guard let url = URL(string: urlString) else {
            updateState(.failure(URLError(.badURL)))
            return
        }
        
        // 检查缓存（除非强制刷新）
        if !forceRefresh, let cachedImage = Self.cache.object(forKey: urlString as NSString) {
            updateState(.success(cachedImage, urlString))
            return
        }
        
        // 重置状态
        updateState(.loading(progress: 0))
        lastLoadedURL = urlString
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: downloadQueue)
            .handleEvents(receiveSubscription: { _ in
//                self?.log("开始加载图片: \(urlString)")
            }, receiveOutput: { [weak self] (data, response) in
//                self?.log("收到响应: \(response)")
                self?.cacheImage(data, forKey: urlString)
            }, receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
//                    self?.log("图片加载完成: \(urlString)")
                    break
                case .failure(let error):
                    self?.log("图片加载失败: \(error.localizedDescription)", level: .error)
                }
            }, receiveCancel: { [weak self] in
                self?.log("图片加载取消: \(urlString)")
            })
            .tryMap { output -> UIImage in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                guard 200..<300 ~= response.statusCode else {
                    throw URLError(.init(rawValue: response.statusCode))
                }
                
                guard let image = UIImage(data: output.data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                
                return image
            }
            .receive(on: processingQueue)
            .handleEvents(receiveOutput: { [weak self] image in
                self?.updateState(.loading(progress: 1.0))
                self?.updateImageSize(image.size)
            })
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.handleLoadError(error, urlString: urlString)
                    }
                },
                receiveValue: { [weak self] image in
                    self?.handleLoadSuccess(image)
                }
            )
    }
    
    /// 重试加载
    public func retry() {
        guard retryCount < maxRetryCount, let url = lastLoadedURL else { return }
        retryCount += 1
        load(url: url)
    }
    
    /// 取消当前加载任务
    public func cancel() {
        log("取消图片加载")
        cancellable?.cancel()
        updateState(.idle)
    }
    
    /// 重置加载器状态
    public func reset() {
        cancel()
        retryCount = 0
        lastLoadedURL = nil
        lastSuccessTime = nil
        imageSize = .zero
    }
    
    // MARK: - 私有方法
    
    private func updateState(_ newState: LoadState) {
        DispatchQueue.main.async {
            self.state = newState
            
            switch newState {
            case .idle:
                self.isLoading = false
                self.progress = 0
                self.error = nil
            case .loading(let progress):
                self.isLoading = true
                self.progress = progress
                self.error = nil
            case let .success(image, _):
                self.isLoading = false
                self.progress = 1.0
                self.error = nil
                self.image = image
            case .failure(let error):
                self.isLoading = false
                self.progress = 0
                self.error = error
            }
        }
    }
    
    private func handleLoadSuccess(_ image: UIImage) {
        updateState(.success(image, urlString))
        lastSuccessTime = Date()
        retryCount = 0
    }
    
    private func handleLoadError(_ error: Error, urlString: String) {
        if retryCount < maxRetryCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.load(url: urlString)
            }
        } else {
            updateState(.failure(error))
        }
    }
    
    private func updateImageSize(_ size: CGSize) {
        DispatchQueue.main.async {
            self.imageSize = size
        }
    }
    
    private func cacheImage(_ data: Data, forKey key: String) {
        processingQueue.async {
            if let image = UIImage(data: data) {
                Self.cache.setObject(image, forKey: key as NSString)
            }
        }
    }
    
    private func log(_ message: String, level: OSLogType = .info) {
        if #available(macOS 11.0, iOS 14.0, *) {
            Self.logger.log(level: level, "\(message)")
        } else {
            print("[ImageLoader] \(message)")
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

extension ImageLoader.LoadState: Equatable {
    public static func == (lhs: ImageLoader.LoadState, rhs: ImageLoader.LoadState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading(let lhsProgress), .loading(let rhsProgress)):
            return lhsProgress == rhsProgress
        case (.success(_, let lhsURL), .success(_, let rhsURL)):
            return lhsURL == rhsURL
        case (.failure(let lhsError), .failure(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
