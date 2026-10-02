// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "FullStackExample",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "FullStackExample", targets: ["FullStackExample"])
    ],
    dependencies: [
        .package(path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "FullStackExample",
            dependencies: [
                .product(name: "HydraKitUI", package: "IronBitCoreKit"),
                .product(name: "HydraKitMVVM", package: "IronBitCoreKit"),
                .product(name: "HydraKitRepository", package: "IronBitCoreKit"),
                .product(name: "HydraKitNavigation", package: "IronBitCoreKit")
            ]
        )
    ]
)
