// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CocoaUI",
    platforms: [.macOS(.v10_14),
                .iOS(.v11)],
    products: [
        .library(
            name: "macOS",
            targets: ["CocoaUIMacOS"]),
        .library(
            name: "iOS",
            targets: ["CocoaUIiOS"])
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Multiplatform",
            dependencies: [],
            path: "Sources/multiplatform"),
        .target(
            name: "CocoaUIMacOS",
            dependencies: ["Multiplatform"],
            path: "Sources/macOS"),
        .target(
            name: "CocoaUIiOS",
            dependencies: ["Multiplatform"],
            path: "Sources/iOS"),
        .testTarget(
            name: "CocoaUITests",
            dependencies: ["CocoaUIMacOS", "CocoaUIiOS"]),
    ],
    swiftLanguageVersions: [.v5]
)
