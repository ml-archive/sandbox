import Vapor
import Foundation
import Cache

public final class Translate {
    
    let application: Application
    let config: TranslateConfig
    let cache: CacheProtocol
    var translations: [String: Translation] = [:]
    
    public init(application: Application) {
        self.application = application
        self.cache = application.cache
        config = application.nStackConfig.translate
    }
    
    public func get(platform: String, language: String, section: String, key: String, replace: [String: String]) -> String {
        do {
            // Fetch
            let translation = try fetch(platform: platform, language: language)
            
            // Retrieve value
            var value = translation.get(section: section, key: key)
            
            // Replace
            for(replaceKey, replaceValue) in replace {
                value = value.replacingOccurrences(of: "{" + replaceKey + "}", with: replaceValue)
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
        
        // Try cache
        if let cacheTranslate = freshFromCache(platform: platform, language: language) {
            return cacheTranslate
        }
        
        // Fetch from API
        let apiTranslate = try application.connectionManager.getTranslation(application: application, platform: platform, language: language)
        // Put in memoery cache
        translations[Translate.cacheKey(platform: platform, language: language)] = apiTranslate
        
        // Put in drop cache
        try cache.set(Translate.cacheKey(platform: platform, language: language), apiTranslate.toNode())
        
        
        return apiTranslate
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
    
    private final func freshFromCache(platform: String, language: String) -> Translation?
    {
        let cacheKey = Translate.cacheKey(platform: platform, language: language)
        do {
                try print(cache.get(cacheKey))
        } catch {
            print(error)
        }
        
        
        return nil
    }
    
    private static func cacheKey(platform: String, language: String) -> String {
        return platform + "_" + language
    }
    
    
}
