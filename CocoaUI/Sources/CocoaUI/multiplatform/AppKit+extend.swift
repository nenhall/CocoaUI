//
//  AppKit+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/4/13.
//

import Foundation

#if os(macOS)
import AppKit
public typealias UIImage = NSImage
public typealias UIImageView = NSImageView
#endif

public let Notify = NotificationCenter.default
