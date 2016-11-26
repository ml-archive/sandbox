import Vapor
import HTTP

public final class BugsnagMiddleware: Middleware {
    
    let drop: Droplet
    let configuration: Configuration
    let connectionManager: ConnectionMananger
    public init(drop: Droplet) throws {
        self.drop = drop
        self.configuration = try Configuration(drop: drop)
        self.connectionManager = ConnectionMananger(drop: drop, config: configuration)
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        do {
            return try next.respond(to: request)
        } catch {
            try connectionManager.post(message: error.localizedDescription, request: request)
            throw error
        }
    }
}

/*
 do {
 return try chain.respond(to: request)
 } catch Abort.badRequest {
 return try AbortMiddleware.errorResponse(request, .badRequest, "Invalid request")
 } catch Abort.notFound {
 return try AbortMiddleware.errorResponse(request, .notFound, "Page not found")
 } catch Abort.serverError {
 return try AbortMiddleware.errorResponse(request, .internalServerError, "Something went wrong")
 } catch Abort.custom(let status, let message) {
 return try AbortMiddleware.errorResponse(request, status, message)
 }
 */
