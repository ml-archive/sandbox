import Vapor
import Fluent
import Foundation
import HTTP
import Turnstile
import TurnstileCrypto
import SwiftDate

public final class BackendUser: Model {
    
    public var exists: Bool = false
    public static var entity = "backend_users"
    
    public var id: Node?
    public var name: String
    public var email: Valid<Email>
    public var password: String
    public var role: String
    public var createdAt: DateInRegion
    public var updatedAt: DateInRegion
    
    enum Error: Swift.Error {
        case userNotFound
        case registerNotSupported
        case unsupportedCredentials
    }
    
    public init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        let emailTemp: String = try node.extract("email")
        email = try emailTemp.validated()
        password = try node.extract("password")
        role = try node.extract("role")
        
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
        name = request.data["name"]?.string ?? ""
        email = try request.data["email"].validated()
        password = BCrypt.hash(password: request.data["password"]?.string ?? "")
        role = request.data["role"]?.string ?? "user"
        createdAt = request.data["created_at"]?.int ?? 0
        updatedAt = request.data["updated_at"]?.int ?? 0
    }
    */
    
    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "email": email.value,
            "password": password,
            "role": role,
            "created_at": createdAt.string(custom: "yyyy-MM-dd HH:mm:ss"),
            "updated_at": updatedAt.string(custom: "yyyy-MM-dd HH:mm:ss")
        ])
    }
    
    public static func prepare(_ database: Database) throws {
        try database.create("backend_users") { table in
            table.id()
            table.string("name")
            table.string("email", unique: true)
            table.string("password")
            table.string("role")
            table.custom("created_at", type: "DATETIME", optional: true)
            table.custom("updated_at", type: "DATETIME", optional: true)
        }
        
        //try database.driver.raw("ADD FOREIGN TODO")
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete("backend_users")
    }
}
