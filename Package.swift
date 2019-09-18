// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Lithium",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(name: "Lithium", targets: ["Lithium"])
    ],
    dependencies: [
        .package(url: "https://github.com/e-sites/Cobalt.git", .branch("master")),
        .package(url: "https://github.com/e-sites/Dysprosium.git", .upToNextMajor(from: "5.0.0"))
        
    ],
    targets: [
        .target(
            name: "Lithium",
            dependencies: [ "Cobalt", "Dysprosium" ],
            path: "Sources/Lithium"
        )
    ]
)
