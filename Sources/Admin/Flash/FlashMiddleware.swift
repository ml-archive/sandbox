import Vapor
import HTTP
import Auth

public class FlashMiddleware: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        try FlashHelper.handleRequest(request)
    
        let response = try next.respond(to: request)
        
        try FlashHelper.handleResponse(response, request)
        
        return response
    }
}

