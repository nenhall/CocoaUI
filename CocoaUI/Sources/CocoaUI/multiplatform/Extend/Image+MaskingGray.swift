//
//  Image+MaskingGray.swift
//  ColorTransform
//
//  Created by nenhall on 2022/4/2.
//

#if os(macOS)
import AppKit
#else
import UIKit
import Photos
#endif
import CoreGraphics

public extension UIImage.GrayRGB {

    static let defultMasking: [CGFloat] = [150, 255, 150, 255, 150, 255]
}

public extension UIImage {

    struct RGBComponent {
        var red   = 0.299
        var green = 0.587
        var blue  = 0.114
    }

    enum GrayRGB {
        case hifi(_ rgbc: RGBComponent)
        case masking(_ colors: [CGFloat]) // [min...max, min...max,...]
    }

    private func makeImage(from cgImage: CGImage, size: CGSize? = nil) -> UIImage {
        #if os(macOS)
        return NSImage(cgImage: cgImage, size: size ?? self.size)
        #else
        return UIImage(cgImage: cgImage)
        #endif
    }

    private var data: Data? {
        #if os(macOS)
        return tiffRepresentation
        #else
        return pngData() ?? jpegData(compressionQuality: 1)
        #endif
    }

    func grayImage() -> UIImage? {
        guard let sourceData = data else { return nil }
        guard let source = CGImageSourceCreateWithData(sourceData as CFData, nil) else { return nil }
        guard let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else { return nil }

        let width = Int(cgImage.width)
        let height = Int(cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()

        let bitInfo = CGImageAlphaInfo.none.rawValue
        guard let context = CGContext.init(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitInfo) else { return nil }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        if let newCgImage = context.makeImage() {
            return makeImage(from: newCgImage)
        }
        return nil
    }

    static func maskingImageBackground(_ image: UIImage, grayRGB: GrayRGB = .masking(GrayRGB.defultMasking)) -> UIImage? {
        return image.maskingImageBackground(grayRGB: grayRGB)
    }

    func maskingImageBackground(grayRGB: GrayRGB = .masking(GrayRGB.defultMasking)) -> UIImage? {
        switch grayRGB {
        case .hifi(let rGBComponent):
            return hifiPixelColor(component: rGBComponent)
        case .masking(let colors):
            return maskingImageBackground(colors)
        }
    }

    private func maskingImageBackground(_ colors: [CGFloat]) -> UIImage? {
        #if os(macOS)
        guard let sourceData = data else { return nil }
        guard let source = CGImageSourceCreateWithData(sourceData as CFData, nil) else { return nil }
        guard let sourceCgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else { return nil }

        let width      = Int(sourceCgImage.width)
        let height     = Int(sourceCgImage.height)
        let bpc        = sourceCgImage.bitsPerComponent
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        guard let context = CGContext.init(data: nil,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: bpc,
                                           bytesPerRow: 0,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo) else { return nil }
        context.draw(sourceCgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let cgImage = context.makeImage() else { return nil }
        guard let maskCgImage = cgImage.copy(maskingColorComponents: colors) else {
            debugPrint("make masking image failed!")
            return nil
        }

        bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        guard let alphaContext = CGContext.init(data: nil,
                                                width: width,
                                                height: height,
                                                bitsPerComponent: 8,
                                                bytesPerRow: 0,
                                                space: colorSpace,
                                                bitmapInfo: bitmapInfo) else { return nil }
        alphaContext.draw(maskCgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        guard let alphaCgImage = alphaContext.makeImage() else { return nil }
        let image = NSImage(cgImage: alphaCgImage, size: NSSize(width: width, height: height))
        saveImage(image)
        return image

        #else
        UIGraphicsBeginImageContextWithOptions(size, true, 2)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let noAlphaImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let noAlphaCGRef = noAlphaImage?.cgImage
        guard let imgRefCopy = noAlphaCGRef?.copy(maskingColorComponents: colors) else { return nil }

        UIGraphicsBeginImageContext(size)
        let maskingImage = UIImage(cgImage: imgRefCopy)
        maskingImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let alphaImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

//        if let image = alphaImage {
//            saveImage(image)
//        }
        return alphaImage
        #endif
    }

    private func saveImage(_ image: UIImage) {
        let urls = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        guard var url = urls.first else { return }
        url.appendPathComponent("PDFSign.png")

        #if os(macOS)
        guard let data = image.tiffRepresentation else { return }
        guard let imageRep = NSBitmapImageRep(data: data) else { return }
        let imageProps = [NSBitmapImageRep.PropertyKey.compressionFactor: NSNumber(value: 1.0)]
        guard let newImageData = imageRep.representation(using: .png, properties: imageProps) else { return }
        do {
            try newImageData.write(to: url, options: .atomic)
        } catch let error {
            debugPrint("saveImage failed: ", error.localizedDescription)
        }
        #elseif targetEnvironment(macCatalyst)
        do {
            try image.pngData()?.write(to: url)
        } catch let error {
            debugPrint("save image:", error.localizedDescription)
        }
        #else
        UIImageWriteToSavedPhotosAlbum(image.toPNG() ?? image, nil, nil, nil)
        #endif
    }

    func hifiPixelColor(component: RGBComponent) -> UIImage? {
        let width = Int(size.width)
        let height = Int(size.height)
        let bytesPerRow = max(width, height) * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let rgbBuffer = malloc(width * height * 4)
        guard let context = CGContext.init(data: rgbBuffer,
                                           width: width,
                                           height: height,
                                           bitsPerComponent: 8,
                                           bytesPerRow: bytesPerRow,
                                           space: colorSpace,
                                           bitmapInfo: bitmapInfo) else { return nil }
        guard let sourceData = data else { return nil }
        guard let source = CGImageSourceCreateWithData(sourceData as CFData, nil) else { return nil }
        guard let sourceCgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else { return nil }
        context.draw(sourceCgImage, in: CGRect(origin: .zero, size: size))

        let opaquePtr = OpaquePointer(rgbBuffer)
        guard let baseAddress = UnsafeMutablePointer<UInt8>(opaquePtr) else { return nil }

        for line in 0..<height {
            for row in 0..<width {
                let pixelIndex = line * width * 4 + row * 4
                let red = baseAddress[pixelIndex]
                let green = baseAddress[pixelIndex + 1]
                let blue = baseAddress[pixelIndex + 2]
                var gray = component.red * Double(red) + component.green * Double(green) + component.blue * Double(blue)
                gray = gray > 150 ? 255 : 0

                baseAddress[pixelIndex] = UInt8(gray)
                baseAddress[pixelIndex + 1] = UInt8(gray)
                baseAddress[pixelIndex + 2] = UInt8(gray)
                baseAddress[pixelIndex + 3] = UInt8(gray) == 255 ? 0 : 255
            }
        }
        guard let alphaCgImage = context.makeImage() else { return nil }
        rgbBuffer?.deallocate()
        let image = makeImage(from: alphaCgImage)
//        saveImage(image)
        return image
    }
}

public extension UIImageView {

    @discardableResult
    func grayImageBackground() -> Bool {
        guard let image = image else { return false }
        let newImage = image.grayImage()
        self.image = newImage
        return true
    }

    @discardableResult
    func maskingImageBackground(grayRGB: UIImage.GrayRGB = .masking(UIImage.GrayRGB.defultMasking)) -> Bool {
        guard let image = image else { return false }
        let newImage = image.maskingImageBackground(grayRGB: grayRGB)
        self.image = newImage
        return true
    }
}

#if os(iOS)

public extension UIImage {

    func toPNG() -> UIImage? {
        guard let imageData = pngData() else { return nil }
        guard let imagePng = UIImage(data: imageData) else { return nil }
        return imagePng
    }

    func format() {
        guard let imageData = pngData() else { return }
        debugPrint(imageData.count)
    }
}

// MARK: - PHPhotoLibrary+SaveImage

public extension PHPhotoLibrary {

    func savePhoto(image: UIImage, albumName: String, completion: ((PHAsset?) -> Void)? = nil) {
        func save() {
            if let album = PHPhotoLibrary.shared().findAlbum(albumName: albumName) {
                PHPhotoLibrary.shared().saveImage(image: image, album: album, completion: completion)
            } else {
                PHPhotoLibrary.shared().createAlbum(albumName: albumName, completion: { (collection) in
                    if let collection = collection {
                        PHPhotoLibrary.shared().saveImage(image: image, album: collection, completion: completion)
                    } else {
                        completion?(nil)
                    }
                })
            }
        }

        if PHPhotoLibrary.authorizationStatus() == .authorized {
            save()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    save()
                }
            })
        }
    }

    // MARK: - Private
    private func findAlbum(albumName: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        guard let photoAlbum = fetchResult.firstObject else {
            return nil
        }
        return photoAlbum
    }

    private func createAlbum(albumName: String, completion: @escaping (PHAssetCollection?) -> Void) {
        var albumPlaceholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { (success, _) in
            if success {
                guard let placeholder = albumPlaceholder else {
                    completion(nil)
                    return
                }
                let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                guard let album = fetchResult.firstObject else {
                    completion(nil)
                    return
                }
                completion(album)
            } else {
                completion(nil)
            }
        })
    }

    private func saveImage(image: UIImage, album: PHAssetCollection, completion: ((PHAsset?) -> Void)? = nil) {
        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
            placeholder = photoPlaceholder
            let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
            albumChangeRequest.addAssets(fastEnumeration)
        }, completionHandler: { success, _ in
            guard let placeholder = placeholder else {
                completion?(nil)
                return
            }
            if success {
                let assets = PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                let asset = assets.firstObject
                completion?(asset)
            } else {
                completion?(nil)
            }
        })
    }
}

#endif
