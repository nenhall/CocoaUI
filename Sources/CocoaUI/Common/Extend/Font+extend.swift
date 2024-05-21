//
//  Font+extend.swift
//  
//
//  Created by nenhall on 2022/5/18.
//

#if os(iOS)
import UIKit
#else
import Cocoa
#endif

public extension UIFont {

    static let `default` = UIFont.systemFont(ofSize: UIFont.systemFontSize)
}
