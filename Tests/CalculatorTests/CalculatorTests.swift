import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase {
    func testTokenize() {
        
        Calculator.default.sourceString = "expression: sin(0,25*τ) + 2"
        Calculator.default.tokenize()
        XCTAssertEqual(Calculator.default.leftStack, [.divide, .sin, .leftRoundBracket, .init(0.25), .multiply, .tau, .rightRoundBracket, .add, .init(2)])
    }
}
