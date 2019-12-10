// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Floaty",
    platforms: [.iOS(.v10)],
    products: [.library(name: "Floaty", targets: ["Floaty"])],
    targets: [.target(name: "Floaty", path: "Sources")]
)
