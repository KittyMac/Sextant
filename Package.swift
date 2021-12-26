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
        .package(url: "https://github.com/KittyMac/Hitch.git", .branch("main")),
        .package(url: "https://github.com/KittyMac/Spanker.git", .branch("main")),
    ],
    targets: [
        .target(
            name: "Sextant",
            dependencies: [
                "Hitch",
                "Spanker"
            ]),
        .testTarget(
            name: "SextantTests",
            dependencies: ["Sextant"]),
    ]
)
