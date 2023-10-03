//
//  StringTests.swift
//  CalculatorTests
//
//  Created by Roman Kerimov on 2019-03-02.
//

import XCTest
@testable import Calculator

class StringTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSuffixWhile() {
        XCTAssertEqual("2 × sin".suffix {$0.isLetter}, "sin")
        XCTAssertEqual("𝜋𝜏: .t".suffix {$0.isLetter}, "t")
    }
}
