import Foundation

public class Calculator {
    public static let `default` = Calculator()
    
    private init() {}
    
    var sourceString = String()
    var leftStack = [Node].init()
    var rightStack = [Node].init()
    var centerStack = [Node].init()
    
    public func evaluate(
        expressionFromString sourceString: String,
        shouldReturnASCII: Bool = false
    ) -> (expression: String, result: String)? {
        self.sourceString = sourceString
        tokenize()
        
        guard let result = parse().value else {
            return nil
        }
        
        let decimalNumberFormatter = NumberFormatter()
        decimalNumberFormatter.numberStyle = .decimal
        decimalNumberFormatter.maximumFractionDigits = 10
        
        let scientificNumberFormatter = NumberFormatter()
        scientificNumberFormatter.numberStyle = .scientific
        scientificNumberFormatter.maximumFractionDigits = 9
        
        if !shouldReturnASCII {
            let minusSign = "−"
            decimalNumberFormatter.minusSign = minusSign
            scientificNumberFormatter.minusSign = minusSign
        }
        
        let numberResult = NSNumber(value: Double(result))
        
        let stringResult: String?
        
        if  abs(result) == 0 || (1e-10 < abs(result) && abs(result) < 1e15) {
            stringResult =  decimalNumberFormatter.string(from: numberResult)
        } else {
            stringResult = scientificNumberFormatter.string(from: numberResult)
        }
        
        if let result = stringResult {
            return (expression, result)
        } else {
            return nil
        }
    }
    
    var expression: String = .init()
    
    func tokenize() {
        leftStack = []
        rightStack = []
        centerStack = []
        
        var characters = sourceString
        
        func node<StringType: StringProtocol>(fromToken token: StringType) -> Node? {
            let normalizedToken = token
                .precomposedStringWithCompatibilityMapping
                .lowercased()
                .replacingOccurrences(of: ",", with: ".")
            
            let node: Node?
            if let value = RealNumber(normalizedToken) {
                node = Node(value)
            } else {
                node = tokens[normalizedToken]
            }
            
            if node != nil {
                characters.removeLast(token.count)
            }
            
            return node
        }
        
        while characters.isEmpty == false {
            let nodeOrNil: Node?
            
            if characters.last!.isNewline {
                break
            } else if characters.last!.isWhitespace || (characters.last == "=" && leftStack.isEmpty) {
                characters.removeLast()
                continue
            } else if characters.last!.isWholeNumber {
                nodeOrNil = node(fromToken: characters.suffix(while: {$0.isWholeNumber || [".", ","].contains($0)}))
            } else if characters.last!.isLetter {
                nodeOrNil = node(fromToken: characters.suffix(while: {$0.isLetter}))
            } else {
                nodeOrNil = node(fromToken: characters.last!.description)
            }
            
            if let node = nodeOrNil {
                leftStack.append(node)
            } else {
                break
            }
        }
        
        expression = sourceString.dropFirst(characters.count).description
        expression = expression.dropFirst(expression.prefix(while: {$0.isWhitespace}).count).description
        leftStack.reverse()
        return
    }
    
    // swiftlint: disable cyclomatic_complexity function_body_length
    func parse() -> Node {
        while true {
            switch (
                leftStack.last?.hasAllRightOperands,
                centerStack.last?.hasAllOperands,
                rightStack.last?.hasAllLeftOperands
            ) {
            case (.none, .none, .none):
                return .nil
                
            case (_, _, .some(true)):
                centerStack.append(rightStack.popLast()!)
                
            case (.some(true), .some(_), _):
                centerStack.append(leftStack.popLast()!)
                
            case (.some(true), .none, _):
                if leftStack.last!.hasAllLeftOperands {
                    centerStack.append(leftStack.popLast()!)
                } else {
                    rightStack.append(leftStack.popLast()!)
                }
                
            case (.some(false), .some(_), .some(false)):
                func isLeftPrecedence() -> Bool {
                    let leftNodePrecedence = leftStack.last!.precedence
                    let rightNodePrecedence = rightStack.last!.precedence
                    
                    if leftNodePrecedence == rightNodePrecedence {
                        guard leftNodePrecedence.associativity == rightNodePrecedence.associativity else {
                            fatalError()
                        }
                        
                        switch leftNodePrecedence.associativity {
                        case .left:
                            return true
                        case .right:
                            return false
                        case .none:
                            fatalError()
                        }
                    } else {
                        return leftNodePrecedence.rawValue > rightNodePrecedence.rawValue
                    }
                }
                
                if isLeftPrecedence() {
                    leftStack.append(rightOperand: centerStack.popLast()!)
                } else {
                    rightStack.append(leftOperand: centerStack.popLast()!)
                }
                
            case (.some(false), .some(_), _):
                leftStack.append(rightOperand: centerStack.popLast()!)
                
            case (_, .some(_), .some(false)):
                rightStack.append(leftOperand: centerStack.popLast()!)
                
            case (.none, .none, .some(false)):
                centerStack.append(rightStack.popLast()!)
                
            case (.none, .some(_), .none):
                return centerStack.count == 1 ? centerStack.popLast()! : .nil
                
            case (.some(false), .none, .some(false)):
                centerStack.append(rightStack.popLast()!)
            
            case (.some(false), .none, .none):
                return .nil
            }
        }
    }
    // swiftlint: enable cyclomatic_complexity function_body_length
}

extension Array where Element == Node {
    mutating func append(leftOperand: Node) {
        append(popLast()!.appending(leftOperand: leftOperand))
    }
    
    mutating func append(rightOperand: Node) {
        append(popLast()!.appending(rightOperand: rightOperand))
    }
}
