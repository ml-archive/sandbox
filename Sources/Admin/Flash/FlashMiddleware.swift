import Vapor
import HTTP
import Auth

public class FlashMiddleware: Middleware {
    public init() {}
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        try FlashHelper.apply(request)
    
        let respond = try next.respond(to: request)
        
        //try print(request.session().data)
       
        return respond
    }
}

