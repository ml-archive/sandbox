import Vapor
import Fluent
import Foundation
import HTTP

public final class BackendUserRole: Model {
    /**
     Turn the convertible into a node
     
     - throws: if convertible can not create a Node
     - returns: a node if possible
     */
    public func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "slug": slug,
            "is_default": isDefault,
            "created_at": createdAt,
            "updated_at": updatedAt
            ])
    }

    
    public static var entity = "backend_user_roles"
    
    public var id: Node?
    public var title: String
    public var slug: String
    public var isDefault: Bool
    public var createdAt: Int?
    public var updatedAt: Int?
    
    public init(node: Node, in context: Context) throws {
        id = try? node.extract("id")
        title = try node.extract("title")
        slug = try node.extract("slug")
        isDefault = try node.extract("is_default")
        createdAt = try? node.extract("created_at")
        updatedAt = try? node.extract("updated_at")
    }
    
    public init(request: Request) throws {
        title = request.data["title"]?.string ?? ""
        slug = request.data["slug"]?.string ?? ""
        isDefault = false
        createdAt = request.data["created_at"]?.int ?? 0
        updatedAt = request.data["updated_at"]?.int ?? 0
    }
    
    public static func prepare(_ database: Database) throws {
        try database.create("backend_user_roles") { table in
            table.id()
            table.string("title");
            table.string("slug");
            table.bool("is_default");
            table.string("created_at", optional: true)
            table.string("updated_at", optional: true)
        }
    }
    
    public static func revert(_ database: Database) throws {
        try database.delete("backend_user_roles")
    }
}

/*
extension String {
    private static let allowedCharacters = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-")
    
    public func slugify() -> String {
        let cocoaString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(cocoaString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(cocoaString, nil, kCFStringTransformStripCombiningMarks, false)
        CFStringLowercase(cocoaString, .none)
        
        return String(cocoaString)
            .componentsSeparatedByCharactersInSet(String.allowedCharacters.invertedSet)
            .filter { $0 != "" }
            .joinWithSeparator("-")
    }
}
*/
