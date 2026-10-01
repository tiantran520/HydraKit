// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "NetworkExample",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "NetworkExample", targets: ["NetworkExample"])
    ],
    dependencies: [
        .package(path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "NetworkExample",
            dependencies: [
                .product(name: "IronBitCoreKitNetwork", package: "IronBitCoreKit")
            ]
        )
    ]
)
