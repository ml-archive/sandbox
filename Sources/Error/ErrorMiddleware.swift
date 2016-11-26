import HTTP
import Vapor

public class ErrorMiddleware: Middleware {
    public init(){}
    public func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        do {
            return try chain.respond(to: request)
        } catch Error.standard(let status, let message, let code) {
            return try ErrorMiddleware.errorResponse(request, status, message, code)
        } catch Error.report(let status, let message, let code) {
            return try ErrorMiddleware.errorResponse(request, status, message, code)
        } catch Error.reportWithMeta(let status, let message, let code, _) {
            return try ErrorMiddleware.errorResponse(request, status, message, code)
        }
    }
        
    static func errorResponse(_ request: Request, _ status: Status, _ message: String, _ code: Int = 0) throws -> Response {
        if request.accept.prefers("html") {
            return ErrorView.shared.makeResponse(status, message)
        }
        
        let json = try JSON(node: [
            "error": true,
            "message": "\(message)",
            "code": code
            ])
        let data = try json.makeBytes()
        let response = Response(status: status, body: .data(data))
        response.headers["Content-Type"] = "application/json; charset=utf-8"
        return response
    }
}

