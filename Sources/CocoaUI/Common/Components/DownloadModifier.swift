//
//  DownloadModifier.swift
//  CocoaUI
//
//  Created by simy on 2025/5/28.
//


import SwiftUI
import CocoaLogging

//private struct MenuItem: View {
//    let action2: () -> Void
//    
//    var body: some View {
//        Button {
//            action2()
//        } label: {
//            Label("下载", systemImage: "square.and.arrow.down")
//        }
//    }
//}

public struct DownloadModifier: ViewModifier {
    let fileName: String
    let image: UIImage
    let onSave: (URL) -> Void
    
    public func body(content: Content) -> some View {
        content.contextMenu(menuItems: {
//            MenuItem(action2: saveImage)
            Text("下载")
                          .onTapGesture {
                              saveImage()
                          }
        })
    }
    
//    @ViewBuilder
//    private func ContextMenuContent() -> some View {
//        Button(action: { saveImage() }) {
//            Label("下载", systemImage: "square.and.arrow.down")
//        }
//    }
    
    private func saveImage() {

    }
}

public class ImageSaver: NSObject {
    public var didFinishSaving: ((_ error: Error?) ->())?
#if os(iOS)
    
    public func writeToPhotoAlbum(image: UIImage,
                                  directoryPath: String = "",
                                  filename: String = "\(Int(Date().timeIntervalSince1970 * 1000))",
                                  message: String = "",
                                  format: UIImage.StorageFormat = .png,
                                  compression factor: CGFloat = 0.8) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            Logging.error("保存到相册失败:", error)
            didFinishSaving?(error)
        } else {
            didFinishSaving?(nil)
        }
    }
#endif

#if os(macOS)
    public func writeToPhotoAlbum(image: UIImage,
                                  directoryPath: String = FileManager.default.homeDirectoryForCurrentUser.path,
                                  filename: String = "\(Int(Date().timeIntervalSince1970 * 1000))",
                                  message: String = "选择保存位置",
                                  format: UIImage.StorageFormat = .png,
                                  compression factor: CGFloat = 0.8) {
        Panel.showSave(directoryPath: directoryPath, name: filename, message: message, modalType: .sheetModel({ url in
            guard let url = url else {
                self.didFinishSaving?(NSError(domain: "保存失败，路径不正确", code: 3311))
                return
            }
            image.save(to: url, with: format, compression: factor)
            self.didFinishSaving?(nil)
        }))
    }
#endif
}
