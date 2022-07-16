//
//  ViewController.swift
//  Calculator
//
//  Created by Nikita Lukyantsev on 10.07.2022.
//

import UIKit

// для преобразования тега в символ математической операции
public enum OperationTag: Int {
    case Plus = 0
    case Minus = 1
    case Multiplication = 2
    case Division = 3
    case GetResult = 4
}

// для преобразования тега в спец символ - точка или скобки
public enum SpecSymbolTag: Int {
    case Point = 0
    case LeftBracket = 1
    case RightBracket = 2
}

class ViewController: UIViewController {
    @IBOutlet weak var expression: UILabel!

    // ввод числа
    @IBAction func inputDigit(_ sender: UIButton) {
        if expression.text?.last != ")" {
            expression.text! += "\(sender.tag)"
        }
    }
    
    // ввод символа операции
    @IBAction func inputOperation(_ sender: UIButton) {
        let lastSymbol: Character = expression.text?.last ?? "\0"
        guard let tag = OperationTag(rawValue: sender.tag),
              lastSymbol.isNumber || lastSymbol == ")" ||
                tag == .Minus && (expression.text!.isEmpty || lastSymbol == "(")
        else { return }
        
        switch(tag) {
        case .Plus:
            expression.text! += "+"
        case .Minus:
            expression.text! += "-"
        case .Multiplication:
            expression.text! += "*"
        case .Division:
            expression.text! += "/"
        case .GetResult:
            let result = calculate(expressionStr: expression.text!)
            expression.text = "\(result)"
            break
        }
    }
    
    // ввод спец символа
    @IBAction func inputSpec(_ sender: UIButton) {
        guard let tag = SpecSymbolTag(rawValue: sender.tag)
        else { return }
        
        switch(tag) {
        case .Point:
            if expression.text!.isEmpty {
                expression.text! += "0."
            }
            else if let isNum = expression.text?.last?.isNumber, isNum {
                expression.text! += "."
            }
        case .LeftBracket:
            if expression.text!.isEmpty || expression.text!.last == "(" || isActionSymbol(expression.text!.last!) {
                expression.text! += "("
            }
        case .RightBracket:
            if let lastSymbol = expression.text!.last,
                   lastSymbol == ")" || lastSymbol.isNumber {
                
                guard let leftBracketCount = expression.text?.filter({ $0 == "(" }).count,
                      let rightBracketCount = expression.text?.filter({ $0 == ")" }).count,
                      leftBracketCount > rightBracketCount
                else { return }
                
                expression.text! += ")"
            }
        }
    }
    
    // очистка поля ввода
    @IBAction func clear(_ sender: UIButton) {
        expression.text = ""
    }
    
    // стирание последнего символа
    @IBAction func backspace(_ sender: Any) {
        guard var inputText = expression.text
        else { return }
        
        inputText.remove(at: inputText.index(before: inputText.endIndex))
        expression.text! = inputText
    }
    
    private func isActionSymbol(_ symbol: Character) -> Bool {
        return symbol == "+" || symbol == "-" || symbol == "*" || symbol == "/"
    }
    
    private func calculate(expressionStr: String) -> Double {
        let mathExpression = NSExpression(format: expressionStr)
        return (mathExpression.expressionValue(with: nil, context: nil) as? Double)!
    }
}

