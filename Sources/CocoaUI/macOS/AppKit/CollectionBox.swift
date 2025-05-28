//
//  CollectionBox.swift
//  CocoaUI
//
//  Created by simy on 2025/5/12.
//

#if os(macOS)
import AppKit

open class CollectionBox: CocoaView, TrackAreaDelegate {

    public lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.documentView = collectionView
        scrollView.drawsBackground = false
        scrollView.autohidesScrollers = true
        scrollView.hasVerticalScroller = true
        scrollView.horizontalScrollElasticity = .none
        scrollView.verticalScrollElasticity = .none
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.verticalScroller?.controlSize = .mini
        return scrollView
    }()
    public var basicLayout = NSCollectionViewFlowLayout() {
        didSet {
            collectionView.collectionViewLayout = basicLayout
        }
    }
    public lazy var collectionView: TrackAreaCollectionView = {
        let view = TrackAreaCollectionView(frame: .zero)
        view.isSelectable = true
        view.trackDelegate = self
        view.collectionViewLayout = basicLayout
        view.backgroundColors[0] = NSColor.clear
        return view
    }()
    public weak var dataSource: NSCollectionViewDataSource? {
        get {
            collectionView.dataSource
        }
        set {
            collectionView.dataSource = newValue
        }
    }
    public weak var prefetchDataSource: NSCollectionViewPrefetching? {
        get {
            collectionView.prefetchDataSource
        }
        set {
            collectionView.prefetchDataSource = newValue
        }
    }
    public weak var delegate: NSCollectionViewDelegate? {
        get {
            collectionView.delegate
        }
        set {
            collectionView.delegate = newValue
        }
    }
    
    open func reloadData() {
        collectionView.reloadData()
    }
    
    open func invalidateCollectionViewLayout() {
        collectionView.collectionViewLayout?.invalidateLayout()
    }
    
    open func reloadItems(at indexPaths: Set<IndexPath>) {
        collectionView.reloadItems(at: indexPaths)
    }
    
    open func register(_ item: NSCollectionViewItem.Type) {
        collectionView.register(item, forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: item.identifier))
    }
    
    open func register(_ itemClass: AnyClass?, forItemWithIdentifier identifier: NSUserInterfaceItemIdentifier) {
        collectionView.register(itemClass, forItemWithIdentifier: identifier)
    }
    
    open func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind kind: NSCollectionView.SupplementaryElementKind, withIdentifier identifier: NSUserInterfaceItemIdentifier) {
        collectionView.register(viewClass, forSupplementaryViewOfKind: kind, withIdentifier: identifier)
    }

    required public init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configData()
        setUpSubviews()
    }

    open func configData() {

    }

    open func setUpSubviews() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    open func trackAreaMouseMoved(_ trackView: NSView, indexPath: IndexPath?, lastIndex: IndexPath?, point: NSPoint) {

    }

}

public extension NSScrollView {
    var scrollsToTop: Bool {
        return documentVisibleRect.minY + contentInsets.top <= 0
    }

    var shouldScrollsToBottom: Bool {
        guard let documentView = documentView else {
            return false
        }
        return documentVisibleRect.maxY - contentInsets.bottom >= documentView.bounds.height - 100
    }

    var scrollsToBottom: Bool {
        guard let documentView = documentView else {
            return false
        }
        return documentVisibleRect.maxY - contentInsets.bottom >= documentView.bounds.height
    }
}
#endif
