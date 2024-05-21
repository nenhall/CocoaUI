// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CocoaUI",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "CocoaUI",
            targets: ["CocoaUI"]
        ),
    ],
//    dependencies: [
//        .package(url: "https://github.com/realm/SwiftLint.git", revision: "0.39.0")
//    ],
    targets: [
        .target(
            name: "CocoaUI",
            sources: platformSpecificSources()
//            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .testTarget(
            name: "CocoaUITests",
            dependencies: ["CocoaUI"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)

func platformSpecificSources() -> [String] {
    [
        "Common",
        "macOS/AppKit",
        "macOS/Foundation",
        "macOS/Units",
        "iOS"
    ]
}
