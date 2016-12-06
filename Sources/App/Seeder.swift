import Console
import Admin

public final class Seeder: Command {
    public let id = "seeder"
    
    public let help: [String] = [
        "Seeds the database with rss"
    ]
    
    public let console: ConsoleProtocol
    
    public init(console: ConsoleProtocol) {
        self.console = console
    }
    
    public func run(arguments: [String]) throws {
        
        console.info("Started the seeder");
        
        
        let backendUsers = [
            try Admin.BackendUser(node: [
                "race_id": 1,
                "name": "Copenhagen",
                "url": "http://kmdironmancopenhagen.com/feed/",
                "is_for_live_ticker": false,
                "is_active": true,
                "created_at": "2013-10-19 22:30:58",
                "updated_at": "2016-07-20 15:24:38"
                ]),
            ]
        
        backendUsers.forEach({
            var backendUser = $0
            console.info("Looping \(backendUser.name)")
            do {
                try backendUser.save()
            } catch {
                console.error("Failed to store \(backendUser.name)")
                print(error)
            }
        })
        
        
        console.info("Finished the seeder");
    }
}
