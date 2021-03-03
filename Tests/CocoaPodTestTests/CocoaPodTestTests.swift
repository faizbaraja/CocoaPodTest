import XCTest
@testable import CocoaPodTest

final class CocoaPodTestTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CocoaPodTest().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
