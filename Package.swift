// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Lithium",
    products: [
        .library(name: "Lithium", targets: ["Lithium"])
    ],
    dependencies: [
        .package(url: "https://github.com/e-sites/Erbium", .branch("master")),
        .package(url: "https://github.com/e-sites/SwiftHEXColors", .branch("master")),
    ],
    targets: [
        .target(
            name: "Lithium",
            dependencies: [
                "Erbium",
                "SwiftHEXColors"
            ],
            path: "Sources/Core"
        )
    ]
)
