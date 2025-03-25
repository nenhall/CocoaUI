//
//  UIDevice.swift
//
//
//  Created by nenhall on 3/24/25.
//

#if os(iOS)
import Foundation
import UIKit

public extension UIDevice {
    // 判断是否为刘海屏（基于安全区域）
    static var hasNotch: Bool {
        guard let window = UIApplication.shared.windows.first else {
            return false
        }
        // 如果底部安全区域高度 > 0，则认为是刘海屏
        return window.safeAreaInsets.bottom > 0
    }
    
    // 判断是否为刘海屏（基于设备型号）
    static var hasNotchFormModel: Bool {
        let modelName = UIDevice.current.modelName.lowercased()
        // 刘海屏设备列表（iPhone X 及以上）
        let notchModels = [
            "iphone10,3", "iphone10,6", // iPhone X
            "iphone11,2", "iphone11,4", "iphone11,6", // XS/XR/XS Max
            "iphone12,1", "iphone12,3", "iphone12,5", // 11 系列
            "iphone13,1", "iphone13,2", "iphone13,3", "iphone13,4", // 12 系列
            "iphone14,2", "iphone14,3", "iphone14,4", "iphone14,5", // 13 系列
            "iphone14,7", "iphone14,8", "iphone15,2", "iphone15,3" // 14/15 系列
        ]
        return notchModels.contains(modelName)
    }
    
    
    // 获取设备型号的扩展
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
}
#endif
