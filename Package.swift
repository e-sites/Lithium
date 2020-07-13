// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Lithium",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "Lithium", targets: ["Lithium"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", .upToNextMajor(from: "1.3.0"))
        
    ],
    targets: [
        .target(
            name: "Lithium",
            dependencies: [ "Logging" ],
            path: "Sources"
        )
    ]
)
