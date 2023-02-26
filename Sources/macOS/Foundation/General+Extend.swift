//
//  General+Extend.swift
//  CocoaUI
//
//  Created by nenhall on 2020/12/30.
//  Copyright © 2020 nenhall. All rights reserved.
//

import Foundation


public extension DispatchQueue {
    
    private static var nh_onceToken = [String]()
    struct Cocoa {
        static func oneToken(token: String = "\(#file):\(#function):\(#line)", block: ()->Void) {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            if nh_onceToken.contains(token) { return }
            nh_onceToken.append(token)
            block()
        }
    }
}
