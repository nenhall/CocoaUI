//
//  NSLocale+Direction.swift
//  CocoaUI
//
//  Created by nenhall on 2020/12/30.
//  Copyright © 2020 nenhall. All rights reserved.
//

import Cocoa

@objc public extension NSLocale {
    
    /// 当前语言的文字方向
    /// - Returns: NSLocale.LanguageDirection
    @objc class var characterDirection: NSLocale.LanguageDirection  {
        let current = NSLocale.current
        let code = current.languageCode!
        let direction = NSLocale.characterDirection(forLanguage: code)
        return direction
    }
    
    /// 当前线性排布方向
    /// - Returns: NSLocale.LanguageDirection
    @objc class var lineDirection: NSLocale.LanguageDirection {
        let current = NSLocale.current
        let code = current.languageCode!
        let direction = NSLocale.lineDirection(forLanguage: code)
        return direction
    }
    
}
