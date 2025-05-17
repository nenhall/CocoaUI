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
    let hideScrollBar: Bool
    
    public init(url: URL? = nil, data: Data? = nil, hideScrollBar: Bool = false) {
        self.url = url
        self.data = data
        self.hideScrollBar = hideScrollBar
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
        pdfView.enclosingScrollView?.autohidesScrollers = true
        pdfView.enclosingScrollView?.hasVerticalScroller = hideScrollBar
        if hideScrollBar {
            hideScrollBars(in: pdfView)
        }
        pdfView.autoScales = true // 自动缩放
        return pdfView
    }
    
    func hideScrollBars(in pdfView: PDFView) {
        #if os(iOS)
        for subview in pdfView.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
            }
            for subSubview in subview.subviews {
                if let scrollView = subSubview as? UIScrollView {
                    scrollView.showsHorizontalScrollIndicator = false
                    scrollView.showsVerticalScrollIndicator = false
                }
            }
        }
        #else
        // 隐藏滚动条
        if let scrollView = pdfView.enclosingScrollView {
            scrollView.hasHorizontalScroller = false
            scrollView.hasVerticalScroller = false
        }
        pdfView.displaysPageBreaks = false  // 隐藏分页符
        pdfView.displayMode = .singlePage   // 单页模式（禁止滚动）
        #endif
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

