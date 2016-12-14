import Vapor
import HTTP
import Auth

public class AuthRedirectMiddleware: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        // TODO move
        do {
            try request.storage["user"] = request.auth.user()
        } catch {
            
        }
        
        do {
            return try next.respond(to: request)
        } catch AuthError.notAuthenticated {
            return Response(redirect: "/admin/login").flash(.error, "Session expired login again");
        }
    }
}

