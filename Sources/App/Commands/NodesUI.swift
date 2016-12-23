import Vapor
import Console

final class NodesUICommand: Command {
    public let id = "admin-panel:nodes-ui"
    public let help = ["This command is awesome"]
    public let console: ConsoleProtocol

    public init(console: ConsoleProtocol) {
        self.console = console
    }

    public func run(arguments: [String]) throws {
        console.print("Jaaaa")
    }
}
