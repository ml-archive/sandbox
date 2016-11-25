import Vapor
import HTTP

public final class BugsnagMiddleware: Middleware {
    
    let drop: Droplet
    let configuration: Configuration
    
    public init(drop: Droplet) throws {
        self.drop = drop
        self.configuration = try Configuration(drop: drop)
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        do {
            return try next.respond(to: request)
        } catch {
            print(error)
            throw error
        }
    }
}

