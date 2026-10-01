// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "IronBitCoreKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "IronBitCoreKit", targets: ["IronBitCoreKit"]),
        .library(name: "IronBitCoreKitUI", targets: ["IronBitCoreKitUI"]),
        .library(name: "IronBitCoreKitNavigation", targets: ["IronBitCoreKitNavigation"]),
        .library(name: "IronBitCoreKitNetwork", targets: ["IronBitCoreKitNetwork"]),
        .library(name: "IronBitCoreKitStorage", targets: ["IronBitCoreKitStorage"]),
        .library(name: "IronBitCoreKitDomain", targets: ["IronBitCoreKitDomain"]),
        .library(name: "IronBitCoreKitRepository", targets: ["IronBitCoreKitRepository"]),
        .library(name: "IronBitCoreKitMVVM", targets: ["IronBitCoreKitMVVM"]),
        .library(name: "IronBitCoreKitSecurity", targets: ["IronBitCoreKitSecurity"]),
        .library(name: "IronBitCoreKitAnalytics", targets: ["IronBitCoreKitAnalytics"]),
        .library(name: "IronBitCoreKitTesting", targets: ["IronBitCoreKitTesting"]),
        .library(name: "IronBitCoreKitDev", targets: ["IronBitCoreKitDev"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "IronBitCoreKit",
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitUI",
            dependencies: ["IronBitCoreKit"],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitNavigation",
            dependencies: ["IronBitCoreKit", "IronBitCoreKitUI"],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitNetwork",
            dependencies: ["IronBitCoreKit"],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitStorage",
            dependencies: ["IronBitCoreKit", "IronBitCoreKitSecurity"],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitDomain",
            dependencies: ["IronBitCoreKit"],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitRepository",
            dependencies: [
                "IronBitCoreKitDomain",
                "IronBitCoreKitNetwork",
                "IronBitCoreKitStorage"
            ],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitMVVM",
            dependencies: ["IronBitCoreKit", "IronBitCoreKitDomain"],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitSecurity",
            dependencies: ["IronBitCoreKit"],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitAnalytics",
            dependencies: ["IronBitCoreKit", "IronBitCoreKitNetwork"],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitTesting",
            dependencies: [
                "IronBitCoreKit",
                "IronBitCoreKitDomain",
                "IronBitCoreKitNetwork",
                "IronBitCoreKitStorage",
                "IronBitCoreKitRepository",
                "IronBitCoreKitMVVM"
            ],
            exclude: ["README.md"]
        ),
        .target(
            name: "IronBitCoreKitDev",
            dependencies: [
                "IronBitCoreKit",
                "IronBitCoreKitUI",
                "IronBitCoreKitNavigation",
                "IronBitCoreKitNetwork",
                "IronBitCoreKitStorage",
                "IronBitCoreKitRepository",
                "IronBitCoreKitMVVM",
                "IronBitCoreKitAnalytics",
                "IronBitCoreKitTesting"
            ],
            exclude: ["README.md"]
        ),
        .testTarget(name: "IronBitCoreKitTests", dependencies: ["IronBitCoreKit"]),
        .testTarget(name: "IronBitCoreKitUITests", dependencies: ["IronBitCoreKitUI"]),
        .testTarget(name: "IronBitCoreKitNavigationTests", dependencies: ["IronBitCoreKitNavigation"]),
        .testTarget(name: "IronBitCoreKitNetworkTests", dependencies: ["IronBitCoreKitNetwork"]),
        .testTarget(name: "IronBitCoreKitStorageTests", dependencies: ["IronBitCoreKitStorage"]),
        .testTarget(name: "IronBitCoreKitDomainTests", dependencies: ["IronBitCoreKitDomain"]),
        .testTarget(name: "IronBitCoreKitRepositoryTests", dependencies: ["IronBitCoreKitRepository"]),
        .testTarget(name: "IronBitCoreKitMVVMTests", dependencies: ["IronBitCoreKitMVVM"]),
        .testTarget(name: "IronBitCoreKitSecurityTests", dependencies: ["IronBitCoreKitSecurity"]),
        .testTarget(name: "IronBitCoreKitAnalyticsTests", dependencies: ["IronBitCoreKitAnalytics"]),
        .testTarget(name: "IronBitCoreKitTestingTests", dependencies: ["IronBitCoreKitTesting"]),
        .testTarget(name: "IronBitCoreKitDevTests", dependencies: ["IronBitCoreKitDev"])
    ]
)
