// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "HydraKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "HydraKit", targets: ["HydraKit"]),
        .library(name: "HydraKitUI", targets: ["HydraKitUI"]),
        .library(name: "HydraKitNavigation", targets: ["HydraKitNavigation"]),
        .library(name: "HydraKitNetwork", targets: ["HydraKitNetwork"]),
        .library(name: "HydraKitOpenAPI", targets: ["HydraKitOpenAPI"]),
        .library(name: "HydraKitStorage", targets: ["HydraKitStorage"]),
        .library(name: "HydraKitDomain", targets: ["HydraKitDomain"]),
        .library(name: "HydraKitRepository", targets: ["HydraKitRepository"]),
        .library(name: "HydraKitMVVM", targets: ["HydraKitMVVM"]),
        .library(name: "HydraKitSecurity", targets: ["HydraKitSecurity"]),
        .library(name: "HydraKitAnalytics", targets: ["HydraKitAnalytics"]),
        .library(name: "HydraKitDev", targets: ["HydraKitDev"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.7.1"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.7.0"),
        .package(url: "https://github.com/apple/swift-http-types", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "HydraKit",
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitUI",
            dependencies: ["HydraKit"],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitNavigation",
            dependencies: ["HydraKit", "HydraKitUI"],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitNetwork",
            dependencies: ["HydraKit"],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitOpenAPI",
            dependencies: [
                "HydraKitNetwork",
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .product(name: "HTTPTypes", package: "swift-http-types")
            ],
            exclude: ["README.md"],
            plugins: [.plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")]
        ),
        .target(
            name: "HydraKitStorage",
            dependencies: ["HydraKit", "HydraKitSecurity"],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitDomain",
            dependencies: ["HydraKit"],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitRepository",
            dependencies: [
                "HydraKitDomain",
                "HydraKitNetwork",
                "HydraKitStorage"
            ],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitMVVM",
            dependencies: ["HydraKit", "HydraKitDomain"],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitSecurity",
            dependencies: ["HydraKit"],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitAnalytics",
            dependencies: ["HydraKit", "HydraKitNetwork"],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitTesting",
            dependencies: [
                "HydraKit",
                "HydraKitDomain",
                "HydraKitNetwork",
                "HydraKitStorage",
                "HydraKitRepository",
                "HydraKitMVVM"
            ],
            exclude: ["README.md"]
        ),
        .target(
            name: "HydraKitDev",
            dependencies: [
                "HydraKit",
                "HydraKitUI",
                "HydraKitNavigation",
                "HydraKitNetwork",
                "HydraKitStorage",
                "HydraKitRepository",
                "HydraKitMVVM",
                "HydraKitAnalytics"
            ],
            exclude: ["README.md"]
        ),
        .testTarget(name: "HydraKitTests", dependencies: ["HydraKit"]),
        .testTarget(name: "HydraKitUITests", dependencies: ["HydraKitUI"]),
        .testTarget(name: "HydraKitNavigationTests", dependencies: ["HydraKitNavigation"]),
        .testTarget(name: "HydraKitNetworkTests", dependencies: ["HydraKitNetwork"]),
        .testTarget(name: "HydraKitOpenAPITests", dependencies: ["HydraKitOpenAPI", "HydraKitNetwork", "HydraKit"]),
        .testTarget(name: "HydraKitStorageTests", dependencies: ["HydraKitStorage"]),
        .testTarget(name: "HydraKitDomainTests", dependencies: ["HydraKitDomain"]),
        .testTarget(name: "HydraKitRepositoryTests", dependencies: ["HydraKitRepository"]),
        .testTarget(name: "HydraKitMVVMTests", dependencies: ["HydraKitMVVM"]),
        .testTarget(name: "HydraKitSecurityTests", dependencies: ["HydraKitSecurity"]),
        .testTarget(name: "HydraKitAnalyticsTests", dependencies: ["HydraKitAnalytics"]),
        .testTarget(name: "HydraKitTestingTests", dependencies: ["HydraKitTesting"]),
        .testTarget(name: "HydraKitDevTests", dependencies: ["HydraKitDev"])
    ]
)
