//
//  AppKit+extend.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/4/13.
//

#if os(macOS)
import AppKit
import SwiftUI

public typealias UIImage = NSImage
public typealias UIImageView = NSImageView
public typealias UIView = NSView
public typealias UIColor = NSColor
public typealias CGRect = NSRect
public typealias UIFont = NSFont
public typealias UIViewController = NSViewController
public typealias UIHostingController = NSHostingController
public typealias UIScrollView = NSScrollView
public typealias UITextView = NSTextView
public typealias UIScreen = NSScreen
public typealias UIWindow = NSWindow
public typealias UIEdgeInsets = NSEdgeInsets
public typealias UICollectionView = NSCollectionView
public typealias UICollectionViewCell = NSCollectionViewItem
public typealias UICollectionViewLayout = NSCollectionViewLayout
public typealias UICollectionViewDataSource = NSCollectionViewDataSource
public typealias UICollectionViewFlowLayout = NSCollectionViewFlowLayout
public typealias UICollectionViewDelegateFlowLayout = NSCollectionViewDelegateFlowLayout
public typealias UICollectionViewDelegate = NSCollectionViewDelegate
public typealias UITextField = NSTextField

public let macOSPlatform = true
#else
import UIKit
public let macOSPlatform = false
#endif

public let notify = NotificationCenter.default
