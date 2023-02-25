// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SideKit",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11)
    ],
    products: [
        .library(
            name: "SideKit",
            targets: ["SideKit"]),
        .library(
            name: "SideKit-Static",
            type: .static,
            targets: ["SideKit"]),
        .library(
            name: "SideKit-Dynamic",
            type: .dynamic,
            targets: ["SideKit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SideKit",
            dependencies: [],
           linkerSettings: [
                .linkedFramework("UIKit"),
                .linkedFramework("Network")
           ]
         ),
        .testTarget(
            name: "SideKitTests",
            dependencies: ["SideKit"]
        )
    ]
)
