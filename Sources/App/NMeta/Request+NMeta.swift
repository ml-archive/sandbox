import HTTP
import Vapor

extension Request {
    var nMeta: NMeta? {
        get { return storage["nmeta"] as? NMeta }
        set { storage["nmeta"] = newValue }
    }
    
    func isNMetaRequired() throws -> Bool {
        
        return false;
        if(!self.isApi()) {
            return false;
        }
        
        
        return true;
    }
}
