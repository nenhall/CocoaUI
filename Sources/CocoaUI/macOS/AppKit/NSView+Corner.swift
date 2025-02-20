//
//  NSView+Corner.swift
//  CocoaUIKit
//
//  Created by nenhall on 2021/10/14.
//

#if os(macOS)
import AppKit

public struct NSRectCorner: OptionSet {
    public var rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static let topLeft = NSRectCorner(rawValue: 1 << 0)
    public static let topRight = NSRectCorner(rawValue: 1 << 1)
    public static let bottomLeft = NSRectCorner(rawValue: 1 << 2)
    public static let bottomRight = NSRectCorner(rawValue: 1 << 3)
    public static let allCorners: NSRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}

public class CoShapeLayer: CAShapeLayer {
    /// 约束依赖的 View 隐藏后，自动往前补位
    public var rectCorner: NSRectCorner?
    
    override public var frame: CGRect {
        didSet {
            if let rectCorner = rectCorner {
                drawCorners(rectCorner, radius: cornerRadius)
            }
        }
    }
    
    public func drawCorners(_ corner: NSRectCorner, radius: CGFloat) {
        let cgPath = CGMutablePath()
        let beginPoint = NSPoint(x: bounds.size.width * 0.5, y: 0)
        cgPath.move(to: beginPoint)
        
        let topLeft = NSPoint(x: 0, y: bounds.size.height)
        let topRight = NSPoint(x: bounds.size.width, y: bounds.size.height)
        let bottomLeft = NSPoint(x: 0, y: 0)
        let bottomRight = NSPoint(x: bounds.size.width, y: 0)

        if corner.contains(.bottomLeft) {
            cgPath.addLine(to: CGPoint(x: radius, y: 0))
            cgPath.addArc(tangent1End: bottomLeft, tangent2End: CGPoint(x: 0, y: 10), radius: radius)
        } else {
            cgPath.addLine(to: bottomLeft)
        }
        
        if corner.contains(.topLeft) {
            cgPath.addLine(to: CGPoint(x: 0, y: bounds.size.height - radius))
            cgPath.addArc(tangent1End: topLeft, tangent2End: CGPoint(x: 10, y: bounds.size.height), radius: radius)
        } else {
            cgPath.addLine(to: topLeft)
        }
        
        if corner.contains(.topRight) {
            cgPath.addLine(to: CGPoint(x: bounds.size.width - radius, y: bounds.size.height))
            cgPath.addArc(tangent1End: topRight, tangent2End: CGPoint(x: bounds.size.width, y: bounds.size.height - radius), radius: radius)
        } else {
            cgPath.addLine(to: topRight)
        }
        
        if corner.contains(.bottomRight) {
            cgPath.addLine(to: CGPoint(x: bounds.size.width, y: radius))
            cgPath.addArc(tangent1End: bottomRight, tangent2End: CGPoint(x: bounds.size.width - radius, y: 0), radius: radius)
        } else {
            cgPath.addLine(to: bottomRight)
        }
        
        path = cgPath
    }
}

extension NSView {
    fileprivate static var kShapeLayer: UInt8 = 0

    /// 约束依赖的 View 隐藏后，自动往前补位
    private var shapeLayer: CoShapeLayer? {
        set {
            objc_setAssociatedObject(self, &NSView.kShapeLayer, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            let shapeLayer = objc_getAssociatedObject(self, &NSView.kShapeLayer)
            return shapeLayer as? CoShapeLayer
        }
    }
    
    /// 设置圆角
    /// - Parameters:
    ///   - corner: 圆角位置
    ///   - radius: 圆角半径
    public func addCorners(_ corner: NSRectCorner, radius: CGFloat) {
        if shapeLayer == nil {
            wantsLayer = true
            let shapeLayer = CoShapeLayer()
            self.shapeLayer = shapeLayer
            shapeLayer.rectCorner = corner
            shapeLayer.cornerRadius = radius
            shapeLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
            shapeLayer.frame = bounds
            layer?.mask = shapeLayer
        } else {
            shapeLayer?.drawCorners(corner, radius: radius)
        }
    }
}

// MARK: - NSView Layout

public extension NSView {
    class func isLayoutFromRightToLeft() -> Bool {
        return NSApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    class func isLayoutFromLeftToRight() -> Bool {
        return NSApplication.shared.userInterfaceLayoutDirection == .leftToRight
    }
    
    /// 当前语言的文字方向
    /// - Returns: NSLocale.LanguageDirection
    class var characterDirection: NSLocale.LanguageDirection {
        let current = NSLocale.current
        guard let code = current.languageCode else { return .leftToRight }
        let direction = NSLocale.characterDirection(forLanguage: code)
        return direction
    }
    
    var characterDirection: NSLocale.LanguageDirection {
        return Self.characterDirection
    }
    
    /// 当前线性排布方向
    /// - Returns: NSLocale.LanguageDirection
    class var lineDirection: NSLocale.LanguageDirection {
        let current = NSLocale.current
        guard let code = current.languageCode else { return .leftToRight }
        let direction = NSLocale.lineDirection(forLanguage: code)
        return direction
    }
}
#endif
