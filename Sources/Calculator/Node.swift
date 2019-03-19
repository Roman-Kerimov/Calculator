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
        
        struct Values {
            var left: [RealNumber], right: [RealNumber]
            
            var leftFirst: RealNumber {
                return self.left.first!
            }
            
            var rightFirst: RealNumber {
                return self.right.first!
            }
            
            var rightSecond: RealNumber {
                return self.right[1]
            }
        }
    }
    
    private init(operandCounts: OperandCounts, precedence: Precedence, value: @escaping (Operands.Values) -> RealNumber?) {
        
        self.operandCounts = operandCounts
        self.precedence = precedence
        getValue = value
        
        self.id = Node.lastID + 1
        Node.lastID = self.id
    }
    
    init(_ value: RealNumber) {
        self.init(operandCounts: (0, 0), precedence: .number) {_ in value}
    }
    
    var value: RealNumber? {
        
        guard (operands.left.count == operandCounts.left || ( (self === Node.add || self === Node.subtract) && operands.left.isEmpty))
        && operands.right.count == operandCounts.right else {
            
            return nil
        }
        
        let operandValues = Operands.Values.init(left: operands.left.compactMap {$0.value}, right: operands.right.compactMap {$0.value})
        
        guard operandValues.left.count == operands.left.count && operandValues.right.count == operands.right.count else {
            return nil
        }
        
        return  getValue(operandValues)
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
    
    func appending(leftOperand: RealNumber) -> Node {
        return appending(leftOperand: Node.init(leftOperand))
    }
    
    func appending(rightOperand: RealNumber) -> Node {
        return appending(rightOperand: Node.init(rightOperand))
    }
    
    var hasAllLeftOperands: Bool {
        return operandCounts.left == operands.left.count
    }
    
    var hasAllRightOperands: Bool {
        return operandCounts.right == operands.right.count
    }
    
    var hasAllOperands: Bool {
        return hasAllLeftOperands && hasAllRightOperands
    }
    
    let precedence: Precedence
    
    private let getValue: (_ operandValues: Operands.Values) -> RealNumber?
    
    private let id: UInt
    private static var lastID: UInt = 0
    
    static func === (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
    
    static let `nil` = Node.init(operandCounts: (0, 0), precedence: .number) { (_) -> RealNumber? in
        return nil
    }
    
    static let pi = Node.init(.pi)
    static let tau = Node.init(.pi*2)
    static let e = Node.init(exp(1))
    
    static let leftRoundBracket = Node.init(operandCounts: (0, 1), precedence: .bracket) {$0.rightFirst}
    static let rightRoundBracket = Node.init(operandCounts: (1, 0), precedence: .bracket) {$0.leftFirst}
    
    static let leftSquareBracket = Node.init(operandCounts: (0, 1), precedence: .bracket) {$0.rightFirst}
    static let rightSquareBracket = Node.init(operandCounts: (1, 0), precedence: .bracket) {$0.leftFirst}
    
    static let leftCurlyBracket = Node.init(operandCounts: (0, 1), precedence: .bracket) {$0.rightFirst}
    static let rightCurlyBracket = Node.init(operandCounts: (1, 0), precedence: .bracket) {$0.leftFirst}
    
    static let leftModulusBracket = Node.init(operandCounts: (0, 1), precedence: .bracket) {$0.rightFirst}
    static let rightModulusBracket = Node.init(operandCounts: (1, 0), precedence: .bracket) {Swift.abs($0.leftFirst)}
    
    static let add = Node.init(operandCounts: (1, 1), precedence: .addition) {($0.left.first ?? 0) + $0.rightFirst}
    static let subtract = Node.init(operandCounts: (1, 1), precedence: .addition) {($0.left.first ?? 0) - $0.rightFirst}
    
    static let multiply = Node.init(operandCounts: (1, 1), precedence: .multiplication) {$0.leftFirst * $0.rightFirst}
    static let divide = Node.init(operandCounts: (1, 1), precedence: .multiplication) {$0.leftFirst / $0.rightFirst}
    static let remainder = Node.init(operandCounts: (1, 1), precedence: .multiplication) {$0.leftFirst.truncatingRemainder(dividingBy: $0.rightFirst)}
    
    static let power = Node.init(operandCounts: (1, 1), precedence: .exponentation) {pow($0.leftFirst, $0.rightFirst)}
    
    static let squareRoot = Node.init(operandCounts: (0, 1), precedence: .function) {sqrt($0.rightFirst)}
    static let cubeRoot = Node.init(operandCounts: (0, 1), precedence: .function) {cbrt($0.rightFirst)}
    static let fourthRoot = Node.init(operandCounts: (0, 1), precedence: .function) {pow($0.rightFirst, 0.25)}
    
    static let logarithm = Node.init(operandCounts: (0, 2), precedence: .function) {log($0.rightSecond)/log($0.rightFirst)}
    static let binaryLogarithm = Node.init(operandCounts: (0, 1), precedence: .function) {log2($0.rightFirst)}
    static let naturalLogarithm = Node.init(operandCounts: (0, 1), precedence: .function) {log($0.rightFirst)}
    static let commonLogarithm = Node.init(operandCounts: (0, 1), precedence: .function) {log10($0.rightFirst)}
    
    static func sin(_ value: RealNumber) -> RealNumber {
        return value.isDivisible(by: .pi) ? 0 : Foundation.sin(value)
    }
    
    static func cos(_ value: RealNumber) -> RealNumber {
        return (.pi/2+value).isDivisible(by: .pi) ? 0 : Foundation.cos(value)
    }
    
    static func tan(_ value: RealNumber) -> RealNumber {
        return value.isDivisible(by: .pi) ? 0 : (.pi/2+value).isDivisible(by: .pi) ? .infinity : Foundation.tan(value)
    }
    
    static let sine = Node.init(operandCounts: (0, 1), precedence: .function) {sin($0.rightFirst)}
    static let cosine = Node.init(operandCounts: (0, 1), precedence: .function) {cos($0.rightFirst)}
    static let tangent = Node.init(operandCounts: (0, 1), precedence: .function) {tan($0.rightFirst)}
    static let cotangent = Node.init(operandCounts: (0, 1), precedence: .function) {1/tan($0.rightFirst)}
    static let secant = Node.init(operandCounts: (0, 1), precedence: .function) {1/cos($0.rightFirst)}
    static let cosecant = Node.init(operandCounts: (0, 1), precedence: .function) {1/sin($0.rightFirst)}
    
    static let arcsine = Node.init(operandCounts: (0, 1), precedence: .function) {asin($0.rightFirst)}
    static let arccosine = Node.init(operandCounts: (0, 1), precedence: .function) {acos($0.rightFirst)}
    static let arctangent = Node.init(operandCounts: (0, 1), precedence: .function) {atan($0.rightFirst)}
    static let arccotangent = Node.init(operandCounts: (0, 1), precedence: .function) {1/atan($0.rightFirst)}
    static let arcsecant = Node.init(operandCounts: (0, 1), precedence: .function) {1/acos($0.rightFirst)}
    static let arccosecant = Node.init(operandCounts: (0, 1), precedence: .function) {1/asin($0.rightFirst)}
    
    static let modulus = Node.init(operandCounts: (0, 1), precedence: .function) {Swift.abs($0.rightFirst)}
    
    static let factorial = Node.init(operandCounts: (1, 0), precedence: .factorial) { (operands) -> RealNumber? in
        
        let operand = operands.leftFirst

        guard operand >= 0 && operand == operand.rounded() else {
            return nil
        }

        if operand == 0 {
            return 1
        }
        else {
            return (1...Int.init(operand)).map {RealNumber.init($0)} .reduce(1, *)
        }
    }
    
}

extension Node: Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        
        if lhs.precedence == .number && rhs.precedence == .number {
            return lhs.value == lhs.value
        }
        else {
            return lhs === rhs && lhs.operands.left == rhs.operands.left && lhs.operands.right == rhs.operands.right
        }
    }
}

extension Node: CustomDebugStringConvertible {
    var debugDescription: String {
        return "Node<" + (tokens.filter {$0.value === self} .keys.sorted().first ?? self.value?.debugDescription ?? "nil") + ">"
        
            + (operands.left.isEmpty && operands.right.isEmpty ? "" : "(left: \(operands.left.debugDescription), right: \(operands.right.debugDescription ))")
    }
}
