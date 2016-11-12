import Vapor
import Fluent
import Foundation
import HTTP

final class NMetaMiddleware: Middleware {
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        let response = try next.respond(to: request)
        
        print(request.headers)
        guard let nMeta = request.headers["N-Meta"]?.string else {
            throw Abort.custom(status: .badRequest, message: "Missing N-Meta header")
        }
        
        NMeta(nMeta: nMeta);
        
        return response
    }
}
