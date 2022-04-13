//
//  NSImage+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/1/19.
//

import AppKit

// MARK: - 获取图片
public extension NSImage {
    
    /// 根据颜色，生成一种图片
    /// - Parameters:
    ///   - size: 图片尺寸大小
    ///   - color: 背景颜色
    ///   - radius: 圆角
    /// - Returns: 返回背景色为color的一张图片
    static func image(size:CGSize, color:NSColor, radius:CGFloat) -> NSImage {
        let image = NSImage(size: NSSize(width: size.width, height: size.height),
                            flipped: true) { (rect) -> Bool in
            let path = NSBezierPath(roundedRect: NSRect(x: 0, y: 0, width: size.width, height: size.height),
                                    xRadius: radius,
                                    yRadius: radius)
            color.setFill()
            path.fill()
            return true
        }
        return image
    }
    
    
    /// 获取cgImage
    var cgImage: CGImage? {
      get {
        guard let imageData = self.tiffRepresentation else { return nil }
        guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
      }
    }
}
