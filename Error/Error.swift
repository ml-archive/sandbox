import HTTP

public enum Error: Swift.Error {
    case standard(status: Status, message: String, code: Int)
    case report(status: Status, message: String, code: Int)
    case reportWithMeta(status: Status, message: String, code: Int, meta: [String: String])
}
