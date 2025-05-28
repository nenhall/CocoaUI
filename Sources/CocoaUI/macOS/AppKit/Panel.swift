//
//  Panel.swift
//  DeveloperBox
//
//  Created by meitu@nenhall on 2022/9/30.
//

#if os(macOS)
import SwiftUI
import UniformTypeIdentifiers

public struct Panel {
    public enum OpenModelType {
        case runModel
        case sheetModel(_ handler: (_ urls: [URL]?) -> Void)
    }
    
    public enum SaveModelType {
        case runModel
        case sheetModel(_ handler: (_ url: URL?) -> Void)
    }
    
    @available(macOS 11.0, *)
    @discardableResult
    public static func showOpen(fileTypes: [UTType]? = nil,
                                title: String? = nil,
                                message: String? = nil,
                                multipleSelection: Bool = false,
                                modalType: OpenModelType = .runModel) -> [URL]? {
        return Self.showOpen(fileTypes: fileTypes?.map({ $0.identifier }), title: title, message: message, multipleSelection: multipleSelection, modalType: modalType)
    }
    
    @discardableResult
    public static func showOpen(fileTypes: [String]? = nil,
                                title: String? = nil,
                                message: String? = nil,
                                multipleSelection: Bool = false,
                                modalType: OpenModelType = .runModel) -> [URL]? {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = fileTypes
        panel.canCreateDirectories = false
        panel.isExtensionHidden = false
        panel.allowsOtherFileTypes = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = multipleSelection
        if let title = title {
            panel.title = title
        }
        if let message = message {
            panel.message = message
        }
        panel.center()
        
        switch modalType {
        case .runModel:
            return panel.runModal() == .OK ? panel.urls : nil
        case .sheetModel(let handler):
            guard let keyWindow = NSApplication.shared.keyWindow ?? NSApplication.shared.mainWindow else {
                handler(nil)
                return nil
            }
            panel.beginSheetModal(for: keyWindow) { response in
                handler(response == .OK ? panel.urls : nil)
            }
        }
        return nil
    }
    
    @discardableResult
    public static func showSave(directoryPath: String, name: String? = nil, message: String? = nil, prompt: String? = nil, modalType: SaveModelType = .runModel) -> URL? {
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        panel.directoryURL = URL(fileURLWithPath: directoryPath)
        if let name = name {
            panel.title = name
            panel.nameFieldStringValue = name
        }
        if let message = message {
            panel.message = message
        }
        if let prompt = prompt {
            panel.prompt = prompt
        }
        panel.center()
        
        switch modalType {
        case .runModel:
            return panel.runModal() == .OK ? panel.url : nil
        case .sheetModel(let handler):
            panel.beginSheetModal(for: NSApplication.shared.keyWindow!) { response in
                handler(response == .OK ? panel.url : nil)
            }
        }
        return nil
    }
}

extension String {
    public func safeFilename(maxLength: Int = 200) -> String {
        // 移除非法字符
        let invalidCharacters = CharacterSet(charactersIn: "/\\?%*|\"<>")
        let cleaned = components(separatedBy: invalidCharacters).joined()
        
        // 截断到最大长度
        return String(cleaned.prefix(maxLength))
    }
}

#endif
