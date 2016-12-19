import HTTP
import Vapor
import Turnstile

public class AdminProtectMiddleware: Middleware {
    
    public init() {
        
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        guard let _ = request.storage["subject"] as? Subject else {
            return Response(redirect: "/admin/login").flash(.error, "Session expired login again");
        }
        
        return try next.respond(to: request)
    }
}
