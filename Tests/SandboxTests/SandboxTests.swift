import XCTest
@testable import SandboxTests

class NStackTests: XCTestCase {
    func test() {
        XCTAssertTrue(true)
    }


    static var allTests : [(String, (SandboxTests) -> () throws -> Void)] {
        return [
            ("test", test),
        ]
    }
}
