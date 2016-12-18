import Vapor
import Fluent
import Foundation
import HTTP
import SwiftDate

public final class BackendUserRole: Model {
    public static var entity = "backend_user_roles"
    public var exists: Bool = false
    
    public var id: Node?
    public var title: String
    public var slug: String
    public var isDefault: Bool
    public var createdAt: DateInRegion
    public var updatedAt: DateInRegion
    
    public init(node: Node, in context: Context) throws {
        id = try? node.extract("id")
        title = try node.extract("title")
        slug = try node.extract("slug")
        isDefault = try node.extract("is_default") ?? false
        
        do {
            createdAt = try DateInRegion(string: node.extract("created_at"), format: .custom("yyyy-MM-dd HH:mm:ss"))
        } catch {
            createdAt = DateInRegion()
        }
        
        do {
            updatedAt = try DateInRegion(string: node.extract("updated_at"), format: .custom("yyyy-MM-dd HH:mm:ss"))
        } catch {
            updatedAt = DateInRegion()
        }
    }
    
    /*
    public init(request: Request) throws {
        title = request.data["title"]?.string ?? ""
        slug = request.data["slug"]?.string ?? ""
        isDefault = false
        updatedAt = DateInRegion()
        createdAt = DateInRegion()
    }
    */
    
    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "slug": slug,
            "is_default": isDefault,
            "created_at": createdAt.string(custom: "yyyy-MM-dd HH:mm:ss"),
            "updated_at": updatedAt.string(custom: "yyyy-MM-dd HH:mm:ss")
            ])
    }
    
    public static func prepare(_ database: Database) throws {
        try database.create("backend_user_roles") { table in
            table.id()
            table.string("title");
            table.string("slug", unique: true);
            table.bool("is_default");
            table.custom("created_at", type: "DATETIME", optional: true)
            table.custom("updated_at", type: "DATETIME", optional: true)
        }
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete("backend_user_roles")
    }
}
