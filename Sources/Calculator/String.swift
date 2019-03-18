//
//  String.swift
//  Calculator
//
//  Created by Roman Kerimov on 2019-03-02.
//

import Foundation

extension String {
    func suffix(while predicate: (Character) throws -> Bool) rethrows -> Substring {
        if let lastNonSuffixIndex = lastIndex(where: { try! !predicate($0) }) {
            return self[lastNonSuffixIndex...].dropFirst()
        }
        else {
            return self[startIndex...]
        }
    }
}
