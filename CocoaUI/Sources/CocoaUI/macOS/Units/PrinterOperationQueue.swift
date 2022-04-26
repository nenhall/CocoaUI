//
//  PrinterOperationQueue.swift
//  
//
//  Created by nenhall on 2022/4/26.
//

import AppKit
import Multiplatform
import PDFKit

public extension NSPrintInfo {

    enum PaperSize {
        case a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10
        public var mm: NSSize {
            ///单位转换：毫米 to 磅
            let points = 2.834
            switch self {
            case .a0:  return NSSize(width: 841 * points, height: 1189 * points)
            case .a1:  return NSSize(width: 594 * points, height: 841 * points)
            case .a2:  return NSSize(width: 420 * points, height: 594 * points)
            case .a3:  return NSSize(width: 297 * points, height: 420 * points)
            case .a4:  return NSSize(width: 210 * points, height: 297 * points)
            case .a5:  return NSSize(width: 148 * points, height: 210 * points)
            case .a6:  return NSSize(width: 105 * points, height: 148 * points)
            case .a7:  return NSSize(width: 74 * points, height: 105 * points)
            case .a8:  return NSSize(width: 52 * points, height: 74 * points)
            case .a9:  return NSSize(width: 37 * points, height: 52 * points)
            case .a10: return NSSize(width: 26 * points, height: 37 * points)
            }
        }
    }

}

public extension NSPrintInfo {

    static var defaultProperty: [NSPrintInfo.AttributeKey: Any] {
        var printInfo: [NSPrintInfo.AttributeKey: Any] = [
            .orientation: NSPrintInfo.PaperOrientation.portrait,
            .scalingFactor: 0.9,
            .verticallyCentered: true,
            .horizontallyCentered: true,
            .jobDisposition: NSPrintInfo.JobDisposition.spool,
            .selectionOnly: false,
            .allPages: true,
            .copies: 1,
            .jobSavingFileNameExtensionHidden: true,
            .pagesAcross: 1,
//            .verticalPagination: false,
//            .horizontalPagination: false,
            .paperSize: NSPrintInfo.PaperSize.a4.mm,
            .headerAndFooter: false,
            .topMargin: 0,
            .bottomMargin: 0,
            .leftMargin: 0,
            .rightMargin: 0
        ]
        if let printerName = NSPrintInfo.defaultPrinter?.name {
            printInfo[.printer] = printerName
        }
        return printInfo
    }

    var previewSize: NSSize {
        if paperSize.width * paperSize.height < PaperSize.a4.mm.width * PaperSize.a4.mm.height {
            return NSSize(width: paperSize.width + leftMargin + rightMargin,
                          height: paperSize.height + topMargin + bottomMargin)
        } else {
            return paperSize
        }
    }

}

public class PrinterOperationQueue: NSObject {

    private(set) var progress: Progress?
    private(set) var isSuspended: Bool = false
    private var underlyingQueue: DispatchQueue?
    private(set) var operations: [NSPrintOperation] = []
    private var files: [URL] = []
    let printLayout = NSPageLayout()
    private(set) var printInfoProperty = NSPrintInfo.defaultProperty
    var printInfo: NSPrintInfo?

    public override init() {
        super.init()

    }

    public func addOperation(_ op: NSPrintOperation) {
        operations.append(op)
    }

    public func addOperation(from pdfURLs: [URL]) {
        let printInfo = NSPrintInfo(dictionary: NSPrintInfo.defaultProperty)
        let view = PDFView(frame: NSRect(origin: .zero, size: printInfo.previewSize))
        view.pageShadowsEnabled = false
        view.displaysPageBreaks = false

        for url in pdfURLs {
            view.document = PDFDocument(url: url)
            let printOperation = NSPrintOperation(view: view.documentView!, printInfo: printInfo)
            printOperation.jobTitle = url.lastPathComponent
            printOperation.showsPrintPanel = true
            printOperation.showsProgressPanel = false
            printOperation.printPanel.options = [.showsPreview, .showsCopies, .showsPageRange, .showsPaperSize, .showsOrientation, .showsScaling]
            addOperation(printOperation)
        }
    }

    public func start() {
        operations.forEach({ $0.run() })
    }

    public func preview(for window: NSWindow) {
        guard let opt = operations.first else { return }
        opt.runModal(for: window,
                     delegate: self,
                     didRun: #selector(printerOperationDidRun(_:)),
                     contextInfo: Unmanaged.passUnretained(opt).toOpaque())
    }

    public func cancelAllOperations() {
        operations.forEach({
            $0.destroyContext()
            $0.cleanUp()
        })
        operations.removeAll()
    }

    public func showPrintLayer(modalFor window: NSWindow, accessoryController: NSViewController) {
        printLayout.addAccessoryController(accessoryController)
        printLayout.beginSheet(with: NSPrintInfo(dictionary: printInfoProperty),
                               modalFor: window,
                               delegate: self,
                               didEnd: #selector(printLayoutClose(_:)),
                               contextInfo: Unmanaged.passUnretained(printLayout).toOpaque())
    }

    @objc private func printerOperationDidRun(_ ctx: UnsafeMutableRawPointer?) {
        debugPrint(#function, operations.count)
    }

    @objc private func printLayoutClose(_ ctx: UnsafeMutableRawPointer?) {
        if let printInfo = printLayout.printInfo {
            self.printInfo = printInfo
            operations.forEach { opt in
                opt.printInfo = printInfo
            }
        }
        debugPrint(#function, printLayout.printInfo as Any)
    }

}
