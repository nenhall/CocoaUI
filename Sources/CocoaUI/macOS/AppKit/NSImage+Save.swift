//
//  File.swift
//  
//
//  Created by dadi on 2024/7/23.
//

#if os(macOS)
import AppKit
import AVFoundation
import CoreImage

public extension NSImage {
    enum StorageFormat: String {
        case png
        case jpeg
        case heic
    }

    @discardableResult
    func save(toPath destinationPath: String, with format: StorageFormat, compression factor: CGFloat = 0.8) -> Result<Void, Error> {
        let destinationURL = URL(fileURLWithPath: destinationPath)
        return save(to: destinationURL, with: format, compression: factor)
    }

    @discardableResult
    func save(to destinationURL: URL, with format: StorageFormat, compression factor: CGFloat = 0.8) -> Result<Void, Error> {
        guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return .failure(NSError(domain: "ImageConversionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Couldn't convert the image."]))
        }

        let properties: [NSBitmapImageRep.PropertyKey: Any] = [
            .compressionFactor: factor,
        ]

        var imageData: Data?
        let bitmapImageRep = NSBitmapImageRep(cgImage: cgImage)

        switch format {
        case .png:
            imageData = bitmapImageRep.representation(using: .png, properties: [:])
        case .jpeg:
            imageData = bitmapImageRep.representation(using: .jpeg, properties: properties)
        case .heic:
            guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, AVFileType.heic.rawValue as CFString, 1, nil) else {
                print("Failed to create image destination")
                return .failure(NSError(domain: "ImageConversionError",
                                        code: -1,
                                        userInfo: [NSLocalizedDescriptionKey: "Failed to create image destination"]))
            }
            let options: NSDictionary = [
                kCGImageDestinationLossyCompressionQuality: 1.0,
                kCGImageDestinationBackgroundColor: NSColor.white.cgColor,
            ]
            CGImageDestinationAddImage(destination, cgImage, options)
            let success = CGImageDestinationFinalize(destination)
            if success {
                return .success(())
            } else {
                print("saveImage failed: ", destinationURL.path)
                return .failure(NSError(domain: "ImageRepresentationError",
                                        code: -2,
                                        userInfo: [NSLocalizedDescriptionKey: "Couldn't create image representation."]))
            }
        }

        guard let finalData = imageData else {
            return .failure(NSError(domain: "ImageRepresentationError",
                                    code: -3,
                                    userInfo: [NSLocalizedDescriptionKey: "Couldn't create image representation."]))
        }

        do {
            try finalData.write(to: destinationURL)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func lockSave(to destinationURL: URL, with format: StorageFormat, compression factor: CGFloat = 0.8) {
        lockFocus()
        let _ = save(to: destinationURL, with: format, compression: factor)
        unlockFocus()
    }
}
#endif
