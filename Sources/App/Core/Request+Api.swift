import HTTP
import Vapor

extension Request {
    func isApi() -> Bool {
        if((storage["forceApi"] as? Bool)?.bool ?? false)  {
            return true
        }
        
        if(headers["Accept"]?.contains("application/json") ?? false) {
            return true;
        }
        
        if(self.uri.path.contains("/api")) {
            return true;
        }
        
        if(accept.prefers("html")) {
            return false
        }
        
        return true;
    }
    
    func setAsApi() {
        storage["forceApi"] = true
    }
}
