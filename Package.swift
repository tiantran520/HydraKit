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
        .target(name: "IronBitCoreKit"),
        .target(
            name: "IronBitCoreKitUI",
            dependencies: ["IronBitCoreKit"]
        ),
        .target(
            name: "IronBitCoreKitNavigation",
            dependencies: ["IronBitCoreKit", "IronBitCoreKitUI"]
        ),
        .target(
            name: "IronBitCoreKitNetwork",
            dependencies: ["IronBitCoreKit"]
        ),
        .target(
            name: "IronBitCoreKitStorage",
            dependencies: ["IronBitCoreKit", "IronBitCoreKitSecurity"]
        ),
        .target(
            name: "IronBitCoreKitDomain",
            dependencies: ["IronBitCoreKit"]
        ),
        .target(
            name: "IronBitCoreKitRepository",
            dependencies: [
                "IronBitCoreKitDomain",
                "IronBitCoreKitNetwork",
                "IronBitCoreKitStorage"
            ]
        ),
        .target(
            name: "IronBitCoreKitMVVM",
            dependencies: ["IronBitCoreKit", "IronBitCoreKitDomain"]
        ),
        .target(
            name: "IronBitCoreKitSecurity",
            dependencies: ["IronBitCoreKit"]
        ),
        .target(
            name: "IronBitCoreKitAnalytics",
            dependencies: ["IronBitCoreKit", "IronBitCoreKitNetwork"]
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
            ]
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
            ]
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
