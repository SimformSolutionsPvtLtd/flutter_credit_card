// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "flutter_credit_card",
  platforms: [
    .iOS("12.0")
  ],
  products: [
    .library(name: "flutter-credit-card", targets: ["flutter_credit_card"])
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "flutter_credit_card",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ],
      path: "Sources/flutter_credit_card"
    )
  ]
)
