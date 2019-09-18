// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Lithium",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(name: "Lithium", targets: ["Lithium", "LithiumTests"])
    ],
    dependencies: [
        .package(url: "https://github.com/e-sites/Cobalt.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/e-sites/Dysprosium.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/basvankuijck/CocoaAsyncSocket.git", .branch("master"))
        
    ],
    targets: [
        .target(
            name: "Lithium",
            dependencies: [ "Cobalt", "Dysprosium", "CocoaAsyncSocket" ],
            path: "Sources"
        ),
        .testTarget(
            name: "LithiumTests",
            dependencies: [ "Lithium" ],
            path: "Tests"
        )
    ]
)
