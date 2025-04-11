//
//  NSImage+Save.swift
//  AirBrush_Studio
//
//  Created by meitu@nenhall on 2023/5/12.
//
#if os(iOS)
import UIKit
import AVFoundation
import CoreImage

public extension UIImage {
    func save(toPath destinationPath: String, with format: StorageFormat, compression factor: CGFloat = 0.8) -> Result<URL, Error> {
        let destinationURL = URL(fileURLWithPath: destinationPath)
        return save(to: destinationURL, with: format, compression: factor)
    }
    
    func save(to destinationURL: URL, with format: StorageFormat, compression factor: CGFloat = 0.8) -> Result<URL, Error> {
        do {
            switch format {
            case .png:
                try pngData()?.write(to: destinationURL)
            case .jpeg:
                try jpegData(compressionQuality: factor)?.write(to: destinationURL)
            case .heic:
                if #available(iOS 17.0, *) {
                    try heicData()?.write(to: destinationURL)
                } else {
                    try pngData()?.write(to: destinationURL)
                }
            }
            return .success(destinationURL)
        } catch {
            print("保存文件失败:", error.localizedDescription)
            return .failure(error)
        }
    }
}
#endif
