import Vapor
import Foundation
import SwiftDate
import Cache

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
        let cacheInMinutes = drop.config["nstack", "translate", "cacheInMinutes"]?.int ?? 60

        print(cacheInMinutes)
        let secondsInMinutes: TimeInterval = Double(cacheInMinutes) * 60
        let dateAtCacheExpiration: Date = Date().addingTimeInterval(-secondsInMinutes)
        
        return dateAtCacheExpiration.isAfter(date: self.date, granularity: .second)
    }
    
    func get(section: String, key: String) -> String {
        do {
            let data: Node = try self.json.extract("data")
            let section: Node = try data.extract(section)
            let key: String = try section.extract(key)
            return key
        } catch  {
            print(error)
            return Translation.fallback(section: section, key: key)
        }
    }
    
    public static func fallback(section: String, key: String) -> String{
        return section + "." + key
    }
    
    func toNode() throws -> Node{
        return Node([
            "language": Node(language),
            "platform": Node(platform),
            "json": json.node
        ])
    }
}
