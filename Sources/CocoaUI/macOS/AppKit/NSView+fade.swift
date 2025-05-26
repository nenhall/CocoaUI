//
//  NSView+fad.swift
//  CocoaUI
//
//  Created by simy on 2025/5/12.
//

#if os(macOS)
import Cocoa
import QuartzCore
import AppKit

public extension CAMediaTimingFunction {
    static let `default`     = CAMediaTimingFunction(name: .default)
    static let linear        = CAMediaTimingFunction(name: .linear)
    static let easeIn        = CAMediaTimingFunction(name: .easeIn)
    static let easeOut       = CAMediaTimingFunction(name: .easeOut)
    static let easeInEaseOut = CAMediaTimingFunction(name: .easeInEaseOut)

}

// MARK: - Animation
public extension NSView {

    static let animationDuration: TimeInterval = 0.3

    class func animate(duration: TimeInterval = NSView.animationDuration, timing: CAMediaTimingFunction = .default, animations: Handler) {
        NSView.animate(duration: duration, timing: timing, animations: animations, completion: nil)
    }

    class func animate(duration: TimeInterval = NSView.animationDuration, timing: CAMediaTimingFunction = .default, animations: Handler, completion: Handler? = nil) {
        NSAnimationContext.runAnimationGroup({ context in
            context.timingFunction = timing
            context.duration = duration
            animations()
        }, completionHandler: completion)
    }

}

// MARK: - Fade in / Fade out
public extension NSView {

    typealias Handler = () -> Void

    func fadeIn(_ duration: TimeInterval = NSView.animationDuration, completion: Handler? = nil) {
        self.fadeIn(duration, animations: {}, completion: completion)
    }

    func fadeIn(_ duration: TimeInterval = NSView.animationDuration, animations: Handler, completion: Handler?) {
        guard isHidden else {
            completion?()
            return
        }

        self.alphaValue = 0
        self.isHidden = false
        NSView.animate(duration: duration, timing: .easeInEaseOut, animations: {
            self.animator().alphaValue = 1
            animations()
        }, completion: completion)
    }

    func fadeOut(_ duration: TimeInterval = NSView.animationDuration, completion: Handler? = nil) {
        self.fadeOut(duration, animations: {}, completion: completion)
    }

    func fadeOut(_ duration: TimeInterval = NSView.animationDuration, animations: Handler, completion: Handler?) {
        guard !isHidden else {
            completion?()
            return
        }

        NSView.animate(duration: duration, timing: .easeInEaseOut, animations: {
            self.animator().alphaValue = 0
            animations()
        }, completion: {
            self.isHidden = true
            completion?()
        })
    }

}
#endif
