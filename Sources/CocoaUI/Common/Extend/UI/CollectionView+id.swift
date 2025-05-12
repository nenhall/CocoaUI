//
//  CollectionView+id.swift
//  CocoaUI
//
//  Created by simy on 2025/5/12.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension UICollectionView {
    func register(_ item: UICollectionViewCell.Type) {
#if os(macOS)
        register(item, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: item.identifier))
#else
        register(item, forCellWithReuseIdentifier: item.identifier)
#endif
    }
}

public extension UICollectionViewCell {
#if os(macOS)
    class var identifier: String {
        return NSStringFromClass(self)
    }
#else
    class var identifier: String {
        return NSStringFromClass(self)
    }
#endif
}
