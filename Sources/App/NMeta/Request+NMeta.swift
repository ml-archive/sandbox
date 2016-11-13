import HTTP
import Vapor

extension Request {
    var nMeta: NMeta? {
        get { return storage["nmeta"] as? NMeta }
        set { storage["nmeta"] = newValue }
    }
    
    func isNMetaRequired() throws -> Bool {
        
        return true
    }
    
    func isApi() -> Bool {
        if((storage["forceApi"] as? Bool)?.bool ?? false)  {
            return true
        }
        
        if(headers["Content-Type"]?.contains("application/json") ?? false) {
            return true;
        }
        
        if(self.uri.path.contains("/api")) {
            return true;
        }
        
        return false;
    }
    
    func setAsApi() {
        storage["forceApi"] = true
    }
}
