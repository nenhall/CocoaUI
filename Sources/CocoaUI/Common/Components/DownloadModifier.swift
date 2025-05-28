//
//  DownloadModifier.swift
//  CocoaUI
//
//  Created by simy on 2025/5/28.
//


import SwiftUI

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
#if os(iOS)
    public func writeToPhotoAlbum(image: UIImage,
                                  directoryPath: String = FileManager.default.homeDirectoryForCurrentUser.path,
                                  filename: String = "\(Int(Date().timeIntervalSince1970 * 1000))",
                                  message: String = "选择保存位置",
                                  format: UIImage.StorageFormat = .png,
                                  compression factor: CGFloat = 0.8) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            debugPrint("保存到相册失败:", error)
        } else {
            debugPrint("保存成功!")
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
            guard let url = url else { return }
            image.save(to: url, with: format, compression: factor)
        }))
    }
#endif
}
