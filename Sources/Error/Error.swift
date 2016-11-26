import HTTP

public class Error: Swift.Error {
    var status: Status
    var message: String
    var code: Int
    
    public init(status: Status, message: String, code: Int) {
        self.status = status
        self.message = message
        self.code = code
    }
}
