// swift-tools-version:5.0
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
        .package(url: "https://github.com/e-sites/Cobalt.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/e-sites/Dysprosium.git", .upToNextMajor(from: "5.2.1")),
        .package(url: "https://github.com/e-sites/Erbium.git", .upToNextMajor(from: "4.4.1")),
        .package(url: "https://github.com/basvankuijck/CocoaAsyncSocket.git", .upToNextMajor(from: "7.6.4"))
        
    ],
    targets: [
        .target(
            name: "Lithium",
            dependencies: [ "Cobalt", "Dysprosium", "CocoaAsyncSocket", "Erbium" ],
            path: "Sources"
        )
    ]
)
