import Vapor
import Foundation

public final class Translate {
    
    let drop: Droplet
    
    public init(drop: Droplet) throws {
        self.drop = drop
        //self.connectionManager = ConnectionMananger(drop: drop)
        
        /*
        // Set config
        guard let config: Config = drop.config["nstack"] else {
            throw Abort.custom(status: .internalServerError, message: "Missing nstack config")
        }
        
        self.config = config
        
         */
        
        
    }
    
    public func get(platform: String, language: String, section: String, key: String, replace: [String: String]) -> String {
        return ""
    }
}
