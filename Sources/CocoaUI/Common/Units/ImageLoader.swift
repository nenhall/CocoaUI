//
//  File.swift
//
//
//  Created by dadi on 2024/7/23.
//

import Combine
import SwiftUI
import os.log

class ImageLoader: ObservableObject {
    static let cache = NSCache<NSString, UIImage>()
    @available(macOS 11.0, *)
    private static let logger = Logger(subsystem: "com.example.", category: "Networking")
    
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var error: Error?
    
    private var cancellable: AnyCancellable?
    private let queue = DispatchQueue(label: "image-loader", qos: .userInitiated)
    
    func load(url: String) {
        guard let url = URL(string: url) else {
            error = URLError(.badURL)
            return
        }
        
        // 内存缓存检查
        if let cachedImage = Self.cache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }
        
        isLoading = true
        error = nil
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: queue)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    throw URLError(.badServerResponse)
                }
                guard let image = UIImage(data: output.data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                return image
            }
            .handleEvents(receiveOutput: { image in
                Self.cache.setObject(image, forKey: url.absoluteString as NSString)
            })
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        if #available(macOS 11.0, *) {
                            Self.logger.error("图片加载失败: \\(error.localizedDescription)")
                        } else {
                            debugPrint("图片加载失败: \\(error.localizedDescription)")
                        }
                        self?.error = error
                    }
                },
                receiveValue: { [weak self] image in
                    self?.image = image
                }
            )
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    deinit {
        cancellable?.cancel()
    }
}
