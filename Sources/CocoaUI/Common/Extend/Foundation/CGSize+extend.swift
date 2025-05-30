//
//  File.swift
//  
//
//  Created by dadi on 2024/5/21.
//

import Foundation
import CoreGraphics

public extension CGSize {
    /// width / height, 纵横比 https://en.wikipedia.org/wiki/Aspect_ratio_(image)
    var aspectRatio: CGFloat {
        return width / height
    }
    
    /// 把区域的纵横比改为指定值(只会放大不会缩小)。
    func scaleToFit(_ aspectRatio: CGFloat) -> CGSize {
        guard aspectRatio > 0 && aspectRatio != self.aspectRatio else { return self }
        return CGSize(width: max(width, height * aspectRatio), height: max(height, width / aspectRatio))
    }

    /// 在保持自身纵横比的前提下，获取小于或等于指定尺寸的值(只会缩小不会放大)。
    func scaleAspectFit(_ size: CGSize) -> CGSize {
        if aspectRatio < size.aspectRatio {
            if height > size.height {
                return CGSize(width: size.height * aspectRatio, height: size.height)
            }
        } else {
            if width > size.width {
                return CGSize(width: size.width, height: size.width / aspectRatio)
            }
        }
        return self
    }

    /// 在保持自身纵横比的前提下，获取最大的可容纳于指定尺寸内的值(可能会缩小也可能放大)。
    func scaleAspectUpOrDownFit(_ size: CGSize) -> CGSize {
        return aspectRatio < size.aspectRatio ? CGSize(width: size.height * aspectRatio, height: size.height) : CGSize(width: size.width, height: size.width / aspectRatio)
    }

    /// 在保持自身纵横比的前提下，获取最小的可充满指定尺寸的值。
    func scaleAspectFill(_ size: CGSize) -> CGSize {
        return aspectRatio < size.aspectRatio ? CGSize(width: size.width, height: size.width / aspectRatio) : CGSize(width: size.height * aspectRatio, height: size.height)
    }
}

public extension BinaryFloatingPoint {
    /// 将 iOS 尺寸转换为 macOS 视觉等效尺寸（比例因子 0.76）
    var toMacVisualScale: Self {
        return self * 0.76
    }
    
    /// 自定义比例因子的扩展方法
    func toMacVisualScale(ppiRatio: Self = 0.76) -> Self {
        return self * ppiRatio
    }
}

public extension Int {
    /// 返回浮点结果（避免精度丢失）
    var toMacVisualScale: CGFloat {
        return CGFloat(self) * 0.76
    }
    
    /// 四舍五入返回整数结果
    var toMacVisualScaleRounded: Int {
        return Int(CGFloat(self) * 0.76)
    }
    
    /// 自定义比例因子版本
    func toMacVisualScale(ppiRatio: CGFloat) -> CGFloat {
        return CGFloat(self) * ppiRatio
    }
}

public extension CGSize {
    /// 将 iOS 的 CGSize 转换为 macOS 视觉等效尺寸
    var toMacVisualScale: CGSize {
        return CGSize(
            width: width.toMacVisualScale,
            height: height.toMacVisualScale
        )
    }
}

public extension CGRect {
    /// 将 iOS 的 CGRect 转换为 macOS 视觉等效尺寸
    var toMacVisualScale: CGRect {
        return CGRect(
            origin: origin,
            size: size.toMacVisualScale
        )
    }
}
