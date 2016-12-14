import HTTP
import Node

extension Response {
    public func flash(_ flashType: FlashHelper.FlashType, _ message: String) -> Response{
        self.storage[FlashHelper.flashKey] = Node([
            flashType.rawValue: Node(message)
        ])
        
        return self
    }
}
