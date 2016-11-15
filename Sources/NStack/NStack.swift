import Vapor
import Foundation

public final class NStack {
    
    let drop: Droplet
    public let connectionManager: ConnectionMananger
    let config: NStackConfig
    public let applications: [Application]
    public var application: Application
    var defaultApplication: Application
    
    public init(drop: Droplet) throws {
        self.drop = drop
        self.connectionManager = ConnectionMananger(drop: drop)
        
        self.config = try NStackConfig(drop: drop)
        
        
        // Set applications
        var applications: [Application] = []
        
        config.applications.forEach({
            applications.append(Application(drop: drop, connectionManager: connectionManager, config: $0))
        })
        
        
        self.applications = applications
    
        // Set first application
        guard let app: Application = applications.first else {
            throw Abort.serverError
        }
        
        self.application = app
        self.defaultApplication = app
        
        // Set picked application
        self.defaultApplication = try setApplication(name: config.defaultApplication)
    }
    
    public func setApplication(name: String) throws -> Application {
        for application in applications {
            if(application.name == name) {
                self.application = application
                
                return self.application
            }
        }
        
        throw Abort.custom(status: .internalServerError, message: "NStack - Application \(name) was not found")
    }
    
    public func setApplicationToDefault() -> Application {
        self.application = self.defaultApplication
        
        return application
    }
}
