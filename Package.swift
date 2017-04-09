import PackageDescription

let package = Package(
    name: "SwiftGPIOLibrary",
    dependencies: [
        .Package(url: "https://github.com/uraimo/SwiftyGPIO.git", majorVersion: 0, minor: 8)
    ]
)
