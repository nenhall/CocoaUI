//
//  MultipleCollectionBox.swift
//  CocoaUI
//
//  Created by simy on 2025/5/12.
//
#if os(macOS)

import AppKit

class MultipleCollectionBox: CollectionBox {

    /// 布局风格
    /// - grid: 图表
    /// - list: 列表
    enum LayoutStyle: Int {
        case grid
        case list
        case flow
    }

    var itemSize = NSSize(width: 152, height: 216) {
        didSet {
            guard itemSize != oldValue else { return }
            gridLayout.maximumItemSize = itemSize
            gridLayout.minimumItemSize = itemSize
            listLayout.maximumItemSize = itemSize
            listLayout.minimumItemSize = itemSize
            flowLayout.itemSize = itemSize
        }
    }
    lazy var gridLayout: NSCollectionViewGridLayout = {
        let layout = NSCollectionViewGridLayout()
        let columns = maximumNumberOfColumns
        let scrollerWidth = NSScroller.scrollerWidth(for: .mini, scrollerStyle: .overlay)
        let margins = NSEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0 - scrollerWidth)
        layout.maximumItemSize = itemSize
        layout.minimumItemSize = itemSize
        layout.maximumNumberOfColumns = columns
        layout.margins = margins
        if columns != 0 {
            layout.minimumInteritemSpacing = (720.0 - 152 * CGFloat(columns) - margins.left - margins.right - scrollerWidth) / CGFloat(columns - 1)
        } else {
            layout.minimumInteritemSpacing = 20
        }
        layout.minimumLineSpacing = 20.0
        return layout
    }()
    lazy var listLayout: NSCollectionViewGridLayout = {
        let scrollerWidth = NSScroller.scrollerWidth(for: .mini, scrollerStyle: .overlay)
        let layout = NSCollectionViewGridLayout()
        layout.maximumItemSize = NSSize(width: listLayoutItemWidth, height: 56)
        layout.minimumItemSize = NSSize(width: listLayoutItemWidth, height: 56)
        layout.maximumNumberOfColumns = 1
        layout.minimumLineSpacing = 0
        layout.margins = NSEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0 - scrollerWidth)
        return layout
    }()
    lazy var flowLayout: NSCollectionViewFlowLayout = {
        let scrollerWidth = NSScroller.scrollerWidth(for: .mini, scrollerStyle: .overlay)
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = itemSize
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }()
    var maximumNumberOfColumns: Int {
        return 0
    }
    var listLayoutItemWidth: CGFloat {
        return frame.width - 40
    }
    var layoutStyle: LayoutStyle = .grid {
        didSet {
            guard layoutStyle != oldValue else { return }
            updateCollectionViewLayout()
        }
    }
    var collectionLayout: NSCollectionViewLayout {
        switch layoutStyle {
        case .grid:
            return gridLayout
        case .list:
            return listLayout
        case .flow:
            return flowLayout
        }
    }
    var storeStyleKey: String {
        return "CollectionStyleKey"
    }
//    var emptyDataSource: EmptyDataSource? {
//        get {
//            collectionView.emptyDataSource
//        }
//        set {
//            collectionView.emptyDataSource = newValue
//        }
//    }
//    var emptyDataDelegate: EmptyDataDelegate? {
//        get {
//            collectionView.emptyDataDelegate
//        }
//        set {
//            collectionView.emptyDataDelegate = newValue
//        }
//    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        listLayout.minimumItemSize = NSSize(width: listLayoutItemWidth, height: 56)
        listLayout.maximumItemSize = NSSize(width: listLayoutItemWidth, height: 56)
    }

    override func setUpSubviews() {
        super.setUpSubviews()

        layoutStyle = LayoutStyle(rawValue: UserDefaults.standard.integer(forKey: storeStyleKey)) ?? .grid
    }

    private func updateCollectionViewLayout() {
        NSView.animate(duration: 0.3, timing: .linear) { [weak self] in
            guard let self = self else { return }
            self.collectionView.animator().collectionViewLayout = self.collectionLayout
        }
    }

    func scroll(toPoint point: NSPoint) {
        collectionView.animator().scrollToVisible(NSRect(origin: point, size: scrollView.bounds.size))
    }

    var scrollerPosition: NSPoint {
        return scrollView.documentVisibleRect.origin
    }

}
#endif
