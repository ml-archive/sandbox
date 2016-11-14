import Vapor
import Foundation

public struct Translation {
    
    let drop: Droplet
    let application: Application
    let json: JSON
    let platform: String
    let language: String
    let date: Date
    
    init(drop: Droplet, application: Application, json: JSON, platform: String, language: String) {
        self.drop = drop
        self.application = application
        self.json = json
        self.platform = platform
        self.language = language
        
        self.date = Date.init()
    }
    
    func isOutdated() -> Bool {
        let minutesToLive = 60
        
        // TODO
        
        return true
    }
 
    
}
