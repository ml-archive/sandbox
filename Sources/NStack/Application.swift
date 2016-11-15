import Vapor

public struct Application{
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
    
    init(drop: Droplet, connectionManager: ConnectionMananger, config: ApplicationConfig){
        self.drop = drop
        self.connectionManager = connectionManager
        self.name = config.name
        self.applicationId = config.applicationId
        self.restKey = config.restKey
        self.masterKey = config.masterKey
    }
}


