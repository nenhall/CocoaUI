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
#if os(macOS)
        Panel.showSave(
            directoryPath: FileManager.default.homeDirectoryForCurrentUser.path,
            name: "\(fileName).png",
            message: "选择保存位置",
            modalType: .sheetModel { url in
                //                    do {
                //                        try image.pngData()?.write(to: url)
                //                        onSave(url)
                //                    } catch {
                //                        debugPrint("保存失败:", error)
                //                    }
            }
        )
#else
        // iOS实现
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: image)
#endif
    }
}

#if os(iOS)
public class ImageSaver: NSObject {
    public func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            debugPrint("保存到相册失败:", error)
        } else {
            debugPrint("保存成功!")
        }
    }
}
#endif
