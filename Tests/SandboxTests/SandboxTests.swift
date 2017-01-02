import XCTest
@testable import SandboxTests

class SandboxTests: XCTestCase {
    func test() {
        XCTAssertTrue(true)
    }


    static var allTests : [(String, (SandboxTests) -> () throws -> Void)] {
        return [
            ("test", test),
        ]
    }
}
