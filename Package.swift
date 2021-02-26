// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "swift-mutf8",
    products: [
        .library(name: "MUTF8", targets: ["MUTF8"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "MUTF8"),
        .testTarget(name: "MUTF8Tests", dependencies: ["MUTF8"]),
    ]
)
