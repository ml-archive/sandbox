import Vapor
import Foundation

public final class Translate {
    

    let application: Application
    let defaultPlatform: String
    let defaultLanguage: String
    
    public init(application: Application) {
        self.application = application
    
        self.defaultPlatform = application.drop.config["nstack", "translate", "defaultPlatform"]?.string ?? "backend"
        self.defaultLanguage = application.drop.config["nstack", "translate", "defaultLanguage"]?.string ?? "en-UK"
        
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
