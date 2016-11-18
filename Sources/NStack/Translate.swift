import Vapor
import Foundation

public final class Translate {
    
    let application: Application
    let defaultPlatform: String
    let defaultLanguage: String
    var translations: [String: Translation] = [:]
    
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
        do {
            // Fetch
            let translation = try fetch(platform: platform, language: language)
            
            // Retrieve value
            var value = translation.get(section: section, key: key)
            
            // Replace
            for(replaceKey, replaceValue) in replace {
                value = value.replacingOccurrences(of: replaceKey, with: replaceValue)
            }
            
            return value

        } catch {
            return Translation.fallback(section: section, key: key)
        }
    }
    
    private final func fetch(platform: String, language: String) throws -> Translation {
        // First try memory
        if let memoryTranslate = freshFromMemory(platform: platform, language: language) {
            return memoryTranslate
        }
        
        
        throw Abort.notFound
    }
    
    private final func freshFromMemory(platform: String, language: String) -> Translation?
    {
        let cacheKey = Translate.cacheKey(platform: platform, language: language)
        
        // Look up in memory
        guard let translation: Translation = translations[cacheKey] else {
            return nil
        }
        
        // If outdated remove
        if translation.isOutdated() {
            
            translations.removeValue(forKey: cacheKey)
            return nil
        }
        
        return translation
        
    }
    
    private static func cacheKey(platform: String, language: String) -> String {
        return platform + "_" + language
    }
    
    
}
