//
//  PrinterOperationQueue.swift
//  
//
//  Created by nenhall on 2022/4/26.
//

#if os(macOS)
import AppKit
import PDFKit

extension NSPrintInfo {

    enum PaperSize: String {
        // swiftlint:disable:next identifier_name
        case A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10
    }

}

extension NSPrintInfo.PaperSize {

    // swiftlint:disable:next identifier_name
    var mm: NSSize {
        switch self {
        case .A0:  return NSSize(width: 841, height: 1189)
        case .A1:  return NSSize(width: 594, height: 841)
        case .A2:  return NSSize(width: 420, height: 594)
        case .A3:  return NSSize(width: 297, height: 420)
        case .A4:  return NSSize(width: 210, height: 297)
        case .A5:  return NSSize(width: 148, height: 210)
        case .A6:  return NSSize(width: 105, height: 148)
        case .A7:  return NSSize(width: 74, height: 105)
        case .A8:  return NSSize(width: 52, height: 74)
        case .A9:  return NSSize(width: 37, height: 52)
        case .A10: return NSSize(width: 26, height: 37)
        }
    }

    var points: NSSize {
        // 单位转换：毫米 to 磅
        return NSSize(width: mm.width * 2.83464567, height: mm.height * 2.83464567)
    }

    var sizeName: String {
        return "\(rawValue) \(Int(mm.width)) by \(Int(mm.height)) mm"
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
            .paperSize: NSPrintInfo.PaperSize.A4.mm,
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
        if paperSize.width * paperSize.height < PaperSize.A4.mm.width * PaperSize.A4.mm.height {
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
            printOperation.showsPrintPanel = false
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
#endif
