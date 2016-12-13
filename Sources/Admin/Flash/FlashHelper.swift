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
    
    public static func refresh(_ request: Request) throws {
        // Copy old to new
        try request.session().data[flashKey, State.new.rawValue] = try request.session().data[flashKey, State.old.rawValue] ?? Node([])
    }
    
    public static func apply(_ request: Request) throws {
        // Init flash node
        let flash = try request.session().data[flashKey, State.new.rawValue] ?? Node([])
        
        // Move new to old
        try request.session().data[flashKey, State.old.rawValue] = flash
        
        // Apply to request storage
        request.storage[flashKey] = flash
        
        // Clear new
        try request.session().data[flashKey, State.new.rawValue] = nil
    }
}
