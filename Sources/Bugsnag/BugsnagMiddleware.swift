import Vapor
import HTTP
//import Error

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
            try report(status: .badRequest, message: "Bad request", request: request)
            throw Abort.badRequest
        } catch Abort.serverError {
            try report(status: .internalServerError, message: "Server error", request: request)
            throw Abort.serverError
        } catch Abort.notFound {
            try report(status: .notFound, message: "Not found", request: request)
            throw Abort.notFound
        } catch Abort.custom(let status, let message) {
            try report(status: status, message: message, request: request)
            throw Abort.custom(status: status, message: message)
        } catch Abort.customWithCode(let status, let message, let code) {
            try report(status: status, message: message, request: request)
            throw Abort.customWithCode(status: status, message: message, code: code)
        }
        /*
        catch Error.standard(status: status, message: message, code: code) {
            throw Error.standard(status: status, message: message, code: code)
        }*/
    }
    
    public func report(status: Status, message: String, request: Request) throws {
        try connectionManager.post(status: status, message: message, request: request)
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
