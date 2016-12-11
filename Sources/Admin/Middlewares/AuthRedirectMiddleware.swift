import Vapor
import HTTP
import Auth

public class AuthRedirectMiddleware: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        do {
            return try next.respond(to: request)
        } catch AuthError.notAuthenticated {
            try FlashHelper.addError(request, message: "Session expired login again")
            return Response(redirect: "/admin/login");
        }
    }
}

