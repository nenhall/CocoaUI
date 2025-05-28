//
//  ScrollView+scroll.swift
//  CocoaUI
//
//  Created by simy on 2025/5/28.
//
#if os(iOS)
import UIKit
#else
import AppKit
#endif

public extension UIScrollView {
#if os(iOS)
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(
            x: 0,
            y: max(0, contentSize.height - bounds.height + contentInset.bottom)
        )
        setContentOffset(bottomOffset, animated: animated)
    }
#else
    func scrollToBottom(animated: Bool = false) {
           guard let documentView = documentView else { return }
           let height = documentView.bounds.height
           let contentHeight = contentSize.height
           
           // 计算底部位置（考虑坐标系和可能的翻转）
           let bottomPoint = NSPoint(x: 0, y: max(0, height - contentHeight))
           
           if animated {
               NSAnimationContext.runAnimationGroup { context in
                   context.duration = 0.5
                   contentView.animator().setBoundsOrigin(bottomPoint)
               }
           } else {
               contentView.scroll(to: bottomPoint)
               reflectScrolledClipView(contentView)
           }
       }
#endif
}
