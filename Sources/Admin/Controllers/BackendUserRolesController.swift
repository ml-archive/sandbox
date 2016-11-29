import Vapor
import HTTP

public final class BackendUserRolesController {
    
    public let drop: Droplet
    
    public init(droplet: Droplet) {
        drop = droplet
    }
    
    /**
     * List all backend users
     *
     * - param: Request
     * - return: View
     */
    public func index(request: Request) throws -> ResponseRepresentable {
        let roles = try BackendUserRole.all()
        let rolesNodes = try roles.map({ try $0.makeNode() })
        
        
        return try drop.view.make("BackendUsers/roles", [
            "roles": Node(rolesNodes)
        ])
    }

    public func store(request: Request) throws -> ResponseRepresentable {
        var role = try BackendUserRole(request: request)
        try role.save()
        
        return Response(redirect: "/admin/users/roles?created=true");
    }
    
    public func update(request: Request) throws -> ResponseRepresentable {
        return Response(redirect: "/admin/users/roles?updated=true");
    }
}
