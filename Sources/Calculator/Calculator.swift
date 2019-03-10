class Calculator {
    static let `default` = Calculator.init()
    
    private init() {}
    
    var sourceString = String.init()
    var leftStack = [Node].init()
    var rightStack = [Node].init()
    var centerStack = [Node].init()

    func tokenize() {
        var characters = sourceString
        
        func node<StringType: StringProtocol>(fromToken token: StringType) -> Node? {
            
            let normalizedToken = token.precomposedStringWithCompatibilityMapping.lowercased().replacingOccurrences(of: ",", with: ".")
            
            let node: Node?
            if let value = Float80.init(normalizedToken) {
                node = Node.init(value)
            }
            else {
                node = tokens[normalizedToken]
            }
            
            if node != nil {
                characters.removeLast(token.count)
            }
            
            return node
        }
        
        while characters.isEmpty == false {
            let nodeOrNil: Node?
            
            if characters.last!.isWhitespace {
                characters.removeLast()
                continue
            }
            else if characters.last!.isWholeNumber {
                nodeOrNil = node(fromToken: characters.suffix(while: {$0.isWholeNumber || [".", ","].contains($0)}))
            }
            else if characters.last!.isLetter {
                nodeOrNil = node(fromToken: characters.suffix(while: {$0.isLetter}))
            }
            else {
                nodeOrNil = node(fromToken: characters.last!.description)
            }
            
            if let node = nodeOrNil {
                leftStack.append(node)
            }
            else {
                break
            }
        }
        
        leftStack.reverse()
        return
    }
    
    func parse() -> Node {
        
        while true {
            
            switch (leftStack.last?.hasAllRightOperands, centerStack.last?.hasAllOperands, rightStack.last?.hasAllLeftOperands) {
            case (.none, .none, .none):
                return .nil
                
            case (_, _, .some(true)):
                centerStack.append(rightStack.popLast()!)
                
            case (.some(true), _, _):
                if leftStack.last!.hasAllLeftOperands {
                    centerStack.append(leftStack.popLast()!)
                }
                else {
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
                    }
                    else {
                        return leftNodePrecedence.rawValue > rightNodePrecedence.rawValue
                    }
                }
                
                if isLeftPrecedence() {
                    leftStack.append(rightOperand: centerStack.popLast()!)
                }
                else {
                    rightStack.append(leftOperand: centerStack.popLast()!)
                }
                
            case (.some(false), .some(_), _):
                leftStack.append(rightOperand: centerStack.popLast()!)
                
            case (_, .some(_), .some(false)):
                rightStack.append(leftOperand: centerStack.popLast()!)
                
            case (.none, .none, .some(false)):
                centerStack.append(rightStack.popLast()!)
                
            case (.none, .some(_), .none):
                return centerStack.popLast()!
                
                
            case (.none, _, .some(false)):
                return rightStack.popLast()!
                
            case (.some(false), .none, .some(false)):
                centerStack.append(rightStack.popLast()!)
            
            case (.some(false), .none, .none):
                centerStack.append(leftStack.popLast()!)
            }
        }
    }
}

extension Array where Element == Node {
    mutating func append(leftOperand: Node) {
        append(popLast()!.appending(leftOperand: leftOperand))
    }
    
    mutating func append(rightOperand: Node) {
        append(popLast()!.appending(rightOperand: rightOperand))
    }
}
