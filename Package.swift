// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PrivacyReportGen",
  platforms: [.macOS(.v14)],
  products: [
    .plugin(name: "PrivacyReport Generate", targets: ["PrivacyReport Generate"])
  ],
  targets: [
    .plugin(
      name: "PrivacyReport Generate",
      capability: .command(
        intent: .custom(
          verb: "generate-privacy-report",
          description: "Generate privacy report from xcarchive"),
        permissions: [
          .writeToPackageDirectory(reason: "Save generated privacy report if needed")
        ]
      )
    ),
    .target(name: "PrivacyReportGen"),
    .testTarget(
      name: "PrivacyReportGenTests",
      dependencies: ["PrivacyReportGen"]
    ),
  ]
)
