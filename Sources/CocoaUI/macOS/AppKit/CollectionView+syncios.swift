//
//  CollectionView.swift
//  CocoaUI
//
//  Created by simy on 2025/5/12.
//

#if os(macOS)
import AppKit

public extension UICollectionView {
    func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        register(cellClass, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier))
    }

    func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), for: indexPath)
    }
}
#endif
