//
//  CGSize+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/1/19.
//

import Foundation

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
