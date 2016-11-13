import Vapor

struct Application{
    let name: String
    let applicationId: String
    let restKey: String
    let masterKey: String
    
    
    public init(config: config) throws {
        self.name = ""
        self.applicationId = ""
        self.restKey = ""
        self.masterKey = ""
    }
}
