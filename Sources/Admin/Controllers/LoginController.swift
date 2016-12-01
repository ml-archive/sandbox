import Vapor
import HTTP

public final class LoginController {
    
    public let drop: Droplet
    
    public init(droplet: Droplet) {
        drop = droplet
    }
    
    public func form(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("Login/form")
    }
    
    public func submit(request: Request) throws -> ResponseRepresentable {
        
        
        return Response(redirect: "/admin/dashboard");
    }
}
