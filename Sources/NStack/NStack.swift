import Vapor
import Foundation

public final class NStack {
    
    let drop: Droplet
    let config: Config
    
    public init(drop: Droplet) throws {
        self.drop = drop
        
        guard let config: Config = drop.config["nstack"] else {
            throw Abort.custom(status: .internalServerError, message: "Missing nstack config")
        }
        
        self.config = config
        
    }
    
    
}
