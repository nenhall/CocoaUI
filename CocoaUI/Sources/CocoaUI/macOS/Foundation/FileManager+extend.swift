//
//  FileManager+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/1/19.
//

import Cocoa

public struct ApplicationDirectory {
    
    public var current: String {
        let dundleName = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first ?? ""
        return "/" + dundleName + "/"
    }
}


//MARK: - Application Support 沙盒目录
public struct SupportDirectory: AppDirectoryProtocol {
    
    public var current: String {
        let dundleName = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first ?? ""
        return "/" + dundleName + "/"
    }

    public var subPath: AppDirectoryProtocol {
        return SupportDirectory()
    }
}

/// 以下文件目录是按实际目录层级来定的，一个目录层一个枚举表示，
/// 目录的有多个子层级就用枚举套枚举的方式表示
public struct AppOwnerDirectory {
    
    static let application = ApplicationDirectory()
    static let support = SupportDirectory()
}

public protocol AppDirectoryProtocol {
    
    var current: String { get }
    var subPath: AppDirectoryProtocol { get }
}

public protocol  AppDirectoryProtocol2 {
    
    var current: String { get }
    var fullPath: String { get set }
    mutating func `init`(_ directory: AppDirectoryProtocol2?)
    mutating func append(_ directory: AppDirectoryProtocol2) -> AppDirectoryProtocol2
    
}

public protocol  AppDirectoryProtocol3 {
    
    var current: String { get }
    var fullPath: String { get set }
    mutating func append(_ directory: AppDirectoryProtocol3) -> AppDirectoryProtocol3
    
}

extension AppDirectoryProtocol3 {
    
    public mutating func append(_ directory: AppDirectoryProtocol3) -> AppDirectoryProtocol3 {
        fullPath = fullPath + "/" + directory.current
        return self
    }
    
}

public enum Directory {
    
    case path(AppDirectoryProtocol2)
    public var path: String {
        switch self {
        case .path(let appDir):
            return appDir.fullPath
        }
    }
    
    public func append(_ directory: AppDirectoryProtocol2) -> Directory {
        switch self {
        case .path(var directory2):
            directory2.fullPath += directory2.fullPath + "/" + directory.current
        }
        return self
    }
    
}

extension AppDirectoryProtocol2 {

    mutating public func `init`(_ directory: AppDirectoryProtocol2?) {
        if let directory = directory {
            fullPath = directory.fullPath + "/" + current
        }
        
        
    }
    
    mutating public func append(_ directory: AppDirectoryProtocol2) -> AppDirectoryProtocol2 {
        fullPath = directory.fullPath + "/" + current
        return self
    }
    
}

public let main = AppDirectoryAdapter()
public struct AppDirectoryAdapter: AppDirectoryProtocol2 {
    
    public static let app = AppDirectoryAdapter()
    public var current: String {
        return "AppDirectoryAdapter"
    }
    
    public var fullPath: String = ""

}


public struct SupportDirectory2: AppDirectoryProtocol2 {
    
    public static let support = SupportDirectory2()
    public var current: String {
        return "SupportDirectory2"
    }
    public var fullPath: String = ""
    
}

public struct SupportDirectory3: AppDirectoryProtocol2 {
    
    public static let support = SupportDirectory3()
    public var current: String {
        return "SupportDirectory3"
    }
    public var fullPath: String = ""
    
}

public struct SupportDirectory4: AppDirectoryProtocol3 {
    
    public var current: String {
        return "SupportDirectory3"
    }
    public var fullPath: String = ""

}

public extension FileManager {
    
    class func path22(from searchDirectory: FileManager.SearchPathDirectory, subPath: AppDirectoryProtocol2) -> String {
        
        if let path = NSSearchPathForDirectoriesInDomains(searchDirectory, .userDomainMask, true).first {
            let fullPath = path + "subPath.fullPath"
            return fullPath
        }
        return "subPath.fullPath"
    }
    
    class func path2(from searchDirectory: FileManager.SearchPathDirectory, subPath: Directory) -> String {
        if let path = NSSearchPathForDirectoriesInDomains(searchDirectory, .userDomainMask, true).first {
            let fullPath = path + subPath.path
            return fullPath
        }
        return subPath.path
    }
    /// 获取路径
    /// - Parameters:
    ///   - from: FileManager.SearchPathDirectory
    ///   - subPath: 子目录类型
    /// - Returns: 完整目录
    class func path(from searchDirectory: FileManager.SearchPathDirectory, subPath: SupportDirectory) -> String {
        guard var urlString = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first?.path else {
            return NSHomeDirectory()
        }
//        FileManager.path(from: .applicationSupportDirectory, subPath: .support)
//        urlString = urlString + subPath.rawValue
//        urlString.createDirectory()
        return urlString
    }
    
    class func path(from searchDirectory: FileManager.SearchPathDirectory, subPath: AppOwnerDirectory) -> String {
        if searchDirectory == .applicationDirectory {
            let appPath = Bundle.main.bundlePath + "/Contents"
//            let fullPath = appPath + subPath.rawValue
//            fullPath.createDirectory()
//            return fullPath
            return ""
        }
        
        guard var urlString = FileManager.default.urls(for: searchDirectory, in: .userDomainMask).first?.path else {
            return NSHomeDirectory()
        }
//        urlString = urlString + subPath.rawValue
//        urlString.createDirectory()
//        return urlString
        return ""
    }
    
    /// 创建目录
    /// - Returns: 创建结果：成功/失败
    @discardableResult
    class func createDirectory(path: String) -> Bool {
        var isDir : ObjCBool = true
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        if exists == false {
            do {
                let _ = try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
}
