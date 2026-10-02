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
        .package(name: "HydraKit", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "NetworkExample",
            dependencies: [
                .product(name: "HydraKitNetwork", package: "HydraKit")
            ]
        )
    ]
)
