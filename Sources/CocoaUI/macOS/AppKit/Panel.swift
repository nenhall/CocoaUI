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
    
    @available(macOS 11.0, *)
    public static func showOpen(fileTypes: [UTType]? = nil,
                         title: String? = nil,
                         message: String? = nil,
                         multipleSelection: Bool = false) -> [URL]? {
        return Self.showOpen(fileTypes: fileTypes?.map({ $0.identifier }), title: title, message: message, multipleSelection: multipleSelection)
    }
    
    public static func showOpen(fileTypes: [String]? = nil,
                         title: String? = nil,
                         message: String? = nil,
                         multipleSelection: Bool = false) -> [URL]? {
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
        let response = panel.runModal()
        return response == .OK ? panel.urls : nil
    }
    
    public static func showSave(directoryPath: String, name: String? = nil, message: String? = nil, prompt: String? = nil) -> URL? {
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
        let response = panel.runModal()
        return response == .OK ? panel.url : nil
    }
}
#endif
