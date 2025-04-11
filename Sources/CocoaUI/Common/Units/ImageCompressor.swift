//
//  File.swift
//  
//
//  Created by nenhall on 4/9/25.
//

import Foundation
#if os(iOS)
import UIKit
#else
import AppKit
#endif

public enum ImageCompressor {
    public static func compressImageFromLocalPath(_ path: String) -> Data? {
        let maxSize = 5 * 1024 * 1024 // 5MB
        
        // 步骤1：检查文件是否存在
        guard FileManager.default.fileExists(atPath: path) else {
            debugPrint("⚠️ 文件不存在")
            return nil
        }
        
        // 步骤2：获取文件大小
        guard let fileSize = try? FileManager.default.attributesOfItem(atPath: path)[.size] as? Int else {
            debugPrint("⚠️ 无法获取文件大小")
            return nil
        }
        
        // 步骤3：如果原文件已经符合要求，直接返回
        if fileSize <= maxSize {
            do {
                return try Data(contentsOf: URL(fileURLWithPath: path))
            } catch {
                debugPrint("✅ 原文件符合要求，但读取失败: \(error)")
                return nil
            }
        }
        
        // 步骤4：加载图片并进行压缩
        #if canImport(UIKit)
        guard let image = UIImage(contentsOfFile: path) else {
            debugPrint("⚠️ 图片加载失败")
            return nil
        }
        #elseif canImport(AppKit)
        guard let image = NSImage(contentsOf: URL(fileURLWithPath: path)) else {
            debugPrint("⚠️ 图片加载失败")
            return nil
        }
        #endif
        
        return compressImageTo5MB(image)
    }

    /// 压缩图片到指定大小（5MB）
    public static func compressImageTo5MB(_ image: UIImage) -> Data? {
        let maxSizeInBytes = 5 * 1024 * 1024 // 5MB
        
        // 第一步：检查原始JPEG是否已符合要求
        if let originalData = image.jpegData(compressionQuality: 1.0),
           originalData.count <= maxSizeInBytes {
            return originalData
        }
        
        var compressionQuality: CGFloat = 0.8
        
        // 第一步：尝试压缩质量
        guard var compressedData = image.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        
        // 如果第一次压缩就满足要求
        if compressedData.count < maxSizeInBytes {
            return compressedData
        }
        
        // 质量压缩循环（最多尝试5次）
        for _ in 0..<5 where compressedData.count > maxSizeInBytes {
            compressionQuality -= 0.1
            if let newData = image.jpegData(compressionQuality: max(compressionQuality, 0.2)) {
                compressedData = newData
            }
        }
        
        // 第二步：如果质量压缩后仍不满足，进行尺寸压缩
        if compressedData.count > maxSizeInBytes {
            let scaleFactor = sqrt(CGFloat(maxSizeInBytes) / CGFloat(compressedData.count))
            return compressByScaling(image, scaleFactor: scaleFactor)
        }
        
        return compressedData
    }
    
    /// 尺寸压缩
    private static func compressByScaling(_ image: UIImage, scaleFactor: CGFloat) -> Data? {
        let newSize = CGSize(
            width: image.size.width * scaleFactor,
            height: image.size.height * scaleFactor
        )
        
        #if canImport(UIKit)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage?.jpegData(compressionQuality: 0.7)
        #elseif canImport(AppKit)
        let resizedImage = NSImage(size: newSize)
        resizedImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: newSize))
        resizedImage.unlockFocus()
        return resizedImage.jpegData(compressionQuality: 0.7)
        #endif
    }
}

// MARK: - 平台兼容处理
#if canImport(AppKit)
extension NSImage {
    func jpegData(compressionQuality: CGFloat) -> Data? {
        guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        return bitmapRep.representation(using: .jpeg, properties: [.compressionFactor: compressionQuality])
    }
}
#endif

public extension Int {
    func bytesToMB() -> Double {
        return Double(self) / 1024 / 1024
    }
}
