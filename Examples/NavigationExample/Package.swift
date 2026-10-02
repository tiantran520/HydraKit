// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "NavigationExample",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "NavigationExample", targets: ["NavigationExample"])
    ],
    dependencies: [
        .package(path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "NavigationExample",
            dependencies: [
                .product(name: "HydraKitNavigation", package: "IronBitCoreKit"),
                .product(name: "HydraKitUI", package: "IronBitCoreKit")
            ]
        )
    ]
)
