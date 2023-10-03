//
//  RealNumber.swift
//  Calculator
//
//  Created by Roman Kerimov on 2019-03-10.
//

import Foundation

typealias RealNumber = Double

extension RealNumber {
    func isDivisible(by value: RealNumber) -> Bool {
        let decimalNumberFormatter = NumberFormatter()
        decimalNumberFormatter.numberStyle = .decimal
        return decimalNumberFormatter
            .string(from: .init(value: self/value))?
            .contains(decimalNumberFormatter.decimalSeparator)
            == false
    }
}
