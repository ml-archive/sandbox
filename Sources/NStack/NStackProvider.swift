import Vapor
import NStack
public final class NStackProvider: Vapor.Provider {
    
    let nstack: NStack
    
    
    public func boot(_ drop: Droplet) {
        drop.nstack = nstack
    }
    

    public init(drop: Droplet) throws {
        nstack = try NStack(drop: drop)
    }
    
    public init(config: Config) throws {
        nstack = try NStack(drop: drop)
    }
    
    
    // is automatically called directly after boot()
    public func afterInit(_ drop: Droplet) {
    }
    
    // is automatically called directly after afterInit()
    public func beforeRun(_: Droplet) {
    }
    
    public func beforeServe(_: Droplet) {
    }
}
