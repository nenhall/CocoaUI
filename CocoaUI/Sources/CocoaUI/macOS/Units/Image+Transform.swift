//
//  Image+Transform.swift
//  CocoaUIKit
//
//  Created by nenhall on 2022/3/24.
//

import AppKit
import CoreGraphics

public enum NSImageMirrorOrientation {
    case vertical
    case horizontal
}

public extension NSImage {

    func mirror(_ orientation: NSImageMirrorOrientation) -> NSImage? {
        var transform: CGAffineTransform
        switch orientation {
        case .vertical:
            transform = CGAffineTransform(scaleX: 1, y: -1)
        case .horizontal:
            transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        return makeMirrorImage(transform: transform)
    }

    func transform(_ orientation: CGImagePropertyOrientation) -> NSImage? {
        var transform: CGAffineTransform
        switch orientation {
        case .up: transform = CGAffineTransform(scaleX: -1, y: -1)
        case .down: transform = CGAffineTransform(scaleX: -1, y: -1)
        case .left: transform = CGAffineTransform(rotationAngle: 90.toRadian)
        case .right: transform = CGAffineTransform(scaleX: -1, y: -1)
        case .upMirrored: transform = CGAffineTransform(scaleX: 1, y: -1)
        case .rightMirrored: transform = CGAffineTransform(scaleX: -1, y: 1)
        case .downMirrored: transform = CGAffineTransform(scaleX: 1, y: -1)
        case .leftMirrored: transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        return makeMirrorImage(transform: transform)
    }

    private func makeMirrorImage(transform: CGAffineTransform) -> NSImage? {
        guard let sourceData = tiffRepresentation else { return nil }
        guard let source = CGImageSourceCreateWithData(sourceData as CFData, nil) else { return nil }
        guard let sourceCgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else { return nil }
        let imageRep = NSBitmapImageRep(cgImage: sourceCgImage)
        let hasAlpha = sourceCgImage.alphaInfo != .none

        guard let ciImage = CIImage(bitmapImageRep: imageRep) else { return nil }
        let newCIImage = ciImage.transformed(by: transform)

        let rect = NSRect(origin: .zero, size: newCIImage.extent.size)
        if hasAlpha {
            let imageRep = NSBitmapImageRep(ciImage: newCIImage)
            var newImage: NSImage
            if let data = imageRep.tiffRepresentation, let image = NSImage(data: compressionData(data)) {
                newImage = image
            } else {
                newImage = NSImage(size: size)
                newImage.lockFocus()
                imageRep.draw(in: NSRect(origin: .zero, size: size))
                newImage.unlockFocus()
            }
            return newImage

        } else {
            guard let cgImage = CIContext().createCGImage(newCIImage, from: newCIImage.extent) else { return nil }
            let component = cgImage.bitsPerComponent
            let row = cgImage.bytesPerRow
            let colorSpace = cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
            guard let bitmapContext = CGContext(data: nil,
                                                width: Int(rect.width),
                                                height: Int(rect.height),
                                                bitsPerComponent: component,
                                                bytesPerRow: row,
                                                space: colorSpace,
                                                bitmapInfo: bitmapInfo) else { return nil }

            bitmapContext.draw(cgImage, in: rect)
            guard let decompressedImageRef = bitmapContext.makeImage() else { return nil }
            var finalImage = NSImage(cgImage: decompressedImageRef, size: .zero)
            if let data = finalImage.tiffRepresentation, let image = NSImage(data: compressionData(data)) {
                finalImage = image
            }
            return finalImage
        }
    }

    func compressionData(_ data: Data, save: Bool = false) -> Data {
        guard let imageRep = NSBitmapImageRep(data: data) else { return data }
        let imageProps = [NSBitmapImageRep.PropertyKey.compressionFactor: NSNumber(value: 0.5)]
        guard let newImageData = imageRep.representation(using: .png, properties: imageProps) else { return data }
//        let url = URL(fileURLWithPath: "/Users/ws/Desktop/newImage123.png")
//        try? newImageData.write(to: url, options: .atomic)
        return newImageData
    }

}

public extension NSImageView {

    func mirrorImage(_ orientation: NSImageMirrorOrientation) {
        guard let image = image else { return }
        self.image = image.mirror(orientation)
    }

}


/**
extension NSImage {
    func mirrored() -> NSImage? {
        guard
            let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil),
            let colorSpace = cgImage.colorSpace else {
                return nil
        }

        var format = vImage_CGImageFormat(bitsPerComponent: UInt32(cgImage.bitsPerComponent),
                                          bitsPerPixel: UInt32(cgImage.bitsPerPixel),
                                          colorSpace: Unmanaged.passRetained(colorSpace),
                                          bitmapInfo: cgImage.bitmapInfo,
                                          version: 0,
                                          decode: nil,
                                          renderingIntent: cgImage.renderingIntent)

        var source = vImage_Buffer()
        var result = vImageBuffer_InitWithCGImage(
            &source,
            &format,
            nil,
            cgImage,
            vImage_Flags(kvImageNoFlags))

        guard result == kvImageNoError else { return nil }

        defer { free(source.data) }

        var destination = vImage_Buffer()
        result = vImageBuffer_Init(
            &destination,
            vImagePixelCount(cgImage.height),
            vImagePixelCount(cgImage.width),
            UInt32(cgImage.bitsPerPixel),
            vImage_Flags(kvImageNoFlags))

        guard result == kvImageNoError else { return nil }

        result = vImageHorizontalReflect_ARGB8888(&source, &destination, vImage_Flags(kvImageNoFlags))
        guard result == kvImageNoError else { return nil }

        defer { free(destination.data) }

        return vImageCreateCGImageFromBuffer(&destination, &format, nil, nil, vImage_Flags(kvImageNoFlags), nil).map {
            NSImage(cgImage: $0.takeRetainedValue(), size: size)
        }
    }
}
*/
