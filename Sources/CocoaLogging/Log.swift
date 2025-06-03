//
//  Log.swift
//  AirBrushStudio
//
//  Created by meitu@nenhall on 2022/8/27.
//

import Foundation
import SwiftyBeaver

#if DEBUG
    // func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//    fatalError("🚨请使用 Log.debug()")
    // }
#endif

public enum Logging {
    public enum LogModuleType {
        case none, videoEraser

        var description: String {
            switch self {
            case .none:
                return ""
            case .videoEraser:
                return "[VideoEraser] "
            }
        }
    }

    /// 记录一些通常不重要的东西 (lowest)
    public static func verbose(_ items: Any?..., type: LogModuleType = .none, separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.verbose(type.description + items.toString(separator), file: file, function: function, line: line)
    }

    /// 记录有助于调试的内容 (low)
    public static func debug(_ items: Any?..., type: LogModuleType = .none, separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.debug(type.description + items.toString(separator), file: file, function: function, line: line)
    }

    /// 记录您真正感兴趣但不是问题或错误的内容 (normal)
    public static func info(_ items: Any?..., type: LogModuleType = .none, separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.info(type.description + items.toString(separator), file: file, function: function, line: line)
    }

    /// 记录可能引起麻烦的警告内容 (high)
    public static func warning(_ items: Any?..., type: LogModuleType = .none, separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.warning(type.description + items.toString(separator), file: file, function: function, line: line)
    }

    /// 记录一些会让你在晚上保持清醒的内容 (highest)
    public static func error(_ items: Any?..., type: LogModuleType = .none, separator: String = " ", _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
        log.error(type.description + items.toString(separator), file: file, function: function, line: line)
    }
}

extension Logging {
    private static var log: SwiftyBeaver.Type = {
        #if DEBUG
            let destinations: [BaseDestination] = [file, console]
        #else
            let destinations: [BaseDestination] = [file]
        #endif
        destinations.forEach { SwiftyBeaver.addDestination($0) }
        return SwiftyBeaver.self
    }()

    private static var console: ConsoleDestination = {
        let dest = ConsoleDestination()
        dest.asynchronously = false
        dest.levelString.verbose = "👵🏻" // VERBOSE"
        dest.levelString.debug = "🐛" // DEBUG"
        dest.levelString.info = "ℹ️" // INFO"
        dest.levelString.warning = "⚠️" // WARNING"
        dest.levelString.error = "❌" // ERROR"
        dest.format = "$DHH:mm:ss.SSS$d $L [$N:$l → $F] $M"
        dest.minLevel = .debug
        return dest
    }()

   public static var file: FileDestination = {
        let dest = FileDestination()
        dest.asynchronously = true
        if let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            do {
                let bundleID = Bundle.main.bundleIdentifier ?? "CocoUILog-\(String.random(length: 8))"
//                print("BundleID: \(bundleID)")
                let dirURL = path.appendingPathComponent("\(bundleID)/.Log")
                if !FileManager.default.fileExists(atPath: dirURL.path) {
                    try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
                }
                dest.logFileURL = dirURL.appendingPathComponent("\(today).log")
            } catch {
                print("create log file error：", error.localizedDescription)
            }
        }
        dest.levelColor.verbose = "246m"
        if let path = dest.logFileURL?.path {
            let fileSize = (try? FileManager.default.attributesOfItem(atPath: path))?[.size] as? Int64 ?? 0
            if fileSize > 512 * 1024 {
                _ = dest.deleteLogFile()
            }
        }
        return dest
    }()

    static var today: String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd-HH:mm:ss"
        let today = df.string(from: Date())
        return today
    }
}

private extension Array where Element == Any? {
    func toString(_ separator: String = " ") -> String {
        return map {
            guard let element = $0 else { return "nil" }
            return String(describing: element)
        }.joined(separator: separator)
    }
}

extension String {
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
