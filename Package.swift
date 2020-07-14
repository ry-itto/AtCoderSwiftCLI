// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AtCoderSwiftCLI",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "atcoder-swift", targets: ["AtCoderSwiftCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/cezheng/Fuzi.git", .upToNextMinor(from: "3.1.2")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0"),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", from: "2.15.1"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "AtCoderSwiftCLI",
            dependencies: [
                .product(name: "Fuzi", package: "Fuzi"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "PathKit", package: "PathKit"),
                .product(name: "XcodeGenKit", package: "XcodeGen"),
                .product(name: "Rainbow", package: "Rainbow"),
            ]),
        .testTarget(
            name: "AtCoderSwiftCLITests",
            dependencies: ["AtCoderSwiftCLI"]),
    ]
)
