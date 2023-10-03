//
//  Tokens.swift
//  Calculator
//
//  Created by Roman Kerimov on 2019-03-01.
//

import Foundation

let tokens: [String: Node] = [
    "pi": .pi,
    "π": .pi, // GREEK SMALL LETTER PI
    "𝜋": .pi, // MATHEMATICAL ITALIC SMALL PI
    
    "tau": .tau,
    "τ": .tau, // GREEK SMALL LETTER TAU
    "𝜏": .tau, // MATHEMATICAL ITALIC SMALL TAU
    
    "e": .e,
    "𝑒": .e, // MATHEMATICAL ITALIC SMALL E
    
    "(": .leftRoundBracket,
    ")": .rightRoundBracket,
    
    "[": .leftSquareBracket,
    "]": .rightSquareBracket,
    
    "{": .leftCurlyBracket,
    "}": .rightCurlyBracket,
    
    "+": .add,
    
    "−": .subtract, // MINUS SIGN
    "-": .subtract, // HYPHEN-MINUS
    
    "×": .multiply, // MULTIPLICATION SIGN
    "⋅": .multiply, // DOT OPERATOR
    "∗": .multiply, // ASTERISK OPERATOR
    "·": .multiply, // MIDDLE DOT
    "*": .multiply, // ASTERISK
    
    "÷": .divide, // DIVISION SIGN
    "∶": .divide, // RATIO
    "∕": .divide, // DIVISION SLASH
    "⁄": .divide, // FRACTION SLASH
    "/": .divide, // SOLIDUS
    ":": .divide, // COLON
    
    "mod": .remainder,
    
    "^": .power,
    
    "sqrt": .squareRoot,
    "√": .squareRoot,
    
    "cbrt": .cubeRoot,
    "∛": .cubeRoot,
    "؆": .cubeRoot,
    
    "∜": .fourthRoot,
    "؇": .fourthRoot,
    
    "log": .logarithm,
    "lb": .binaryLogarithm,
    "ln": .naturalLogarithm,
    "lg": .commonLogarithm,
    
    "sin": .sine,
    
    "cos": .cosine,
    
    "tan": .tangent,
    "tg": .tangent,
    
    "cot": .cotangent,
    "cotan": .cotangent,
    "cotg": .cotangent,
    "ctg": .cotangent,
    "ctn": .cotangent,
    
    "sec": .secant,
    
    "csc": .cosecant,
    "cosec": .cosecant,
    
    "arcsin": .arcsine,
    
    "arccos": .arccosine,
    
    "arctan": .arctangent,
    "arctg": .arctangent,
    
    "arccot": .arccotangent,
    "arccotan": .arccotangent,
    "arccotg": .arccotangent,
    "arcctg": .arccotangent,
    "arcctn": .arccotangent,
    
    "arcsec": .arcsecant,
    
    "arccsc": .arccosecant,
    "arccosec": .arccosecant,
    
    "abs": .modulus,
    
    "!": .factorial,
]
