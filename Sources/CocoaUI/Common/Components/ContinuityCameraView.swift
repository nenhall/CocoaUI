//
//  SwiftUIView.swift
//  
//
//  Created by nenhall on 4/11/25.
//

#if os(macOS)
import SwiftUI
import AppKit
import AVFoundation

/// 借助 macOS 10.14 及更高版本和 iOS 12 及更高版本中的“连续互通相机”，
/// 您可以使用 iPhone、iPad 或 iPod touch 扫描文档或拍摄附近物体的照片，然后立即从您的应用中访问这些文档或图片。
@available(macOS 10.15, *)
public struct ContinuityCameraView: NSViewRepresentable {

    public enum OperationType {
        case image(_ image: NSImage)
        case pdf(_ url: Data)
        case unsupported(_ errorString: String)
    }
    
    var onReceive: (_ type: OperationType) -> Void

    public init(onReceive: @escaping (_ type: OperationType) -> Void) {
        self.onReceive = onReceive
    }
    
    public func makeNSView(context: Context) -> CameraResponderView {
        let view = CameraResponderView()
        view.onReceive = onReceive
        return view
    }
    
    public func updateNSView(_ nsView: CameraResponderView, context: Context) {
        nsView.onReceive = onReceive
    }
}

public class CameraResponderView: NSView, NSServicesMenuRequestor {
    var onReceive: ((_ file: ContinuityCameraView.OperationType) -> Void)?
    private var didOpen = false
    private var connectedCatpureDevice: Bool = false
    public override var acceptsFirstResponder: Bool { true }
    
    // MARK: - 响应链核心方法（必须继承自 NSView/NSResponder）
    public override func validRequestor(forSendType sendType: NSPasteboard.PasteboardType?,
                                        returnType: NSPasteboard.PasteboardType?) -> Any? {
        guard let returnType = returnType,
              NSImage.imageTypes.contains(returnType.rawValue) else {
            return super.validRequestor(forSendType: sendType, returnType: returnType)
        }
        return self
    }
    
    // MARK: - 处理图像数据
    public func readSelection(from pasteboard: NSPasteboard) -> Bool {
        if let pdfData = pasteboard.data(forType: .pdf) {
            DispatchQueue.main.async {
                self.onReceive?(.pdf(pdfData))
            }
            return true
        }
        if let image = NSImage(pasteboard: pasteboard) {
            DispatchQueue.main.async {
                self.onReceive?(.image(image))
            }
        }
        return false
    }
    
    // MARK: - 触发菜单显示
    public override func mouseUp(with event: NSEvent) {
        let menu = NSMenu(title: "Camera Menu")
        menu.delegate = self
        NSMenu.popUpContextMenu(menu, with: event, for: self)
        if !didOpen {
            DispatchQueue.main.async {
                if menu.items.count == 0 {
                    self.onReceive?(.unsupported("unsupported"))
                }
            }
        } else {
            didOpen = false
        }
    }
}

extension NSPasteboard.PasteboardType {
    static let pdf = NSPasteboard.PasteboardType("com.adobe.pdf") // 标准 PDF UTI
}

extension CameraResponderView: NSMenuDelegate {
    public func menuNeedsUpdate(_ menu: NSMenu) {
        // 系统自动更新菜单项
        menu.items.removeAll()
    }
    
    public func menuWillOpen(_ menu: NSMenu) {
        didOpen = true
    }
}

#Preview {
    ContinuityCameraView { file in
        
    }
}
#endif
