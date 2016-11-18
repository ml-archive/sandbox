import Vapor

public struct Application{
    // Basic
    let connectionManager: ConnectionMananger
    let applicationConfig: ApplicationConfig
    let nStackConfig: NStackConfig
    
    // Features
    public lazy var translate: Translate = Translate(application: self)
    
    // Keys
    let name: String
    let applicationId: String
    let restKey: String
    let masterKey: String
    
    init(connectionManager: ConnectionMananger, applicationConfig: ApplicationConfig, nStackConfig: NStackConfig){
        self.connectionManager = connectionManager
        self.applicationConfig = applicationConfig
        self.nStackConfig = nStackConfig
        
        self.name = applicationConfig.name
        self.applicationId = applicationConfig.applicationId
        self.restKey = applicationConfig.restKey
        self.masterKey = applicationConfig.masterKey
    }
}


