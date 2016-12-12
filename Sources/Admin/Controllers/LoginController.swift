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
    
    public func landing(request: Request) throws -> ResponseRepresentable {
        do {
            _ = try request.auth.user()
            return Response(redirect: "/admin/dashboard");
        } catch {
            return Response(redirect: "/admin/login");
        }
    }
    
    public func resetPasswordForm(request: Request) throws -> ResponseRepresentable {
        return try drop.view.make("Login/reset", [
            "flash": try FlashHelper.retrieve(request)
        ])
    }
    
    public func resetPasswordSubmit(request: Request) throws -> ResponseRepresentable {
        guard let email = request.data["email"]?.string else {
            throw Abort.custom(status: Status.badRequest, message: "Missing email")
        }
        
        guard let user: BackendUser = try BackendUser.query().filter("email", email).first() else {
            throw Abort.custom(status: Status.badRequest, message: "Email doesn ot exist")
        }
        
        // Consider expiring old tokes for this user
        
        // Make a token
        var token = try BackendUserResetPasswordTokens(email: user.email.value)
        try token.save()
        
        try FlashHelper.addSuccess(request, message: "Email sent")
        return Response(redirect: "/admin/login");
    }
    
    public func form(request: Request) throws -> ResponseRepresentable {
        request.storage["test"] = "yes"
        return try drop.view.make("Login/login", [
            "flash": try FlashHelper.retrieve(request)
        ], for: request)
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
        } catch {
            try FlashHelper.addError(request, message: "Failed to login")
            return Response(redirect: "/admin");
        }
        
    }
}
