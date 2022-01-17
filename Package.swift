// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Sextant",
    platforms: [
        .macOS(.v10_13), .iOS(.v11)
    ],
    products: [
        .library(name: "Sextant", targets: ["Sextant"])
    ],
    dependencies: [
        .package(url: "https://github.com/KittyMac/Chronometer.git", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/KittyMac/Hitch.git", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/KittyMac/Spanker.git", .upToNextMinor(from: "0.1.0")),
    ],
    targets: [
        .target(
            name: "Sextant",
            dependencies: [
                "Hitch",
                "Spanker",
                "Chronometer"
            ]),
        .testTarget(
            name: "SextantTests",
            dependencies: ["Sextant"]),
    ]
)
