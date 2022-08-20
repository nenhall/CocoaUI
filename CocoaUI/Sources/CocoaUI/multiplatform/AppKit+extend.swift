//
//  AppKit+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/4/13.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

#if os(macOS)
import AppKit
public typealias UIImage = NSImage
public typealias UIImageView = NSImageView
public typealias UIView = NSView
public typealias UIColor = NSColor
public typealias CGRect = NSRect
public typealias UIFont = NSFont
public typealias UIViewController = NSViewController

#endif

public let Notify = NotificationCenter.default
