import Vapor
import HTTP

public final class FlashHelper {
    
    public static func applyError(_ request: Request, message: String) throws {
        try request.session().data["flash-error"] = Node(message)
    }
    
    public static func retrieveError(_ request: Request) throws -> String? {
        let message = try request.session().data["flash-error"]?.string
        try request.session().data["flash-error"] = nil
    
        
        return message
    }
}
