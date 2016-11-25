import Vapor
import HTTP

public final class ConnectionMananger {
    
    let drop: Droplet
    let config: Configuration
    
    public init(drop: Droplet, config: Configuration) {
        self.drop = drop
        self.config = config
    }
    
    func headers() -> [HeaderKey: String] {
        
        let headers = [
            HeaderKey("Content-Type"): "application/json",
        ]
        
        return headers
    }
    
    func body(error: Error, request: Request) throws -> JSON {
        return try JSON(node: [
            "apiKey": self.config.apiKey
        ])
    }
    
    
    func post(json: JSON) throws -> Status {
        let response = try drop.client.post(self.config.endpoint, headers: headers(), body: json.makeBody())
        
        if(response.status != .accepted) {
            throw Abort.custom(status: response.status, message: "Bugsnag error - Response was not OK")
        } else {
            return .accepted
        }
    }
    
    func post(error: Error, request: Request) throws -> Status {
        return try post(json: body(error: error, request: request))
    }
    
}
