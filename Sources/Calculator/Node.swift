//
//  Node.swift
//  Calculator
//
//  Created by Roman Kerimov on 2019-02-26.
//

import Foundation

struct Node {
    enum Precedence: Int, Comparable {
        static func < (lhs: Node.Precedence, rhs: Node.Precedence) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
        case number
        case bracket
        case addition
        case multiplication
        case exponentation
        case function
        case factorial
        
        enum Associativity {
            case left, right
            case none
        }
        
        var associativity: Associativity {
            switch self {
                
            case .number:
                return .none
                
            case .bracket:
                return .left
                
            case .addition:
                return .left
                
            case .multiplication:
                return .left
                
            case .exponentation:
                return .right
                
            case .function:
                return .none
                
            case .factorial:
                return .none
            }
        }
    }
    
    typealias OperandCounts = (left: Int, right: Int)
    private struct Operands {
        var left: [Node], right: [Node]
        
        var leftFirst: Float80 {
            return self.left.first!.value!
        }
        
        var rightFirst: Float80 {
            return self.right.first!.value!
        }
        
        var rightSecond: Float80 {
            return self.right[1].value!
        }
    }
    
    private init(operandCounts: OperandCounts, precedence: Precedence, value: @escaping (Operands) -> Float80?) {
        
        self.operandCounts = operandCounts
        self.precedence = precedence
        getValue = value
        
        self.id = Node.lastID + 1
        Node.lastID = self.id
    }
    
    init(_ value: Float80) {
        self.init(operandCounts: (0, 0), precedence: .number) {_ in value}
    }
    
    var value: Float80? {
        
        guard (operands.left.count == operandCounts.left || ( (self === Node.add || self === Node.subtract) && operands.left.isEmpty))
        && operands.right.count == operandCounts.right else {
            
            return nil
        }
        
        return  getValue(operands)
    }
    
    let operandCounts: OperandCounts
    private var operands = Operands.init(left: [], right: [])
    
    func appending(leftOperand: Node) -> Node {
        var node = self
        node.operands.left.append(leftOperand)
        return node
    }
    
    func appending(rightOperand: Node) -> Node {
        var node = self
        node.operands.right.append(rightOperand)
        return node
    }
    
    func appending(leftOperand: Float80) -> Node {
        return appending(leftOperand: Node.init(leftOperand))
    }
    
    func appending(rightOperand: Float80) -> Node {
        return appending(rightOperand: Node.init(rightOperand))
    }
    
    let precedence: Precedence
    
    private let getValue: (_ operands: Operands) -> Float80?
    
    private let id: UInt
    private static var lastID: UInt = 0
    
