// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "Sextant",
    products: [
        .library(name: "Sextant", targets: ["Sextant"])
    ],
    dependencies: [
        .package(url: "https://github.com/KittyMac/Hitch.git", .branch("main")),
    ],
    targets: [
        .target(
            name: "Sextant",
            dependencies: [
                "Hitch"
            ]),
        .testTarget(
            name: "SextantTests",
            dependencies: ["Sextant"]),
    ]
)
