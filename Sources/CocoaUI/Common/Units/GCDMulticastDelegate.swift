//
//  GCDMulticastDelegateNode.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/4/13.
//

import Foundation

class GCDMulticastDelegateNode<Element> {

    weak var delegate: AnyObject!
    var delegateQueue: DispatchQueue!

    init(delegate del: Element, delegateQueue queue: DispatchQueue) {
        delegate = (del as AnyObject)
        delegateQueue = queue
    }

}

class GCDMulticastDelegate <Element> {

    private var delegateNodes = [GCDMulticastDelegateNode<Element>]()

    func add(delegate: Element, queue delegateQueue: DispatchQueue) {
        let node = GCDMulticastDelegateNode(delegate: delegate, delegateQueue: delegateQueue)
        self.synchronized(lockObj: delegateNodes as AnyObject, closure: {
            delegateNodes.append(node)
        })
    }

    func remove(delegate: AnyObject, queue delegateQueue: DispatchQueue? = nil) {
        self.synchronized(lockObj: delegateNodes as AnyObject, closure: {
            for index in (0..<delegateNodes.count).reversed() {
                let nodeDelegate: GCDMulticastDelegateNode = delegateNodes[index]
                if (nodeDelegate.delegate as AnyObject).isEqual(delegate) {
                    if let delegateQueue = delegateQueue {
                        if delegateQueue.isEqual(nodeDelegate.delegateQueue) {
                            delegateNodes.remove(at: index)
                        }
                    } else {
                        delegateNodes.remove(at: index)
                    }
                }
            }
        })
    }

    func removeAllDelegate() {
        synchronized(lockObj: delegateNodes as AnyObject, closure: {
            delegateNodes.removeAll()
        })
        synchronized(lockObj: delegateNodes as AnyObject) {
            delegateNodes.removeAll()
        }
    }

    func count() -> Int {
        return delegateNodes.count
    }

    func countOfClass(_ cls: AnyClass) -> Int {
        var count: Int = 0
        for nodeDelegate in delegateNodes {
            if (nodeDelegate.delegate as AnyObject).isKind(of: cls) {
                count += 1
            }
        }
        return count
    }

    func countOfSelector(_ sel: Selector) -> Int {
        var count: Int = 0
        for nodeDelegate in delegateNodes {
            if (nodeDelegate.delegate as AnyObject).responds(to: sel) {
                count += 1
            }
        }
        return count
    }

    func invoke(_ invocation: @escaping (Element) -> Void, complete: (() -> Void)? = nil) {
        for i in (0..<delegateNodes.count).reversed() {
            let nodeDelegate: GCDMulticastDelegateNode = delegateNodes[i]
            guard let delegate = nodeDelegate.delegate as? Element else {
                delegateNodes.remove(at: i)
                continue
            }
            nodeDelegate.delegateQueue.async {
                invocation(delegate)
            }
        }
        complete?()
    }

    deinit {
        removeAllDelegate()
    }

    private func synchronized(lockObj: AnyObject, closure: () -> Void) {
        objc_sync_enter(lockObj)
        closure()
        objc_sync_exit(lockObj)
    }

}
