import Vapor
struct NStackConfig {
    enum ConfigError: String {
        case nstack = "nstack"
        case defaultApplication = "defaultApplication"
        case applications = "applications"
        
        var error: Abort {
            return .custom(status: .internalServerError,
                           message: "NStack error - nstack.\(rawValue) config is missing.")
        }
    }

    let defaultApplication: String
    let translate: TranslateConfig
    let applications: [ApplicationConfig]
    
    init(drop: Droplet) throws {
        // Set config
        let optionalConfig = drop.config["nstack"]
        
        guard let config: Config = optionalConfig else {
            throw ConfigError.nstack.error
        }
        
        // set default application
        guard let defaultApplication: String = drop.config["nstack", "defaultApplication"]?.string else {
            throw ConfigError.defaultApplication.error
        }
        
        self.defaultApplication = defaultApplication
        
        // Set applications
        var applications: [ApplicationConfig] = []
        guard let applicationArr = drop.config["nstack", "applications"]?.array else {
            throw ConfigError.applications.error
        }
        
        try applicationArr.forEach({
            try applications.append(ApplicationConfig(polymorphic: $0))
        })
        
        self.applications = applications
        
        // Set translate
        self.translate = try TranslateConfig(optionalConfig: config["translate"])
    }
}


