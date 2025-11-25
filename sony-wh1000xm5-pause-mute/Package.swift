// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SonyZoomMute",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "SonyZoomMute",
            targets: ["SonyZoomMute"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SonyZoomMute",
            dependencies: [],
            path: "Sources"
        )
    ]
)