    static func === (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let pi = Node.init(.pi)
    static let e = Node.init(.e)
    
    static let leftRoundBracket = Node.init(operandCounts: (0, 1), precedence: .bracket) {$0.rightFirst}
    static let rightRoundBracket = Node.init(operandCounts: (1, 0), precedence: .bracket) {$0.left.first! === .leftRoundBracket ? $0.leftFirst : nil}
    
    static let leftSquareBracket = Node.init(operandCounts: (0, 1), precedence: .bracket) {$0.rightFirst}
    static let rightSquareBracket = Node.init(operandCounts: (1, 0), precedence: .bracket) {$0.left.first! === .leftSquareBracket ? $0.leftFirst : nil}
    
    static let leftCurlyBracket = Node.init(operandCounts: (0, 1), precedence: .bracket) {$0.rightFirst}
    static let rightCurlyBracket = Node.init(operandCounts: (1, 0), precedence: .bracket) {$0.left.first! === .leftCurlyBracket ? $0.leftFirst : nil}
    
    static let leftModulusBracket = Node.init(operandCounts: (0, 1), precedence: .bracket) {$0.rightFirst}
    static let rightModulusBracket = Node.init(operandCounts: (1, 0), precedence: .bracket) {$0.left.first! === .leftModulusBracket ? Swift.abs($0.leftFirst) : nil}
    
    static let add = Node.init(operandCounts: (1, 1), precedence: .addition) {($0.left.first?.value! ?? 0) + $0.rightFirst}
    static let subtract = Node.init(operandCounts: (1, 1), precedence: .addition) {($0.left.first?.value! ?? 0) - $0.rightFirst}
    
    static let multiply = Node.init(operandCounts: (1, 1), precedence: .multiplication) {$0.leftFirst * $0.rightFirst}
    static let divide = Node.init(operandCounts: (1, 1), precedence: .multiplication) {$0.leftFirst / $0.rightFirst}
    static let remainder = Node.init(operandCounts: (1, 1), precedence: .multiplication) {$0.leftFirst.truncatingRemainder(dividingBy: $0.rightFirst)}
    
    static let power = Node.init(operandCounts: (1, 1), precedence: .exponentation) {pow($0.leftFirst, $0.rightFirst)}
    
    static let sqrt = Node.init(operandCounts: (0, 1), precedence: .function) {Foundation.sqrt($0.rightFirst)}
    static let cbrt = Node.init(operandCounts: (0, 1), precedence: .function) {Foundation.cbrt($0.rightFirst)}
    static let frrt = Node.init(operandCounts: (0, 1), precedence: .function) {pow($0.rightFirst, 0.25)}
    
    static let log = Node.init(operandCounts: (0, 2), precedence: .function) {Foundation.log($0.rightSecond)/Foundation.log($0.rightFirst)}
    static let lb = Node.init(operandCounts: (0, 1), precedence: .function) {log2($0.rightFirst)}
    static let ln = Node.init(operandCounts: (0, 1), precedence: .function) {Foundation.log($0.rightFirst)}
    static let lg = Node.init(operandCounts: (0, 1), precedence: .function) {log10($0.rightFirst)}
    
    static let sin = Node.init(operandCounts: (0, 1), precedence: .function) {Foundation.sin($0.rightFirst)}
    static let cos = Node.init(operandCounts: (0, 1), precedence: .function) {Foundation.cos($0.rightFirst)}
    static let tan = Node.init(operandCounts: (0, 1), precedence: .function) {Foundation.tan($0.rightFirst)}
    static let cot = Node.init(operandCounts: (0, 1), precedence: .function) {1/Foundation.tan($0.rightFirst)}
    static let sec = Node.init(operandCounts: (0, 1), precedence: .function) {1/Foundation.cos($0.rightFirst)}
    static let csc = Node.init(operandCounts: (0, 1), precedence: .function) {1/Foundation.sin($0.rightFirst)}
    
    static let arcsin = Node.init(operandCounts: (0, 1), precedence: .function) {asin($0.rightFirst)}
    static let arccos = Node.init(operandCounts: (0, 1), precedence: .function) {acos($0.rightFirst)}
    static let arctan = Node.init(operandCounts: (0, 1), precedence: .function) {atan($0.rightFirst)}
    static let arccot = Node.init(operandCounts: (0, 1), precedence: .function) {1/atan($0.rightFirst)}
    static let arcsec = Node.init(operandCounts: (0, 1), precedence: .function) {1/acos($0.rightFirst)}
    static let arccsc = Node.init(operandCounts: (0, 1), precedence: .function) {1/asin($0.rightFirst)}
    
    static let abs = Node.init(operandCounts: (0, 1), precedence: .function) {Swift.abs($0.rightFirst)}
    
    static let factorial = Node.init(operandCounts: (1, 0), precedence: .factorial) { (operands) -> Float80? in
        
        let operand = operands.leftFirst

        guard operand >= 0 && operand == operand.rounded() else {
            return nil
        }

        if operand == 0 {
            return 1
        }
        else {
            return (1...Int.init(operand)).map {Float80.init($0)} .reduce(1, *)
        }
    }
    
}
