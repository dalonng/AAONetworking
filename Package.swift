// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AAONetworking",
  platforms: [.iOS(.v15), .macOS(.v15)],
  products: [
    .library(
      name: "AAONetworking",
      targets: ["AAONetworking"])
  ],
  targets: [
    .target(
      name: "AAONetworking"),
    .testTarget(
      name: "AAONetworkingTests",
      dependencies: ["AAONetworking"]),
  ])
