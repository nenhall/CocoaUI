//
//  View+Export.swift
//  LingRealmUI
//
//  Created by dadi on 2024/7/8.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

// UIView 扩展，用于将 UIView 转换为 UIImage
public extension UIView {
    func asImage() -> UIImage? {
#if os(macOS)
        let rect = self.bounds
        let image = NSImage(size: rect.size)
        image.lockFocus()
        self.draw(rect)
        image.unlockFocus()
        try? image.tiffRepresentation?.write(to: URL(fileURLWithPath: "/Users/dadi/Desktop/text.png"))
        return image
#else
        if let scrollView = self as? UIScrollView {
            var viewImage: UIImage? = nil
            UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.isOpaque, 0.0)
            defer {
                UIGraphicsEndImageContext()
            }

            UIGraphicsGetCurrentContext()?.setFillColor(UIColor.red.cgColor)
            let savedContentOffset = scrollView.contentOffset
            let savedFrame = scrollView.frame
            scrollView.contentOffset = .zero
            let color = scrollView.backgroundColor
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                scrollView.backgroundColor = .black
            } else {
                scrollView.backgroundColor = .white
            }
            scrollView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
            scrollView.layer.render(in: UIGraphicsGetCurrentContext()!)
            viewImage = UIGraphicsGetImageFromCurrentImageContext()
            scrollView.contentOffset = savedContentOffset
            scrollView.frame = savedFrame
            scrollView.backgroundColor = color
            return viewImage
        }
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
#endif
    }
}
