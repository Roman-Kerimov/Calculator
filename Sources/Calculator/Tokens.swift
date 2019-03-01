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
    
    "sqrt": .sqrt,
    "√": .sqrt,
    
    "cbrt": .cbrt,
    "∛": .cbrt,
    "؆": .cbrt,
    
    "∜": .frrt,
    "؇": .frrt,
    
    "log": .log,
    "lb": .lb,
    "ln": .ln,
    "lg": .lg,
    
    
    "sin": .sin,
    
    "cos": .cos,
    
    "tan": .tan,
    "tg": .tan,
    
    "cot": .cot,
    "cotan": .cot,
    "cotg": .cot,
    "ctg": .cot,
    "ctn": .cot,
    
    "sec": .sec,
    
    "csc": .csc,
    "cosec": .csc,
    
    "arcsin": .arcsin,
    
    "arccos": .arccos,
    
    "arctan": .arctan,
    "arctg": .arctan,
    
    "arccot": .arccot,
    "arccotan": .arccot,
    "arccotg": .arccot,
    "arcctg": .arccot,
    "arcctn": .arccot,
    
    "arcsec": .arcsec,
    
    "arccsc": .arccsc,
    "arccosec": .arccsc,
    
    "abs": .abs,
    
    "!": .factorial,
]
