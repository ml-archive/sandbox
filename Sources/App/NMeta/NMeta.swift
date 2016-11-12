import Vapor
import Foundation
final class NMeta {
    
    static var instance: NMeta?
    
    let platform: String
    
    static func setInstance(nMeta: String) throws {
        try self.instance = NMeta(nMeta: nMeta)
    }
    
    
    static func getInstance() throws -> NMeta {
    
        guard let unwrappedInstance: NMeta = instance else {
          throw Abort.custom(status: .badRequest, message: "Missing N-Meta header")
        }
        
        return unwrappedInstance
        
    }
    
    
    init(nMeta: String) throws {
        let nMetaArr = nMeta.components(separatedBy: ";")

        
        if(nMetaArr.count < 1 || !NMeta.platforms().contains(nMetaArr[0])) {
            throw Abort.custom(status: .badRequest, message: "Platform is not supported")
        }
        
        self.platform = nMetaArr[0];
        
        print(nMetaArr)
    }
    
    // TODO CONFIG
    static func platforms() -> [String] {
        return [
            "web",
            "android",
            "ios",
            "windows"
        ]
    }
    
    
}
