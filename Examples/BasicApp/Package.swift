// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "BasicApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "BasicApp", targets: ["BasicApp"])
    ],
    dependencies: [
        .package(name: "HydraKit", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "BasicApp",
            dependencies: [
                .product(name: "HydraKitUI", package: "HydraKit")
            ]
        )
    ]
)
