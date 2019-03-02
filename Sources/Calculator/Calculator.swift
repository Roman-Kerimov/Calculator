class Calculator {
    static let `default` = Calculator.init()
    
    private init() {}
    
    var sourceString = String.init()
    var leftStack = [Node].init()
    var rightStack = [Node].init()

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
}
