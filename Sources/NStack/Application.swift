import Vapor

public final class Application{
    // Basic
    let drop: Droplet
    let connectionManager: ConnectionMananger
    
    // Features
    public lazy var translate: Translate = Translate(application: self)
    
    // Keys
    let name: String
    let applicationId: String
    let restKey: String
    let masterKey: String
    
    init(drop: Droplet, connectionManager: ConnectionMananger, config: Config) throws {
        self.drop = drop
        self.connectionManager = connectionManager
        
        // Set name
        guard let name: String = config["name"]?.string else {
            throw Abort.custom(status: .internalServerError, message: "NStack - Missing name in application init")
        }
        self.name = name;
        
        // Set applicationId
        guard let applicationId: String = config["applicationId"]?.string else {
            throw Abort.custom(status: .internalServerError, message: "NStack - Missing applicationId in application init")
        }
        self.applicationId = applicationId;
        
        // Set restKey
        guard let restKey: String = config["restKey"]?.string else {
            throw Abort.custom(status: .internalServerError, message: "NStack - Missing restKey in application init")
        }
        self.restKey = restKey;
        
        // Set masterKey
        guard let masterKey: String = config["masterKey"]?.string else {
            throw Abort.custom(status: .internalServerError, message: "NStack - Missing masterKey in application init")
        }
        self.masterKey = masterKey;
    }
}


