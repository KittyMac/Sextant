// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "Sextant",
    platforms: [
        .macOS(.v10_13), .iOS(.v11)
    ],
    products: [
        .executable(name: "SextantCLI", targets: ["SextantCLI"]),
        .library(name: "Sextant", targets: ["Sextant"]),
    ],
    dependencies: [
        .package(url: "https://github.com/KittyMac/Chronometer.git", from: "0.1.0"),
        .package(url: "https://github.com/KittyMac/Hitch.git", from: "0.4.0"),
        .package(url: "https://github.com/KittyMac/Spanker.git", from: "0.2.36"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "SextantCLI",
            dependencies: [
                "Sextant",
                "Hitch",
                "Spanker",
                "Chronometer",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
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
