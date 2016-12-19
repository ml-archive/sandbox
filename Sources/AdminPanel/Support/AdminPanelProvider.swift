import Vapor

public final class AdminPanelProvider: Vapor.Provider {
    
    public func boot(_ drop: Droplet) {
        
    }
    
    
    public init(drop: Droplet) throws {
        
    }
    
    public init(config: Config) throws {
        // Don't use this init, it's only there cause of protocol
        throw Abort.serverError
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
