//
//  TrackAreaTableView.swift
//  CocoaUI
//
//  Created by simy on 2025/5/12.
//

#if os(macOS)
import AppKit

public protocol TrackAreaDelegate: AnyObject {
    func trackAreaMouseMoved(_ trackView: NSView, indexPath: IndexPath?, lastIndex: IndexPath?, point: NSPoint)
}

class TrackAreaTableView: NSTableView {
    
    private(set) var trackArea: NSTrackingArea?
    var options: NSTrackingArea.Options {
        return [.activeInActiveApp, .activeInKeyWindow, .mouseMoved]
    }
    weak var trackDelegate: TrackAreaDelegate?
    
    private(set) var lastIndex: IndexPath?
    private(set) var lastRow: Int?
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackArea = trackArea {
            removeTrackingArea(trackArea)
        }
        
        let trackArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        self.trackArea = trackArea
        addTrackingArea(trackArea)
    }
    
    override func mouseMoved(with event: NSEvent) {
        let location = event.locationInWindow
        let newPoint = convert(location, from: nil)
        let row = self.row(at: newPoint)
        if row == lastRow { return }
        let indexPath = IndexPath(item: row, section: 0)
        var lastIndex: IndexPath?
        if let lRow = lastRow {
            lastIndex = IndexPath(item: lRow, section: 0)
        }
        trackAreaMouseMoved(indexPath: indexPath, lastIndex: lastIndex, point: newPoint)
        trackDelegate?.trackAreaMouseMoved(self, indexPath: indexPath, lastIndex: lastIndex, point: newPoint)
        lastRow = row
        super.mouseMoved(with: event)
    }
    
    func trackAreaMouseMoved(indexPath: IndexPath?, lastIndex: IndexPath?, point: NSPoint) { }
    
}

public class TrackAreaCollectionView: NSCollectionView {
    public weak var trackDelegate: TrackAreaDelegate?
    var options: NSTrackingArea.Options {
        return [.activeInActiveApp, .activeInKeyWindow, .mouseMoved, .mouseEnteredAndExited]
    }
    public var enableTrackArea = false
    private(set) var trackArea: NSTrackingArea?
    private(set) var lastIndex: IndexPath?
    private(set) var lastRow: Int?
    
    public override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackArea = trackArea {
            removeTrackingArea(trackArea)
        }
        guard enableTrackArea else { return }
        let trackArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        self.trackArea = trackArea
        addTrackingArea(trackArea)
    }
    
    public override func mouseMoved(with event: NSEvent) {
        let location = event.locationInWindow
        let newPoint = convert(location, from: nil)
        if let index = indexPathForItem(at: newPoint) {
            if index.section == lastIndex?.section, index.item == lastIndex?.item {
                trackAreaMouseMoved(indexPath: nil, lastIndex: lastIndex, point: newPoint)
                return
            }
            trackAreaMouseMoved(indexPath: index, lastIndex: lastIndex, point: newPoint)
            trackDelegate?.trackAreaMouseMoved(self, indexPath: index, lastIndex: lastIndex, point: newPoint)
            lastIndex = index
        } else {
            trackAreaMouseMoved(indexPath: nil, lastIndex: lastIndex, point: newPoint)
        }
        super.mouseMoved(with: event)
    }
    
    public override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        observerUpdateLastIndexPath()
    }
    
    public override func reloadData() {
        observerUpdateLastIndexPath()
        super.reloadData()
    }
    
    private func observerUpdateLastIndexPath() {
        guard let lastIndex = lastIndex else { return }
        let point = convert(window?.convertPoint(fromScreen: NSEvent.mouseLocation) ?? .zero, from: nil)
        trackAreaMouseMoved(indexPath: nil, lastIndex: lastIndex, point: point)
        trackDelegate?.trackAreaMouseMoved(self, indexPath: nil, lastIndex: lastIndex, point: point)
        self.lastIndex = nil
    }
    
    public func trackAreaMouseMoved(indexPath: IndexPath?, lastIndex: IndexPath?, point: NSPoint) { }
    
}
#endif
