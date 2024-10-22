// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ProgressHUD",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "ProgressHUD",
            targets: ["ProgressHUD"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/JayantBadlani/ScreenShield", from: "1.2.2"),
        .package(url: "https://github.com/swhitty/SwiftDraw", from: "0.18.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.1.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.0.1")
    ],
    targets: [
        .target(
            name: "ProgressHUD",
            dependencies: [
                .product(name: "ScreenShield", package: "ScreenShield"),
                .product(name: "SwiftDraw", package: "SwiftDraw"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "Lottie", package: "lottie-spm"),
                .product(name: "SnapKit", package: "SnapKit"),
            ],
            path: "ProgressHUD/Sources",
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        ),
    ]
)
