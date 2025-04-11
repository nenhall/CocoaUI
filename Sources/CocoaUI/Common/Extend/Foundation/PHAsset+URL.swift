//
//  File.swift
//  
//
//  Created by nenhall on 4/8/25.
//

import Foundation
import Photos

public extension PHAsset {
    func url(completion: @escaping (URL?) -> Void) {
        if mediaType == .image {
            let options = PHContentEditingInputRequestOptions()
            requestContentEditingInput(with: options) { (input, _) in
                guard let input = input, let fullSizeImageURL = input.fullSizeImageURL else {
                    completion(nil)
                    return
                }
                completion(fullSizeImageURL)
            }
        } else {
            completion(nil)
        }
    }
}

