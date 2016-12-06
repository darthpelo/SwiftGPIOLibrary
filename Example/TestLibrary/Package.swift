import PackageDescription

let package = Package(
    name: "Test",
    dependencies: [
        .Package(url: "https://github.com/darthpelo/SwiftGPIOLibrary.git", majorVersion: 0),
    ]
)
