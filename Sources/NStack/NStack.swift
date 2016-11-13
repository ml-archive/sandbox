import Vapor
import Foundation

public final class NStack {
    
    let drop: Droplet
    public let config: Config
    public let applications: [Application]
    public var application: Application
    
    public init(drop: Droplet) throws {
        self.drop = drop
        
        // Set config
        guard let config: Config = drop.config["nstack"] else {
            throw Abort.custom(status: .internalServerError, message: "Missing nstack config")
        }
        
        self.config = config
        
        // Set applications
        var applications: [Application] = []
        guard let applicationArr = self.config["applications"]?.array else {
            throw Abort.custom(status: .internalServerError, message: "NStack - missing applications config")
        }
        
        try applicationArr.forEach({
            guard let config = $0 as? Config else {
                throw Abort.serverError
            }
            
            try applications.append(Application(config: config))
        })
        
        
        self.applications = applications
    
        // Set first application
        guard let app: Application = applications.first else {
            throw Abort.serverError
        }
        
        self.application = app
        
        // Set picked application
        guard let defaultApplication: String = self.config["defaultApplication"]?.string else {
            throw Abort.custom(status: .internalServerError, message: "NStack - missing defaultApplication config")
        }
        
        try setApplication(name: defaultApplication)
    }
    
    public func setApplication(name: String) throws {
        for application in applications {
            if(application.name == name) {
                self.application = application
                
                return
            }
        }
        
        throw Abort.custom(status: .internalServerError, message: "NStack - Application \(name) was not found")
    }
}
