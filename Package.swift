// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CocoaUI",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "CocoaUI",
            targets: ["CocoaUI", "CocoaLogging"]
        ),
        .library(
            name: "CocoaLogging",
            targets: ["CocoaLogging"]
        ),
    ],
        dependencies: [
            .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "2.0.0"),
    //        .package(url: "https://github.com/realm/SwiftLint.git", revision: "0.39.0")
        ],
    targets: [
        .target(
            name: "CocoaUI",
            path: "Sources/CocoaUI",
            sources: platformSpecificSources(),
            swiftSettings: [
                .unsafeFlags(["-enable-library-evolution"])
            ]
            //            plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
        ),
        .target(
            name: "CocoaLogging",
            dependencies: ["SwiftyBeaver"],
            path: "Sources/CocoaLogging"
//            swiftSettings: [
//                .unsafeFlags(["-enable-library-evolution"])
//            ]
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
        "macOS",
        "iOS"
    ]
}
