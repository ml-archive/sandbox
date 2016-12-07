import Vapor
import HTTP

public final class FlashHelper {
    public static let flashKey = "_flash"
    public static let old = "old"
    public static let new = "new"
    
    public static func add(_ request: Request, type: String, message: String) throws {
        try request.session().data[flashKey, new, type] = Node(message)
    }
    
    public static func addError(_ request: Request, message: String) throws {
        try self.add(request, type: "error", message: message)
    }
    
    public static func addSuccess(_ request: Request, message: String) throws {
        try self.add(request, type: "success", message: message)
    }
    
    public static func retrieve(_ request: Request) throws -> Node {
        let newNode =  try request.session().data[flashKey, new] ?? Node([])
        
        try request.session().data[flashKey, old] = newNode
        try request.session().data[flashKey, old] = Node([])
        
        return newNode
    }
}
