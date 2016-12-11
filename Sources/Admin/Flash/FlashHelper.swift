import Vapor
import HTTP

public final class FlashHelper {
    public static let flashKey = "_flash"
    enum State: String {
        case new = "new"
        case old = "old"
    }
    
    public enum FlashType: String {
        case error = "error"
        case success = "success"
    }
    
    public static func add(_ request: Request, type: FlashType, message: String) throws {
        try request.session().data[flashKey, State.new.rawValue, type.rawValue] = Node(message)
    }
    
    public static func addError(_ request: Request, message: String) throws {
        try self.add(request, type: .error, message: message)
    }
    
    public static func addSuccess(_ request: Request, message: String) throws {
        try self.add(request, type: .success, message: message)
    }
    
    public static func retrieve(_ request: Request) throws -> Node {
        let newNode =  try request.session().data[flashKey, State.new.rawValue] ?? Node([])
        
        try request.session().data[flashKey, State.old.rawValue] = newNode
        try request.session().data[flashKey, State.new.rawValue] = Node([])
        
        return newNode
    }
}
