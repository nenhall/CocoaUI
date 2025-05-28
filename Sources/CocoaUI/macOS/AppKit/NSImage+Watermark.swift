//
//  Image+Watermark.swift
//  CocoaUI
//
//  Created by simy on 2025/5/29.
//
#if os(macOS)
import AppKit

extension NSImage {
    public static func addWatermarkToImage(_ originalImage: NSImage, watermarkText: String) -> NSImage? {
        // 获取原始图片尺寸
        guard let cgImage = originalImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        let imageSize = NSSize(width: cgImage.width, height: cgImage.height)
        
        // 创建一个新图像
        let newImage = NSImage(size: imageSize)
        newImage.lockFocus()
        
        // 绘制原始图片
        originalImage.draw(in: NSRect(origin: .zero, size: imageSize))
        
        // 设置水印文字属性
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: NSColor.white.withAlphaComponent(0.7),
            .shadow: {
                let shadow = NSShadow()
                shadow.shadowOffset = NSSize(width: 1, height: -1) // macOS坐标系Y轴向下
                shadow.shadowColor = NSColor.black.withAlphaComponent(0.5)
                shadow.shadowBlurRadius = 2
                return shadow
            }()
        ]
        
        // 计算文字大小
        let textSize = (watermarkText as NSString).size(withAttributes: textAttributes)
        
        // 计算水印位置（右下角，距离右边和底部各20点）
        let textOrigin = NSPoint(
            x: imageSize.width - textSize.width - 20,
            y: 20 // macOS坐标系Y轴向下，所以底部距离是y值
        )
        
        // 绘制水印文字
        (watermarkText as NSString).draw(at: textOrigin, withAttributes: textAttributes)
        
        newImage.unlockFocus()
        
        return newImage
    }
}

#endif
