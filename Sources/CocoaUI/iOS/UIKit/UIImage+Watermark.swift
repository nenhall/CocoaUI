//
//  Image+Watermark.swift
//  CocoaUI
//
//  Created by simy on 2025/5/29.
//
#if os(iOS)
import UIKit
import AVFoundation
import CoreImage

extension UIImage {
    public static func addWatermarkToImage(_ originalImage: UIImage, watermarkText: String) -> UIImage? {
        // 获取原始图片的尺寸
        let imageSize = originalImage.size
        let scale = originalImage.scale
        
        // 创建一个基于原始图片的图形上下文
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        
        // 绘制原始图片
        originalImage.draw(in: CGRect(origin: .zero, size: imageSize))
        
        // 设置水印文字的属性
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor.white.withAlphaComponent(0.7),
            .shadow: {
                let shadow = NSShadow()
                shadow.shadowOffset = CGSize(width: 1, height: 1)
                shadow.shadowColor = UIColor.black.withAlphaComponent(0.5)
                shadow.shadowBlurRadius = 2
                return shadow
            }()
        ]
        
        // 计算水印文字的大小
        let textSize = (watermarkText as NSString).size(withAttributes: textAttributes)
        
        // 计算水印位置（右下角，距离右边和底部各20点）
        let textOrigin = CGPoint(
            x: imageSize.width - textSize.width - 20,
            y: imageSize.height - textSize.height - 20
        )
        
        // 绘制水印文字
        (watermarkText as NSString).draw(at: textOrigin, withAttributes: textAttributes)
        
        // 从图形上下文中获取带水印的图片
        let watermarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 结束图形上下文
        UIGraphicsEndImageContext()
        
        return watermarkedImage
    }
}
#endif
