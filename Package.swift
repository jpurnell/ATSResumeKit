// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ATSResumeKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ATSResumeKit",
            targets: ["ATSResumeKit"]),
    ],
    targets: [
        .target(
            name: "ATSResumeKit",
            dependencies: []),
        .testTarget(
            name: "ATSResumeKitTests",
            dependencies: ["ATSResumeKit"]),
    ]
)
