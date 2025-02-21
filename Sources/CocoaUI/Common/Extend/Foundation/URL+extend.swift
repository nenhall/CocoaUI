//
//  URLExtention.swift
//  SwiftExtension
//
//  Created by nenhall on 2022/4/13.
//

import Foundation

public extension URL {

    func resourceValues(_ keys: URLResourceKey...) -> URLResourceValues? {
        return try? self.resourceValues(forKeys: Set(keys))
    }

    var isDirectory: Bool {
        return resourceValues(.isDirectoryKey)?.isDirectory == true
    }

    var fileSize: Int {
        return resourceValues(.fileSizeKey)?.fileSize ?? 0
    }

    var fileSizeString: String {
        return fileSize.fileSizeString
    }

    var isSymbolicLink: Bool {
        guard let values = try? self.resourceValues(forKeys: [.isSymbolicLinkKey]) else { return false }
        return values.isSymbolicLink ?? false
    }

    /// FileManager.default.fileExists(atPath: URL.path)
    var isFileExisted: Bool {
        return path.isFileExisted
    }
}
