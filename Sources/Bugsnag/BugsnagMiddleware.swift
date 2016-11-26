import Vapor
import HTTP
import Error

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
        } catch Abort.badRequest {
            BugsnagMiddleware.report(message: "Bad request", request: request)
            throw Abort.badRequest
        } catch Abort.serverError {
            throw Abort.serverError
            BugsnagMiddleware.report(message: "Server error", request: request)
        } catch Abort.notFound {
            throw Abort.notFound
        } catch Abort.custom(let status, let message) {
            throw Abort.custom(status: status, message: message)
        } catch Abort.customWithCode(let status, let message, let code) {
            throw Abort.customWithCode(status: status, message: message, code: code)
        } catch Error.standard(status: status, message: message, code: code) {
            throw Error.standard(status: status, message: message, code: code)
        }
    }
    
    public static func report(status: Status, message: String, request: Request) {
        try connectionManager.post(message: error.localizedDescription, request: request)
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
