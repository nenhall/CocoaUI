//
//  File.swift
//  
//
//  Created by nenhall on 5/16/25.
//

#if os(iOS)
import SwiftUI
import QuickLook
import UIKit

public struct FilePreviewController: UIViewControllerRepresentable {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {
        // 当 URL 变化时刷新预览
        uiViewController.reloadData()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: FilePreviewController
        
        init(_ parent: FilePreviewController) {
            self.parent = parent
        }
        
        public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            1
        }
        
        public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            parent.url as QLPreviewItem
        }
    }
}
#endif
