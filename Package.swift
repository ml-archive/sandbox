import PackageDescription

let package = Package(
    name: "sandbox",
    targets: [
        Target(name: "NStack"),
        Target(name: "App", dependencies: [
            .Target(name: "NStack")
            ])
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/nodes-vapor/meta.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/malcommac/SwiftDate.git", majorVersion: 4, minor: 0)
    ],
    exclude: [
        "Config",
        "Database",
        "Localization",
        "Public",
        "Resources",
        "Tests",
    ]
)

