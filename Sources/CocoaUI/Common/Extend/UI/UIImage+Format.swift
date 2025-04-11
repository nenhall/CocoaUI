//
//  File.swift
//  
//
//  Created by nenhall on 4/8/25.
//

import Foundation
#if os(iOS)
import UIKit
#else
import AppKit
#endif

public extension UIImage {
    enum StorageFormat: String {
        case png
        case jpeg
        case heic
    }
    
    func saveToTempDirectory(name: String, format: StorageFormat, compression factor: CGFloat = 0.8) -> Result<URL, Error> {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName: String
        switch format {
        case .png:
            fileName = "\(name.appending(UUID().uuidString)).png"
        case .jpeg:
            fileName = "\(name.appending(UUID().uuidString)).jpeg"
        case .heic:
            fileName = "\(name.appending(UUID().uuidString)).heic"
        }
        let fileURL = tempDirectory.appendingPathComponent(fileName)
        return save(to: fileURL, with: format, compression: factor)
    }
}
