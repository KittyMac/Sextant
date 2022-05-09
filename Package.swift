// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SextantKit",
    platforms: [
        .macOS(.v10_13), .iOS(.v11)
    ],
    products: [
        .library(name: "SextantKit", targets: ["SextantKit"])
    ],
    dependencies: [
        .package(name: "ChronometerKit", url: "https://github.com/KittyMac/Chronometer.git", .upToNextMinor(from: "0.2.0")),
        .package(name: "HitchKit", url: "https://github.com/KittyMac/Hitch.git", .upToNextMinor(from: "0.5.0")),
        .package(name: "SpankerKit", url: "https://github.com/KittyMac/Spanker.git", .upToNextMinor(from: "0.3.0")),
    ],
    targets: [
        .target(
            name: "SextantKit",
            dependencies: [
                "HitchKit",
                "SpankerKit",
                "ChronometerKit"
            ]),
        .testTarget(
            name: "SextantTests",
            dependencies: ["SextantKit"]),
    ]
)
