import XCTest

import CalculatorTests

var tests = [XCTestCaseEntry]()
tests += CalculatorTests.__allTests()

XCTMain(tests)
