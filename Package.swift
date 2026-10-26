// swift-tools-version: 6.0
import PackageDescription
let package = Package(
    name: "Erebine",
    platforms: [.macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8), .visionOS(.v1)],
    products: [.library(name: "Erebine", targets: ["Erebine"])],
    targets: [.target(name: "Erebine"), .executableTarget(name: "ErebineManagementSmoke", dependencies: ["Erebine"], path: "Examples/ManagementSmoke"), .executableTarget(name: "ErebineLiveSmoke", dependencies: ["Erebine"], path: "Examples/LiveSmoke"), .testTarget(name: "ErebineTests", dependencies: ["Erebine"], resources: [.copy("http_fixture.py")])]
)
