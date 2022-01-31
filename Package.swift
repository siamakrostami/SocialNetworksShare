// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SocialNetworksShare",
    platforms: [.iOS("13")],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SocialNetworksShare",
            targets: ["SocialNetworksShare"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/facebook/facebook-ios-sdk", from: "12.3.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SocialNetworksShare",
            dependencies: [.product(name: "FacebookLogin", package: "facebook-ios-sdk"),
                           .product(name: "FacebookShare", package: "facebook-ios-sdk"),
                           .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                          "TikTokOpenSDK","SCSDKCoreKit","SCSDKCreativeKit"]),
        .binaryTarget(name: "SCSDKCoreKit", path: "Sources/Frameworks/SCSDKCoreKit.xcframework"),
        .binaryTarget(name: "SCSDKCreativeKit", path: "Sources/Frameworks/SCSDKCreativeKit.xcframework"),
        .binaryTarget(name: "TikTokOpenSDK", path: "Sources/Frameworks/TikTokOpenSDK.xcframework"),
        .testTarget(
            name: "SocialNetworksShareTests",
            dependencies: ["SocialNetworksShare"]),
    ]
)
