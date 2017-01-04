import PackageDescription

let package = Package(
    name: "sandbox",
    /*
    targets: [
        Target(name: "AdminPanel"),
        Target(name: "App", dependencies: [
            .Target(name: "AdminPanel")
            ]),
    ],
 */
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 3),
        .Package(url: "https://github.com/vapor/mysql-provider.git", majorVersion: 1, minor: 1),
        .Package(url: "https://github.com/nodes-vapor/meta.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/nodes-vapor/nstack.git", majorVersion: 0, minor: 1),
        //.Package(url: "https://github.com/nodes-vapor/push-urban-airship.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/nodes-vapor/bugsnag.git", majorVersion: 0, minor: 1),
        .Package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver-Vapor.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/redis-provider.git", majorVersion: 1),
        .Package(url:"https://github.com/siemensikkema/vapor-jwt.git", majorVersion: 0, minor: 4),
        //.Package(url: "https://github.com/BrettRToomey/Jobs.git", majorVersion: 0)
        //.Package(url: "https://github.com/nodes-vapor/admin-panel.git", majorVersion: 0),
        .Package(url: "https://github.com/nodes-vapor/admin-panel-nodes-sso.git", majorVersion: 0)
        
        
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

