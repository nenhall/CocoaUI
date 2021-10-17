// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CocoaUIKit",
    platforms: [
        .macOS(.v10_14),
    ],
    products: [
        .library(name: "CocoaUIKit", targets: ["CocoaUIKit"]),
        .library(name: "CocoaUIKit-Dynamic", type: .dynamic, targets: ["CocoaUIKit"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "CocoaUIKit",
            dependencies: [],
            path:"",
            exclude: ["Example",
                      "docs",
                      "CocoaUIKit",
                      "CocoaUIKit.podspec",
                      "CocoaUIKit.xcodeproj",
                      "CocoaUIKit.xcworkspace"]),
        //.testTarget(
//            name: "CocoaUIKitTests",
//            dependencies: ["CocoaUIKit"],
//            path: "Tests"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
