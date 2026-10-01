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
                .product(name: "IronBitCoreKitUI", package: "IronBitCoreKit"),
                .product(name: "IronBitCoreKitMVVM", package: "IronBitCoreKit"),
                .product(name: "IronBitCoreKitRepository", package: "IronBitCoreKit"),
                .product(name: "IronBitCoreKitNavigation", package: "IronBitCoreKit")
            ]
        )
    ]
)
