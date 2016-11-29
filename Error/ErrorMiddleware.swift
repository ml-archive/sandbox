import HTTP
import Vapor

public class ErrorMiddleware: Middleware {
    public init(){}
    public func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        do {
            return try chain.respond(to: request)
        } catch Error.standard(let status, let message, let code) {
            return try AbortMiddleware.errorResponse(request, status, message, code)
        } catch Error.report(let status, let message, let code) {
            return try AbortMiddleware.errorResponse(request, status, message, code)
        } catch Error.reportWithMeta(let status, let message, let code, _) {
            return try AbortMiddleware.errorResponse(request, status, message, code)
        }
    }
}

