import Foundation
import Vapor
import Auth
import HTTP
import Turnstile
import TurnstileCrypto
import TurnstileWeb

public final class LoginController {
    
    public let drop: Droplet
    
    public init(droplet: Droplet) {
        drop = droplet
    }
    
    public func logout(request: Request) throws -> ResponseRepresentable {
        try request.auth.logout()
        try FlashHelper.addError(request, message: "User is logged out")
        return Response(redirect: "/admin");
    }
    
    public func form(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("Login/form", [
            "flash": try FlashHelper.retrieve(request)
        ])
    }
    
    public func submit(request: Request) throws -> ResponseRepresentable {
        // Get our credentials
        guard let username = request.data["email"]?.string, let password = request.data["password"]?.string else {
            throw Abort.custom(status: Status.badRequest, message: "Missing username or password")
        }
        let credentials = UsernamePassword(username: username, password: password)
    
        do {
            try request.auth.login(credentials)
            
            // Todo deal with remember me
            
            return Response(redirect: "/admin/dashboard");
        } catch _ {
            try FlashHelper.addError(request, message: "Failed to login")
            return Response(redirect: "/admin");
        }
        
    }
}
