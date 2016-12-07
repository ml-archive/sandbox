import Vapor
import HTTP

public final class DashboardController {
    
    public let drop: Droplet
    
    public init(droplet: Droplet) {
        drop = droplet
    }
    
    public func index(request: Request) throws -> ResponseRepresentable {
        try print(request.auth.user())
        return try drop.view.make("Dashboard/view", [
            "name": "Leaf 🍃"
            ])
    }
    
}
