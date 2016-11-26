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
        
        let stacktraceList: [Node]
        
        for s in Thread.callStackSymbols {
            Node([
                "file": "N/A",
                "lineNumber": 1,
                "columnNumber": 1,
                "method": "N/A",
                "code": Node([
                    "1": "N/A"
            ])
        }
        
        let stacktrace = Node(stacktraceList)
    
        
        let app: Node = Node([
            "releaseStage": Node(drop.environment.description),
            "type": "Vapor"
        ])
        
        let event: Node = Node([
            Node([
                "payloadVersion": 2,
                "exceptions": Node([
                    Node([
                        "errorClass": Node(error.localizedDescription),
                        "message": Node(error.localizedDescription),
                        "stacktrace": stacktrace
                    ])
                ]),
                "app": app
            ])
        ])
    
        return try JSON(node: [
            "apiKey": self.config.apiKey,
            "notifier": Node([
                    "name": "Bugsnag Vapor",
                    "version": "1.0.11",
                    "url": "https://github.com/nodes-vapor/bugsnag"
            ]),
            "events": event
        ])
    }
    
    func post(json: JSON) throws -> Status {
        let response = try drop.client.post(self.config.endpoint, headers: headers(), body: json.makeBody())
        
        return response.status
    }
    
    func post(error: Error, request: Request) throws -> Status {
        return try post(json: body(error: error, request: request))
    }
    
}
