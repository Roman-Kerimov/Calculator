import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase {
    func testTokenize() {
        
        Calculator.default.sourceString = "expression: sin(0,25*τ) + 2"
        Calculator.default.tokenize()
        XCTAssertEqual(Calculator.default.leftStack, [.divide, .sin, .leftRoundBracket, .init(0.25), .multiply, .tau, .rightRoundBracket, .add, .init(2)])
    }
    
    func testParse() {
        func testParsing(expression: String, result: Node) {
            Calculator.default.sourceString = expression
            Calculator.default.tokenize()
            XCTAssertEqual(Calculator.default.parse(), result)
        }
        
        testParsing(expression: "2", result: Node.init(2))
        testParsing(expression: "−2", result: Node.subtract.appending(rightOperand: 2))
        testParsing(expression: "2+2", result: Node.add.appending(leftOperand: 2).appending(rightOperand: 2))
        testParsing(expression: "2+2*2", result:
            Node.add
                .appending(leftOperand: 2)
                .appending(rightOperand:
                    Node.multiply
                        .appending(leftOperand: 2)
                        .appending(rightOperand: 2)
                )
        )
        
        testParsing(expression: "(2)", result: Node.rightRoundBracket.appending(leftOperand: Node.leftRoundBracket.appending(rightOperand: 2)))
        
        testParsing(expression: "(2+2)*2", result:
            Node.multiply
                .appending(leftOperand:
                    Node.rightRoundBracket
                        .appending(leftOperand:
                            Node.leftRoundBracket
                                .appending(rightOperand:
                                    Node.add
                                        .appending(leftOperand: 2)
                                        .appending(rightOperand: 2)
                                )
                        )
                )
                .appending(rightOperand: 2)
        )
        
        testParsing(expression: "2^2^2", result:
            Node.power
                .appending(leftOperand: 2)
                .appending(rightOperand:
                    Node.power
                        .appending(leftOperand: 2)
                        .appending(rightOperand: 2)
                )
        )
        
        testParsing(expression: "2+2−2", result:
            Node.subtract
                .appending(leftOperand:
                    Node.add
                        .appending(leftOperand: 2)
                        .appending(rightOperand: 2)
                )
                .appending(rightOperand: 2)
        )
        
        testParsing(expression: "sin π + 2", result:
            Node.add
                .appending(leftOperand: Node.sin.appending(rightOperand: Node.pi))
                .appending(rightOperand: 2)
        )
        
        testParsing(expression: "log10 1000", result:
            Node.log.appending(rightOperand: 10).appending(rightOperand: 1000)
        )
        
        testParsing(expression: "log10 1000 + 2", result:
            Node.add
                .appending(leftOperand:
                    Node.log.appending(rightOperand: 10).appending(rightOperand: 1000)
                )
                .appending(rightOperand: 2)
            
        )
        
        testParsing(expression: "(−2)", result:
            Node.rightRoundBracket
                .appending(leftOperand:
                    Node.leftRoundBracket
                        .appending(rightOperand:
                            Node.subtract.appending(rightOperand: 2)
                        )
                )
        )
        
        testParsing(expression: "", result: .nil)
    }
}
