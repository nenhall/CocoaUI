//
//  File.swift
//
//
//  Created by dadi on 2024/7/23.
//

import Combine
import SwiftUI

@available(macOS 11.0, iOS 13.0, *)
public class ImageLoader: ObservableObject {
    @Published public var image: Data?

    private var cancellable: AnyCancellable?

    public init(url: URL) {
        load(url: url)
    }

    deinit {
        cancellable?.cancel()
    }

    func load(url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .replaceError(with: Data())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
}

