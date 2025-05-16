//
//  SwiftUIView.swift
//  
//
//  Created by nenhall on 5/16/25.
//

import SwiftUI
import PDFKit

// 通用 PDF 视图（支持 iOS/macOS）
public struct PDFViewer: ViewRepresentable {
    public typealias NSViewType = PDFView
    
    let url: URL?
    let data: Data?
    
    public init(url: URL? = nil, data: Data? = nil) {
        self.url = url
        self.data = data
    }
    
    public func makeView(context: Context) -> PDFView {
        let pdfView = PDFView(frame: .zero)
#if os(macOS)
        let autoresizingMask: UIView.AutoresizingMask = [.minXMargin, .minYMargin, .width, .height]
#else
        let autoresizingMask: UIView.AutoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight]
#endif
        pdfView.autoresizingMask = autoresizingMask
        pdfView.translatesAutoresizingMaskIntoConstraints = true
        pdfView.autoScales = true // 自动缩放
        return pdfView
    }
    
    public func updateView(_ uiView: PDFView, context: Context) {
        if let url = url, let document = PDFDocument(url: url) {
            uiView.document = document
        } else if let data = data, let document = PDFDocument(data: data) {
            uiView.document = document
        }
        uiView.autoScales = true // 自动缩放
    }
}

