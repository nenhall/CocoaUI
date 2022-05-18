//
//  String.swift
//  SwiftExtension
//
//  Created by nenhall on 2022/4/13.
//

import Foundation
import CoreText

public extension String {

    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}

public extension String {

    private static let formatter = NumberFormatter()
    var number: NSNumber? {
        return String.formatter.number(from: self)
    }

    var decimal: Decimal? {
        Decimal(string: self)
    }

    var isNumber: Bool {
        number != nil || decimal != nil
    }

    /// 中文字符范围：0x4e00 ~ 0x9fff
    var isIncludeChinese: Bool {
        return unicodeScalars.contains { 0x4e00 < $0.value && $0.value < 0x9fff }
    }

    func isMatches(regex: String, options: NSRegularExpression.Options = []) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: options)
            let result = regex.firstMatch(in: self, range: NSRange(startIndex..., in: self))
            return result != nil
        } catch {}
        return false
    }

    func count(_ subString: String) -> Int {
        return self.components(separatedBy: subString).count - 1
    }

    func `repeat`(_ count: Int) -> String {
        return String(repeating: self, count: count)
    }

    func transformToPinyin(hasSpace: Bool = false) -> String {
        let stringRef = NSMutableString(string: self) as CFMutableString
        CFStringTransform(stringRef, nil, kCFStringTransformToLatin, false)                // 转换为带音标的拼音
        CFStringTransform(stringRef, nil, kCFStringTransformStripCombiningMarks, false)    // 去掉音标
        let pinyin = stringRef as String
        return hasSpace ? pinyin : pinyin.replacingOccurrences(of: " ", with: "")
    }

    static func randomNumber(length: UInt = 32) -> String {
        guard length > 0 else { return "" }
        var password = ""
        for _ in 0..<length {
            password.append("\(arc4random() % 10)")
        }
        return password
    }
}

// MARK: - Localize
public extension String {

    func localized(tableName: String? = nil, bundle: Bundle = .main, value: String = "", comment: String = "") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: comment)
    }

    func localized(tableName: String? = nil, bundle: Bundle = .main, value: String = "", comment: String = "", _ args: CVarArg...) -> String {
        let localizer = StringResourceUtility.localizer(tableName: tableName, bundle: bundle, value: value, comment: comment)
        let countOfPlaceholder = self.count("%@")
        var mutableArgs = args
        if countOfPlaceholder > args.count {
            mutableArgs.append(contentsOf: Array(repeating: "", count: countOfPlaceholder - args.count))
        }
        return withVaList(mutableArgs) { localizer(self, $0) }
    }

    private class StringResourceUtility {
        static func localizer(tableName: String?, bundle: Bundle, value: String, comment: String) -> (_ key: String, _ args: CVaListPointer) -> String {
            return { (key: String, args: CVaListPointer) in
                let format = NSLocalizedString(key, tableName: tableName, bundle: bundle, value: value, comment: comment)
                return NSString(format: format, arguments: args) as String
            }
        }
    }
}

// MARK: - Rect
public extension String {

    func boundingRect(_ font: UIFont, options: NSString.DrawingOptions = [], attributes: [NSAttributedString.Key: Any]? = nil) -> NSRect {
        return boundingRect(font, size: .zero, options: options, attributes: attributes)
    }

    func boundingRect(_ font: UIFont, width: CGFloat, options: NSString.DrawingOptions = .usesLineFragmentOrigin, attributes: [NSAttributedString.Key: Any]? = nil) -> NSRect {
        let size = NSSize(width: width, height: 0)
        return boundingRect(font, size: size, options: options, attributes: attributes)
    }

    func boundingRect(_ font: UIFont, size: NSSize, options: NSString.DrawingOptions = [], attributes: [NSAttributedString.Key: Any]? = nil) -> NSRect {
        var allAttributes = attributes ?? [:]
        allAttributes[.font] = font
        return boundingRect(with: size, options: options, attributes: allAttributes)
    }

    func boundingRect(options: NSString.DrawingOptions = [], attributes: [NSAttributedString.Key: Any]? = nil) -> NSRect {
        return boundingRect(with: .zero, options: options, attributes: attributes)
    }
}

// MARK: - Path
public extension String {

    /// FileManager.default.fileExists(atPath: path)
    var isFileExisted: Bool {
        return FileManager.default.fileExists(atPath: self)
    }

    private var pathString: NSString {
        return (self as NSString)
    }

    var isReadOnlyPath: Bool {
        var buf: stat = stat()
        if stat(pathString.utf8String, &buf) == 0 {
            return (buf.st_mode & S_IWUSR) == 0
        } else {
            return false
        }
    }

    var isAbsolutePath: Bool {
        return pathString.isAbsolutePath
    }

    var lastPathComponent: String {
        return pathString.lastPathComponent
    }

    var deletingLastPathComponent: String {
        return pathString.deletingLastPathComponent
    }

    var pathExtension: String {
        return pathString.pathExtension
    }

    var deletingPathExtension: String {
        return pathString.deletingPathExtension
    }

    var abbreviatingWithTildeInPath: String {
        return pathString.abbreviatingWithTildeInPath
    }

    var expandingTildeInPath: String {
        return pathString.expandingTildeInPath
    }

    var standardizingPath: String {
        return pathString.standardizingPath
    }

    var resolvingSymlinksInPath: String {
        return pathString.resolvingSymlinksInPath
    }

    func appendingPathComponent(_ str: String) -> String {
        return pathString.appendingPathComponent(str)
    }

    func appendingPathExtension(_ str: String) -> String? {
        return pathString.appendingPathExtension(str)
    }

    func strings(byAppendingPaths paths: [String]) -> [String] {
        return pathString.strings(byAppendingPaths: paths)
    }
}

public extension String {

    func path(with font: UIFont) -> CGPath {
        let path = NSAttributedString(string: self, attributes: [.font: font]).path
        return path
    }
}

public extension NSAttributedString {

    var path: CGPath {
        let path = CGMutablePath()
        // Use CoreText to lay the string out as a line
        let line = CTLineCreateWithAttributedString(self as CFAttributedString)
        // Iterate the runs on the line
        let runArray = CTLineGetGlyphRuns(line)
        let numRuns = CFArrayGetCount(runArray)
        for runIndex in 0..<numRuns {
            // Get the font for this run
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), to: CTRun.self)
            let runAttributes = CTRunGetAttributes(run) as Dictionary
            let runFont = runAttributes[kCTFontAttributeName] as! CTFont // swiftlint:disable:this force_cast

            // Iterate the glyphs in this run
            let numGlyphs = CTRunGetGlyphCount(run)
            for glyphIndex in 0..<numGlyphs {
                let glyphRange = CFRangeMake(glyphIndex, 1)

                var glyph: CGGlyph = 0
                withUnsafeMutablePointer(to: &glyph) {
                    CTRunGetGlyphs(run, glyphRange, $0)
                }

                guard let glyphPath = CTFontCreatePathForGlyph(runFont, glyph, nil) else { continue }

                var position: CGPoint = .zero
                withUnsafeMutablePointer(to: &position) {
                    CTRunGetPositions(run, glyphRange, $0)
                }

                path.addPath(glyphPath, transform: CGAffineTransform(translationX: position.x, y: position.y))
            }
        }
        return path
    }
}
