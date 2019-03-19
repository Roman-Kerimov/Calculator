import XCTest
@testable import Calculator

final class CalculatorTests: XCTestCase {
    
    func testTokenize() {
        func testTokenization(expression: String, result: [Node]) {
            Calculator.default.sourceString = expression
            Calculator.default.tokenize()
            XCTAssertEqual(Calculator.default.leftStack, result)
        }
        
        testTokenization(expression: "expression: sin(0,25*τ) + 2", result: [.divide, .sine, .leftRoundBracket, .init(0.25), .multiply, .tau, .rightRoundBracket, .add, .init(2)])
        testTokenization(expression: "2+2\n3+3", result: [.init(3), .add, .init(3)])
        testTokenization(expression: "2+2=", result: [.init(2), .add, .init(2)])
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
                .appending(leftOperand: Node.sine.appending(rightOperand: Node.pi))
                .appending(rightOperand: 2)
        )
        
        testParsing(expression: "log10 1000", result:
            Node.logarithm.appending(rightOperand: 10).appending(rightOperand: 1000)
        )
        
        testParsing(expression: "log10 1000 + 2", result:
            Node.add
                .appending(leftOperand:
                    Node.logarithm.appending(rightOperand: 10).appending(rightOperand: 1000)
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
        
        testParsing(expression: "2+", result: .nil)
        
        testParsing(expression: "2 3+3", result: .nil)
        
        testParsing(expression: "−4×4 5", result: .nil)
    }
    
    func testEvaluate() {
        func testEvaluation(expression: String, result: String?) {
            XCTAssertEqual(Calculator.default.evaluate(expressionFromString: expression)?.result, result?.replacingOccurrences(of: ".", with: Locale.current.decimalSeparator ?? "."))
        }
        
        testEvaluation(expression: "2+2×2", result: "6")
        testEvaluation(expression: "1/3", result: "0.3333333333")
        testEvaluation(expression: "100!", result: "9.332621544E157")
        testEvaluation(expression: "05+6,25", result: "11.25")
        testEvaluation(expression: "1/20!", result: "4.110317623E−19")
        testEvaluation(expression: "5−9", result: "−4")
        testEvaluation(expression: "2−2", result: "0")
        testEvaluation(expression: "2+2\n3+3", result: "6")
        testEvaluation(expression: "()", result: nil)
        testEvaluation(expression: "log10 1000", result: "3")
    }
    
    func testExpression() {
        XCTAssertEqual(Calculator.default.evaluate(expressionFromString: "expression 2 + 2")?.expression, "2 + 2")
    }
}
