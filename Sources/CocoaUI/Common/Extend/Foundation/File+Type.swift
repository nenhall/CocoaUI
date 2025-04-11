//
//  File.swift
//  
//
//  Created by nenhall on 4/10/25.
//

import Foundation

public enum FileType {
    case image
    case file
    case unknown
}

public extension String {
    func fileType() -> FileType {
        guard let fileURL = URL(string: self) else {
            print("无效的 URL")
            return .unknown
        }
        
        let fileExtension = fileURL.pathExtension.lowercased()
        
        // 定义图片扩展名
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "bmp", "webp", "tiff"]
        
        // 判断文件类型
        if imageExtensions.contains(fileExtension) {
            return .image
        } else if !fileExtension.isEmpty {
            return .file
        } else {
            return .unknown
        }
    }
}

public extension URL {
    func fileType() -> FileType {
        let fileExtension = pathExtension.lowercased()
        
        // 定义图片扩展名
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "bmp", "webp", "tiff"]
        
        // 判断文件类型
        if imageExtensions.contains(fileExtension) {
            return .image
        } else if !fileExtension.isEmpty {
            return .file
        } else {
            return .unknown
        }
    }
}
