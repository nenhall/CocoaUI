//
//  Color.swift
//  SwiftExtension
//
//  Created by nenhall on 2022/4/13.
//

import Foundation
#if os(macOS)
import Cocoa
#else
import UIKit
#endif

public extension UIColor {
    static var random: UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }

    /// Convenient method to change alpha value
    func alpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }

    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var sint: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&sint)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (sint >> 8) * 17, (sint >> 4 & 0xF) * 17, (sint & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, sint >> 16, sint >> 8 & 0xFF, sint & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (sint >> 24, sint >> 16 & 0xFF, sint >> 8 & 0xFF, sint & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255,
                  green: CGFloat(green) / 255,
                  blue: CGFloat(blue) / 255,
                  alpha: CGFloat(alpha) / 255)
    }

    convenience init(rgb: Int, alpha: Float = 1) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: CGFloat(alpha))
    }

    /// 浮点数，范围0~255，不是0~1
    convenience init(sameRGB: CGFloat, alpha: Float = 1) {
        let rgb = sameRGB / 255
        self.init(red: rgb, green: rgb, blue: rgb, alpha: CGFloat(alpha))
    }
}

public struct RGBA {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
}


#if os(macOS)
public extension UIColor {
    var rgba: RGBA {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        let color = self.usingColorSpace(.sRGB) ?? self
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }

    var hex: String {
        let rgba = self.rgba
        let red = Int(round(rgba.red * 255))
        let green = Int(round(rgba.green * 255))
        let blue = Int(round(rgba.blue * 255))
        if rgba.alpha == 1 {
            return String(format: "#%02x%02x%02x", red, green, blue)
        } else {
            return String(format: "#%02x%02x%02x%02x", red, green, blue, Int(rgba.alpha * 255))
        }
    }

    var isClear: Bool {
        return self.isRGBEqual(.clear)
    }

    var isNotClear: Bool {
        return !self.isClear
    }

    var isDark: Bool {
        return !self.isLight
    }

    var inverseColor: UIColor {
        let rgba = self.rgba
        return UIColor(red: 1 - rgba.red, green: 1 - rgba.green, blue: 1 - rgba.blue, alpha: rgba.alpha)
    }

    // https://en.wikipedia.org/wiki/Luma_%28video%29
    var isLight: Bool {
        guard let components = self.usingColorSpace(.sRGB)?.cgColor.components, components.count > 2 else { return false }
        let brightness = components[0] * 0.2989 + components[1] * 0.587 + components[2] * 0.114
        return brightness > 0.5
    }

    func isRGBEqual(_ color: UIColor, tolerance: CGFloat = 1.0e-06) -> Bool {
        if self == color {
            return true
        }

        let tolerance = min(1, max(0, tolerance))
        let lColor = self.usingColorSpace(.sRGB) ?? self
        let rColor = color.usingColorSpace(.sRGB) ?? color

        let value = abs(lColor.alphaComponent - rColor.alphaComponent) +
            abs(lColor.greenComponent - rColor.greenComponent) +
            abs(lColor.blueComponent - rColor.blueComponent) +
            abs(lColor.redComponent - rColor.redComponent)
        return value < tolerance * 4
    }

    var title: String {
        return self.isClear ? "No Fill".localized() : self.hex.uppercased()
    }

    convenience init(deviceRGB rgb: Int, alpha: Float = 1) {
        self.init(deviceRed: rgb.red, green: rgb.green, blue: rgb.blue, alpha: CGFloat(alpha))
    }
}
#endif

private typealias RGB = Int
private extension RGB {
    var red: CGFloat {
        return CGFloat((self >> 16) & 0xFF) / 255
    }

    var green: CGFloat {
        return CGFloat((self >> 8) & 0xFF) / 255
    }

    var blue: CGFloat {
        return CGFloat(self & 0xFF) / 255
    }
}
