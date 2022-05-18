//
//  File.swift
//  
//
//  Created by nenhall on 2022/5/18.
//

import Foundation

public extension FileManager {

    static func attributes(of path: String) -> [FileAttributeKey: Any]? {
        return try? FileManager.default.attributesOfItem(atPath: path)
    }

    static func fileSize(of path: String) -> Int64 {
        return FileManager.attributes(of: path)?[.size] as? Int64 ?? 0
    }

    static func fileSizeString(of path: String) -> String {
        return FileManager.fileSize(of: path).fileSizeString
    }
}

public extension Int64 {

    var fileSizeString: String {
        return ByteCountFormatter.string(fromByteCount: self, countStyle: ByteCountFormatter.CountStyle.file)
    }
}

public extension Int {

    var fileSizeString: String {
        return Int64(self).fileSizeString
    }
}
