import AdminPanel
import HTTP
import Vapor
import Auth

public class NodesSSO: SSOProtocol {
    let droplet: Droplet
    
    required public init(droplet: Droplet) {
        self.droplet = droplet
    }
    
    public func auth(_ request: Request) throws -> Response {
        guard let config: Configuration = droplet.storage["adminPanelConfig"] as? Configuration else {
            throw Abort.custom(status: .internalServerError, message: "AdminPanel Missing config")
        }
        
        if droplet.environment.description == "local" || request.uri.host == "0.0.0.0" {
            guard let backendUser = try BackendUser.query().first() else {
                throw Abort.notFound
            }
            
            try request.auth.login(Identifier(id: backendUser.id ?? 0))
            return Response(redirect: "/admin/dashboard").flash(.success, "Logged in as \(backendUser.email)")
        }
        
        
        guard var redirectUrl: String = config.ssoRedirectUrl?.string else {
            throw Abort.custom(status: .internalServerError, message: "AdminPanel missing ssoRedirectUrl")
        }
        
        // Add enviroment
        redirectUrl = redirectUrl.replacingOccurrences(of: "environment", with: droplet.environment.description)
        
        return Response(redirect: redirectUrl)
    }
    
    public func callback(_ request: Request) throws -> Response {
        return Response(redirect: "https://google.com")
    }
}
