//
//  NodeTests.swift
//  CalculatorTests
//
//  Created by Roman Kerimov on 2019-02-26.
//

import XCTest
@testable import Calculator

class NodeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEvaluationWithEmptyOperands() {
        XCTAssertNil(Node.rightRoundBracket.appending(leftOperand: .leftRoundBracket).value)
    }
    
    func testModulusBracket() {
        XCTAssertEqual(Node.rightModulusBracket.appending(leftOperand: Node.leftModulusBracket.appending(rightOperand: -2)).value, 2)
        XCTAssertEqual(Node.rightModulusBracket.appending(leftOperand: Node.leftModulusBracket.appending(rightOperand: 2)).value, 2)
    }
    
    func testAdd() {
        XCTAssertEqual(Node.add.appending(leftOperand: 7).appending(rightOperand: 2).value, 9)
        XCTAssertEqual(Node.add.appending(rightOperand: 2).value, 2)
        XCTAssertNil(Node.add.appending(leftOperand: 2).value)
    }
    
    func testSubtract() {
        XCTAssertEqual(Node.subtract.appending(leftOperand: 7).appending(rightOperand: 2).value, 5)
        XCTAssertEqual(Node.subtract.appending(rightOperand: 2).value, -2)
        XCTAssertNil(Node.subtract.appending(leftOperand: 2).value)
    }
    
    func testLn() {
        XCTAssertEqual(Node.naturalLogarithm.appending(rightOperand: .e).value, 1)
    }

    func testFactorial() {
        XCTAssertEqual(Node.factorial.appending(leftOperand: 0).value, 1)
        XCTAssertEqual(Node.factorial.appending(leftOperand: 1).value, 1)
        XCTAssertEqual(Node.factorial.appending(leftOperand: 6).value, 720)
        XCTAssertEqual(Node.factorial.appending(leftOperand: 1.5).value, nil)
        XCTAssertEqual(Node.factorial.appending(leftOperand: -2).value, nil)
    }
}
