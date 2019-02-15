import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Calculator().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
