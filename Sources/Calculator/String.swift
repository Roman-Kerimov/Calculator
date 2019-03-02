//
//  String.swift
//  Calculator
//
//  Created by Roman Kerimov on 2019-03-02.
//

import Foundation

extension String {
    func suffix(while predicate: (Character) throws -> Bool) rethrows -> Substring {
        let suffixLenght = self.count-1 - (lastIndex { try! !predicate($0) }?.utf16Offset(in: self) ?? -1)
        return self.suffix(suffixLenght)
    }
}
