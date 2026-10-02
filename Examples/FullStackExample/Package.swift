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
        .package(name: "HydraKit", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "FullStackExample",
            dependencies: [
                .product(name: "HydraKitUI", package: "HydraKit"),
                .product(name: "HydraKitMVVM", package: "HydraKit"),
                .product(name: "HydraKitRepository", package: "HydraKit"),
                .product(name: "HydraKitNavigation", package: "HydraKit")
            ]
        )
    ]
)
