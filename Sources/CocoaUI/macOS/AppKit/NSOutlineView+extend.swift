//
//  NSOutlineView+Action.swift
//  CocoaUI
//
//  Created by nenhall on 2020/12/30.
//  Copyright © 2020 nenhall. All rights reserved.
//

#if os(macOS)
import Cocoa

extension NSOutlineView {
    
    public func enableClickExpandedOrCollapseItem(_ open: Bool) {
        if open {
            self.action = #selector(clickExpandedOrCollapseItem)
        } else {
            self.action = nil
        }
    }
    
    @objc private func clickExpandedOrCollapseItem() {
        let row = self.selectedRow
        let item = self.item(atRow: row)
        let isExpandable = self.isExpandable(item)
        let isItemExpanded = self.isItemExpanded(item)
        print(isExpandable,isItemExpanded)
        if isItemExpanded {
            self.collapseItem(item, collapseChildren: true)
        } else {
            self.expandItem(item, expandChildren: false)
        }
    }
    
}
#endif
